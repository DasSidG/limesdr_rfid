%This program tries to find the points at the beginning and end of
%communication blocks
%It then subtracts these to figure out the timings of the various parts of
%the RFID comms transactions

tic;

'Remember to set first_sample and last_sample'

%Useful constants
decim = 5; %decimation of matched filter
samp_rate = 3.35 * 2 * 10^6/decim;
%samp_rate = 2 * 10^6/decim;
max_num_queries = 1200; %Used for pre-allocation, set this to be a bit above what the maximum number of queries expected is


first_sample = 2.188 * 10^6;
last_sample = 1.281*10^7;

% max_query_dur_us = 1000; %roughly
% ACK_dur_us = 750; %roughly
% 
% RN16_dur_us = 700; %roughly
% EPC_dur_us = 3300; %roughly


%fi_1 = fopen('../data/matched_filter','rb');
fi_1 = fopen('../matched_filter','rb');
x_inter_1 = fread(fi_1, 'float32');

% Data is complex - combine real & imaginary parts
%matched_samples = x_inter_1(first_sample+1:2:last_sample+1) + 1i*x_inter_1(first_sample+2:2:last_sample+2);
matched_samples = x_inter_1(1:2:end) + 1i*x_inter_1(2:2:end);
%matched_samples = x_inter_1(1:2:1000000) + 1i*x_inter_1(2:2:1000000);
matched_samples_abs = abs(matched_samples);

plot (abs(matched_samples));
figure()
matched_samples_abs = matched_samples_abs(first_sample:last_sample);


%plot(matched_samples_abs);

%bob = beginning of block
%eob = end of block

last_bob = 1;
last_eob = 1;

last_query_bob = 1;
last_query_eob = 1;

last_RN16_bob = 1;
last_RN16_eob = 1;

last_ACK_bob = 1;
last_ACK_eob = 1;

last_EPC_bob = 1;
last_EPC_eob = 1;

bobs = zeros(max_num_queries*5, 1);
eobs = zeros(max_num_queries*5, 1);

query_bobs = zeros(max_num_queries, 1);
query_eobs = zeros(max_num_queries, 1);

RN16_bobs = zeros(max_num_queries, 1);
RN16_eobs = zeros(max_num_queries, 1);

ACK_bobs = zeros(max_num_queries, 1);
ACK_eobs = zeros(max_num_queries, 1);

EPC_bobs = zeros(max_num_queries, 1);
EPC_eobs = zeros(max_num_queries, 1);


query_durations = zeros(max_num_queries, 1);
RN16_durations = zeros(max_num_queries, 1);
ACK_durations = zeros(max_num_queries, 1);
EPC_durations = zeros(max_num_queries, 1);
EPC_valid_flags = zeros(max_num_queries, 1);
ACK_valid_flags = zeros(max_num_queries, 1);

query_to_RN16_durations = zeros(max_num_queries, 1);
RN16_to_ACK_durations = zeros(max_num_queries, 1);
ACK_to_EPC_durations = zeros(max_num_queries, 1);

succ_query_to_RN16_durations = zeros(max_num_queries, 1);
succ_RN16_to_ACK_durations = zeros(max_num_queries, 1);
succ_ACK_to_EPC_durations = zeros(max_num_queries, 1);

succ_query_durations = zeros(max_num_queries, 1);
succ_RN16_durations = zeros(max_num_queries, 1);
succ_ACK_durations = zeros(max_num_queries, 1);

unsucc_query_to_RN16_durations = zeros(max_num_queries, 1);
unsucc_RN16_to_ACK_durations = zeros(max_num_queries, 1);

unsucc_ACK_valid_flags = zeros(max_num_queries, 1);

unsucc_query_durations = zeros(max_num_queries, 1);
unsucc_RN16_durations = zeros(max_num_queries, 1);
unsucc_ACK_durations = zeros(max_num_queries, 1);
valid_ACK_no_EPC_RN16_to_ACK_durations = zeros(max_num_queries, 1);


RN16_bits_record = strings(max_num_queries,1);
ACK_bits_record = strings(max_num_queries,1);

query_index = 1;
unsucc_query_index = 1;
RN16_index = 1;
ACK_index = 1;
EPC_index = 1;

bob_index = 1;
eob_index = 1;


averaging_range = round(50/10^6 * samp_rate); %Average over 50us worth of samples
samp_ms = 1/10^3 * samp_rate; %number of samples in a ms

last_block = 'EPC';

missed_blocks = 0;

for global_sample_loc = averaging_range+1:(size(matched_samples_abs)-averaging_range)
    next_data_subset = matched_samples_abs(global_sample_loc:global_sample_loc+averaging_range);
    prev_data_subset = matched_samples_abs((global_sample_loc-averaging_range):global_sample_loc);
    %First check for bob
    if (global_sample_loc > last_bob + 0.5*samp_ms) && ...
        std(next_data_subset) > 10*std(prev_data_subset)
        %Have found a bob
        last_bob = global_sample_loc;
        bobs(bob_index) =  last_bob;
        bob_index = bob_index + 1;
    %Otherwise check for eob
    elseif (global_sample_loc > last_eob + 0.5*samp_ms) && ...
            (global_sample_loc > last_bob + 0.5*samp_ms) && ...
            std(prev_data_subset) > 10*std(next_data_subset)
        %Have found an eob
        last_eob = global_sample_loc;
        eobs(eob_index) = last_eob;
        eob_index = eob_index + 1;
        
        %Block has ended, so try and classify what kind of block this is
        %Block is either query or EPC
        if last_eob - last_bob > 2000/10^6*samp_rate
            last_block = 'EPC';
            last_EPC_bob = last_bob;
            last_EPC_eob = last_eob;
            EPC_bobs(EPC_index) = last_bob;
            EPC_eobs(EPC_index) = last_eob;
            EPC_durations(EPC_index) = last_eob-last_bob;
            ACK_to_EPC_durations(EPC_index) = last_bob-last_ACK_eob;
            
            %Check to see if the EPC was valid
            EPC_valid_flags(EPC_index) = decode_EPC(matched_samples_abs(last_bob:last_eob+50), samp_rate);
            
            
            %This was a successful exchange, so record the durations out of
            %interest
            succ_query_to_RN16_durations(EPC_index) = last_RN16_bob-last_query_eob;
            succ_RN16_to_ACK_durations(EPC_index) = last_ACK_bob-last_RN16_eob;
            succ_ACK_to_EPC_durations(EPC_index) = last_EPC_bob-last_ACK_eob;
            
            succ_query_durations(EPC_index) = last_query_eob - last_query_bob;
            succ_RN16_durations(EPC_index) = last_RN16_eob - last_RN16_bob;
            succ_ACK_durations(EPC_index) = last_ACK_eob - last_ACK_bob;
            
            EPC_index = EPC_index + 1;
        elseif strcmp(last_block,'RN16')
            %last block was RN16, and was not long enough to be another
            %query or an EPC, so must be an ACK
            last_block = 'ACK';
            last_ACK_bob = last_bob;
            last_ACK_eob = last_eob;
            ACK_bobs(ACK_index) = last_bob;
            ACK_eobs(ACK_index) = last_eob;
            ACK_durations(ACK_index) = last_eob-last_bob;
            RN16_to_ACK_durations(ACK_index) = last_bob-last_RN16_eob;
            
            %Check to see if the RN16 given by this ACK matches the RN16
            %last given by the tag
            ACK_RN16_bits = decode_ACK(matched_samples_abs(last_bob:last_eob+50), samp_rate);
            %Convert to a single number rather than a vector of many bits
            for i = 1:length(ACK_RN16_bits)
                ACK_bits_record(ACK_index) = strcat(ACK_bits_record(ACK_index), num2str(ACK_RN16_bits(i)));
            end
            RN16_bits = decode_RN16(matched_samples_abs(last_RN16_bob:last_RN16_eob+50), samp_rate);
            ACK_valid_flags(ACK_index) = isequal(ACK_RN16_bits, RN16_bits);
            ACK_index = ACK_index + 1;
        elseif last_eob - last_bob > 800/10^6*samp_rate
            
            %First check if the last block was an EPC. If not, then that
            %means that the last query was unsuccessful, so let's record
            %some statistics about that.
            if ~strcmp(last_block, 'EPC')
                if strcmp(last_block, 'ACK')
                    %This is the most lilkely scenario if we didnt get an
                    %EPC last time
                    unsucc_query_to_RN16_durations(unsucc_query_index) = last_RN16_bob-last_query_eob;
                    unsucc_RN16_to_ACK_durations(unsucc_query_index) = last_ACK_bob-last_RN16_eob;
                    unsucc_ACK_valid_flags(unsucc_query_index) = ACK_valid_flags(ACK_index-1);
                    
                    %Record all the query attempts where the ACK matched the RN16, but still no
                    %EPC was given
                    if unsucc_ACK_valid_flags(unsucc_query_index)
                        valid_ACK_no_EPC_RN16_to_ACK_durations(unsucc_query_index) = unsucc_RN16_to_ACK_durations(unsucc_query_index);
                    end 
                    
                    unsucc_query_durations(unsucc_query_index) = last_query_eob - last_query_bob;
                    unsucc_RN16_durations(unsucc_query_index) = last_RN16_eob - last_RN16_bob;
                    unsucc_ACK_durations(unsucc_query_index) = last_ACK_eob - last_ACK_bob;
                    
                    
                elseif strcmp(last_block, 'RN16')
                    %Very rare, as this would imply that an ACK was not
                    %sent after the RN16
                    unsucc_query_to_RN16_durations(unsucc_query_index) = last_RN16_bob-last_query_eob;
                    
                    unsucc_query_durations(unsucc_query_index) = last_query_eob - last_query_bob;
                    unsucc_RN16_durations(unsucc_query_index) = last_RN16_eob - last_RN16_bob;
                else
                    unsucc_query_durations(unsucc_query_index) = last_query_eob - last_query_bob;
                end
                unsucc_query_index = unsucc_query_index + 1;
            end
            
            
            last_block = 'QUERY';
            last_query_bob = last_bob;
            last_query_eob = last_eob;
            query_bobs(query_index) = last_bob;
            query_eobs(query_index) = last_eob;
            query_durations(query_index) = last_eob-last_bob;
            query_index = query_index +1;
        elseif strcmp(last_block,'QUERY')
            %last block was query, and was not long enough to be another
            %query or an EPC, so must be an RN16
            last_block = 'RN16';
            last_RN16_bob = last_bob;
            last_RN16_eob = last_eob;
            RN16_bobs(RN16_index) = last_bob;
            RN16_eobs(RN16_index) = last_eob;  
            RN16_durations(RN16_index) = last_eob-last_bob;
            query_to_RN16_durations(RN16_index) = last_bob-last_query_eob;
            RN16_bits = decode_RN16(matched_samples_abs(last_RN16_bob:last_RN16_eob+50), samp_rate);
            
            %Convert to a single number rather than a vector of many bits
            for i = 1:length(RN16_bits)
                RN16_bits_record(RN16_index) = strcat(RN16_bits_record(RN16_index), num2str(RN16_bits(i)));
            end
             
            
            RN16_index = RN16_index + 1;
        else
            missed_blocks = missed_blocks + 1;
        end
    end   
end





for i = 1:unsucc_query_index - 1
    
end

%Now shorten all the various vectors to only include the values actually
%populated during the loop.

bobs(bob_index:length(bobs)) = [];
eobs(eob_index:length(eobs)) =[];

query_bobs(query_index:length(query_bobs)) = [];
query_eobs(query_index:length(query_eobs)) = [];

RN16_bobs(RN16_index:length(RN16_bobs)) = [];
RN16_eobs(RN16_index:length(RN16_eobs)) = [];

ACK_bobs(ACK_index:length(ACK_bobs)) = [];
ACK_eobs(ACK_index:length(ACK_eobs)) = [];

EPC_bobs(EPC_index:length(EPC_bobs)) = [];
EPC_eobs(EPC_index:length(EPC_eobs)) = [];

RN16_bits_record(RN16_index:length(RN16_bits_record)) = [];


query_durations(query_index:length(query_durations)) = [];
RN16_durations(RN16_index:length(RN16_durations)) = [];
ACK_durations(ACK_index:length(ACK_durations)) = [];
EPC_durations(EPC_index:length(EPC_durations)) = [];
EPC_valid_flags(EPC_index:length(EPC_valid_flags)) = [];
ACK_valid_flags(ACK_index:length(ACK_valid_flags)) = [];

query_to_RN16_durations(RN16_index:length(query_to_RN16_durations)) = [];
RN16_to_ACK_durations(ACK_index:length(RN16_to_ACK_durations)) = [];
ACK_to_EPC_durations(EPC_index:length(ACK_to_EPC_durations)) = [];

succ_query_to_RN16_durations(EPC_index:length(succ_query_to_RN16_durations)) = [];
succ_RN16_to_ACK_durations(EPC_index:length(succ_RN16_to_ACK_durations)) = [];
succ_ACK_to_EPC_durations(EPC_index:length(succ_ACK_to_EPC_durations)) = [];

succ_query_durations(EPC_index:length(succ_query_durations)) = [];
succ_RN16_durations(EPC_index:length(succ_RN16_durations)) = [];
succ_ACK_durations(EPC_index:length(succ_ACK_durations)) = [];

unsucc_query_to_RN16_durations(unsucc_query_index:length(unsucc_query_to_RN16_durations)) = [];
unsucc_RN16_to_ACK_durations(unsucc_query_index:length(unsucc_RN16_to_ACK_durations)) = [];
unsucc_ACK_valid_flags(unsucc_query_index:length(unsucc_ACK_valid_flags)) =[];
unsucc_query_durations(unsucc_query_index:length(unsucc_query_durations)) = [];
unsucc_RN16_durations(unsucc_query_index:length(unsucc_RN16_durations)) = [];
unsucc_ACK_durations(unsucc_query_index:length(unsucc_ACK_durations)) = [];
valid_ACK_no_EPC_RN16_to_ACK_durations(unsucc_query_index:length(valid_ACK_no_EPC_RN16_to_ACK_durations)) = [];

plot(matched_samples_abs)
hold on;
plot(bobs, matched_samples_abs(bobs), '*')
plot(eobs, matched_samples_abs(eobs), 'x')

%Convert durations to microseconds
query_to_RN16_durations = query_to_RN16_durations/samp_rate*10^6;
RN16_to_ACK_durations = RN16_to_ACK_durations/samp_rate*10^6;
ACK_to_EPC_durations = ACK_to_EPC_durations/samp_rate*10^6;

succ_query_to_RN16_durations = succ_query_to_RN16_durations/samp_rate*10^6;
succ_RN16_to_ACK_durations = succ_RN16_to_ACK_durations/samp_rate*10^6;
succ_ACK_to_EPC_durations = succ_ACK_to_EPC_durations/samp_rate*10^6;

query_durations = query_durations/samp_rate*10^6;
ACK_durations = ACK_durations/samp_rate*10^6;
RN16_durations = RN16_durations/samp_rate*10^6;
EPC_durations = EPC_durations/samp_rate*10^6;

succ_query_durations = succ_query_durations/samp_rate*10^6;
succ_RN16_durations = succ_RN16_durations/samp_rate*10^6;
succ_ACK_durations = succ_ACK_durations/samp_rate*10^6;

unsucc_query_to_RN16_durations =unsucc_query_to_RN16_durations/samp_rate*10^6;
unsucc_RN16_to_ACK_durations = unsucc_RN16_to_ACK_durations/samp_rate*10^6;
valid_ACK_no_EPC_RN16_to_ACK_durations = valid_ACK_no_EPC_RN16_to_ACK_durations/samp_rate*10^6;

unsucc_query_durations = unsucc_query_durations/samp_rate*10^6;
unsucc_RN16_durations = unsucc_RN16_durations/samp_rate*10^6;
unsucc_ACK_durations = unsucc_ACK_durations/samp_rate*10^6;

%Remove outliers from duration data
query_to_RN16_durations_sanitised = query_to_RN16_durations(query_to_RN16_durations < 2*median(query_to_RN16_durations));
mean_query_to_RN16_durations = mean(query_to_RN16_durations_sanitised);

RN16_to_ACK_durations_sanitised = RN16_to_ACK_durations(RN16_to_ACK_durations < 2* median(RN16_to_ACK_durations));
mean_RN16_to_ACK_durations = mean(RN16_to_ACK_durations_sanitised)

ACK_to_EPC_durations_sanitised = ACK_to_EPC_durations(ACK_to_EPC_durations<2*median(ACK_to_EPC_durations));
mean_ACK_to_EPC_durations = mean(ACK_to_EPC_durations_sanitised);

succ_query_to_RN16_durations_sanitised = succ_query_to_RN16_durations(succ_query_to_RN16_durations < 2*median(succ_query_to_RN16_durations));
mean_succ_query_to_RN16_durations = mean(succ_query_to_RN16_durations_sanitised);

succ_RN16_to_ACK_durations_sanitised = succ_RN16_to_ACK_durations(succ_RN16_to_ACK_durations < 2* median(succ_RN16_to_ACK_durations));
mean_succ_RN16_to_ACK_durations = mean(succ_RN16_to_ACK_durations_sanitised);

succ_ACK_to_EPC_durations_sanitised = succ_ACK_to_EPC_durations(succ_ACK_to_EPC_durations<2*median(succ_ACK_to_EPC_durations));
mean_succ_ACK_to_EPC_durations = mean(succ_ACK_to_EPC_durations_sanitised);

query_durations_sanitised = query_durations(query_durations<2*median(query_durations));
mean_query_durations = mean(query_durations_sanitised);

ACK_durations_sanitised = ACK_durations(ACK_durations < 2*median(ACK_durations));
mean_ACK_durations = mean(ACK_durations_sanitised);

RN16_durations_sanitised = RN16_durations(RN16_durations < 2*median(RN16_durations));
mean_RN16_durations = mean(RN16_durations_sanitised);

EPC_durations_sanitised = EPC_durations(EPC_durations < 2*median(EPC_durations));
mean_EPC_durations = mean(EPC_durations_sanitised);

%use a higher threshold of outliers for the unsuccessful runs
unsucc_query_to_RN16_durations_sanitised = unsucc_query_to_RN16_durations(unsucc_query_to_RN16_durations < 4* median(unsucc_query_to_RN16_durations));
mean_unsucc_query_to_RN16_durations = mean(unsucc_query_to_RN16_durations_sanitised);

unsucc_RN16_to_ACK_durations_sanitised = unsucc_RN16_to_ACK_durations(unsucc_RN16_to_ACK_durations < 4*median(unsucc_RN16_to_ACK_durations));
mean_unsucc_RN16_to_ACK_durations = mean(unsucc_RN16_to_ACK_durations_sanitised);

unsucc_query_durations_sanitised = unsucc_query_durations(unsucc_query_durations < 4*median(unsucc_query_durations));
mean_unsucc_query_durations = mean(unsucc_query_durations_sanitised);

unsucc_RN16_durations_sanitised = unsucc_RN16_durations(unsucc_RN16_durations < 4*median(unsucc_RN16_durations));
mean_unsucc_RN16_durations = mean(unsucc_RN16_durations_sanitised);

unsucc_ACK_durations_sanitised = unsucc_ACK_durations(unsucc_ACK_durations < 4*median(unsucc_ACK_durations));
mean_unsucc_ACK_durations = mean(unsucc_ACK_durations_sanitised);

valid_ACK_no_EPC_RN16_to_ACK_durations_sanitised = valid_ACK_no_EPC_RN16_to_ACK_durations(valid_ACK_no_EPC_RN16_to_ACK_durations > 0); %also want to get rid of all of the zero-valued entries
valid_ACK_no_EPC_RN16_to_ACK_durations_sanitised = valid_ACK_no_EPC_RN16_to_ACK_durations_sanitised(valid_ACK_no_EPC_RN16_to_ACK_durations_sanitised < 4*median(valid_ACK_no_EPC_RN16_to_ACK_durations_sanitised));

mean_valid_ACK_no_EPC_RN16_to_ACK_durations = mean(valid_ACK_no_EPC_RN16_to_ACK_durations_sanitised);

num_invalid_ACKs = unsucc_query_index - sum(unsucc_ACK_valid_flags) - 1;




num_queries = query_index - 1
num_RN16 = RN16_index - 1
num_ACK = ACK_index - 1
num_EPC = EPC_index - 1

std_RN16_to_ACK_durations = std(RN16_to_ACK_durations_sanitised)

runtime = toc;
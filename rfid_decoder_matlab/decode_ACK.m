function [ACK_RN16_bits] = decode_ACK(vec,samp_rate)
%Given an input vector vec which just containts the samples corresponding
%to an ACK, it finds the ACK RN16 bits.
%   samp_rate is the sampling rate used for the samples

%The way this algorithm works is it first calculates the amplitude midway
%between the two modulation points of the RN16/EPC. It then works out
%whether each bit is a 1 or 0 by looking at the difference in number of
%samples between each pair of consecutive midpoint crossings. A 1 from a
%tag is 25us between a pair of midpoint crossings, a 0 is two pairs of
%midpoint crossings 12.5us apart
    cw_amp = max(vec);
    vec = vec-cw_amp;
    abs_vec = abs(vec);
    max_amp = max(abs_vec);
    mid_ampl = max_amp/2;
    bit_duration = 25*10^-6 * samp_rate;
    half_bit_duration = bit_duration/2;
    
    %First populate a vector of the interpolated midpoint crossings
    midpoint_locs = [];
    last_loc = -Inf;
    
    for i = 1: length(abs_vec)-1
        if (i > last_loc + 20*10^-6*samp_rate) && ((abs_vec(i) - mid_ampl)*(abs_vec(i+1) - mid_ampl) < 0) %i.e. are at a midpoint crossing
            %At this level the sampling is relatively coarse in the matched
            %filter, so linearly interpolate to find the time at which it
            %actually crossed the midpoint
            midpoint_locs = [midpoint_locs, ((mid_ampl-abs_vec(i))/(abs_vec(i+1)-abs_vec(i)))+i];
        end
    end
    
    %Decode the ACK based in durations in between midpoint crossings. Note
    %that the 8th midpoint is the end of the tag preamble, so can start
    %from there.
    ACK_RN16_bits = [];
    
    % A 1 means that the last midpoint state was the end of a bit, 
    % a 0 means that it was midway through a 0 bit
    last_midpoint_state = 1; 
    
    for i = 11:length(midpoint_locs)
        if last_midpoint_state == 1
            if midpoint_locs(i) - midpoint_locs(i-1) <1.3*half_bit_duration
                ACK_RN16_bits = [ACK_RN16_bits, 0];
            else
                ACK_RN16_bits = [ACK_RN16_bits, 1];
            end
            last_midpoint_state = 0;
        else
            last_midpoint_state = 1;
        end 
    end
%     %Stuff to do with plotting to help develop this code
%     mid_ampl_vec = mid_ampl * ones(length(midpoint_locs),1);
%     plot(abs_vec);
%     hold on;
%     plot(midpoint_locs, mid_ampl_vec, '*');
end


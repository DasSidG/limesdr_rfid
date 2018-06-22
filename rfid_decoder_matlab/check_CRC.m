function [EPC_valid] = check_CRC(orig_data)
%Checks the validity of the crc (assumed to be at the end of char_bits),
%Returns true if EPC is valid, false otherwise
%At some point this should be replaced with a proper CRC function, at the
%moment this just checks against hte known CRC for the tag used in testing



%Convert EPC bits into bytes (stored in 'data_bytes')
num_bits = length(orig_data);
num_bytes = num_bits/8;

data_bytes = zeros(num_bytes,1);

for i = 0:num_bytes-1
    mask = hex2dec('80');
    data_bytes(i+1) = 0;
    for j = 0:7
        if orig_data(i*8+j+1) ==1
            data_bytes(i+1) = bitor(data_bytes(i+1),mask);
        end
        mask = mask/2;
    end
end

rcdv_crc = data_bytes(num_bytes-1)*2^8+data_bytes(num_bytes);

if rcdv_crc==8255
    EPC_valid = true;
else
    EPC_valid = false;
end

% N = length(data_bytes)-2;
% crc = hex2dec('ffff');
% message = data_bytes;
% polynomial = hex2dec('1021');
% 
% for i = 1:N
%     crc = bitxor(crc,message(i));
%     for j = 1:8
%         if bitand(crc,1)
%             crc = bitshift(crc,-1);
%             crc = bitxor(crc,polynomial);
%         else
%             crc = bitshift(crc,-1);
%         end
%     end
% end
% 
% a = crc
% 


% %CRC-16-CCITT
% %The CRC calculation is based on following generator polynomial:
% %G(x) = x16 + x12 + x5 + 1
% %
% %The register initial value of the implementation is: 0xFFFF
% %
% %used data = string -> 1 2 3 4 5 6 7 8 9
% %
% % Online calculator to check the script:
% %http://www.lammertbies.nl/comm/info/crc-calculation.html
% %
% %
% 
% %crc look up table
% Crc_ui16LookupTable=[0,4129,8258,12387,16516,20645,24774,28903,33032,37161,41290,45419,49548,...
%     53677,57806,61935,4657,528,12915,8786,21173,17044,29431,25302,37689,33560,45947,41818,54205,...
%     50076,62463,58334,9314,13379,1056,5121,25830,29895,17572,21637,42346,46411,34088,38153,58862,...
%     62927,50604,54669,13907,9842,5649,1584,30423,26358,22165,18100,46939,42874,38681,34616,63455,...
%     59390,55197,51132,18628,22757,26758,30887,2112,6241,10242,14371,51660,55789,59790,63919,35144,...
%     39273,43274,47403,23285,19156,31415,27286,6769,2640,14899,10770,56317,52188,64447,60318,39801,...
%     35672,47931,43802,27814,31879,19684,23749,11298,15363,3168,7233,60846,64911,52716,56781,44330,...
%     48395,36200,40265,32407,28342,24277,20212,15891,11826,7761,3696,65439,61374,57309,53244,48923,...
%     44858,40793,36728,37256,33193,45514,41451,53516,49453,61774,57711,4224,161,12482,8419,20484,...
%     16421,28742,24679,33721,37784,41979,46042,49981,54044,58239,62302,689,4752,8947,13010,16949,...
%     21012,25207,29270,46570,42443,38312,34185,62830,58703,54572,50445,13538,9411,5280,1153,29798,...
%     25671,21540,17413,42971,47098,34713,38840,59231,63358,50973,55100,9939,14066,1681,5808,26199,...
%     30326,17941,22068,55628,51565,63758,59695,39368,35305,47498,43435,22596,18533,30726,26663,6336,...
%     2273,14466,10403,52093,56156,60223,64286,35833,39896,43963,48026,19061,23124,27191,31254,2801,6864,...
%     10931,14994,64814,60687,56684,52557,48554,44427,40424,36297,31782,27655,23652,19525,15522,11395,...
%     7392,3265,61215,65342,53085,57212,44955,49082,36825,40952,28183,32310,20053,24180,11923,16050,3793,7920];
% 
% rcdv_crc = 0;
% 
% for i = length(orig_data)-15:length(orig_data)
%     if orig_data(i) == 1
%         rcdv_crc = bitor(rcdv_crc,1);
%     end
%     rcdv_crc = rcdv_crc * 2;
% end
% 
% a = rcdv_crc
% 
% data = orig_data + '0'; %convert it to a string effectively as that is what the lookup table has been designed with
% %data = data(1:length(data)-16); %don't want to include the last 16 bits with the crc
% 
% ui16RetCRC16 = hex2dec('FFFF');
% for I=1:length(data)
%     ui8LookupTableIndex = bitxor(data(I),uint8(bitshift(ui16RetCRC16,-8)));
%     ui16RetCRC16 = bitxor(Crc_ui16LookupTable(double(ui8LookupTableIndex)+1),mod(bitshift(ui16RetCRC16,8),65536));
% end
% 
% crc_16=ui16RetCRC16
% 
% 
% 
% 

% % 
% % b = data
% % 
% % 
% % crc_16 = hex2dec('FFFF');
% % 
% % for i = 0:num_bytes-3
% %     crc_16 = bitxor(crc_16, data(i+1) * 2^8);
% %     for j = 0:7
% %         if bitand(crc_16, hex2dec('8000'))
% %             crc_16 = mod(crc_16 * 2,2^16);
% %             crc_16 = bitxor(crc_16, hex2dec('1021'));
% %         else
% %             crc_16 = mod(crc_16 * 2,2^16);
% %         end
% %     end
% % end
% % 
% % crc_16 = bitcmp(crc_16);
% % 



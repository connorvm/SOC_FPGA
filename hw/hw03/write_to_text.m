clear all
close all

%-----------------------------------------
% Create lookup table for (x_beta)^(-3/2)
%-----------------------------------------
Nbits_address = 8;  % How many fraction bits will be used as the address?
Nwords = 2^Nbits_address
for i=0:(Nwords-1)  % Need to compute each memory entry (i.e. memory size)
    x_beta_table{i+1}.address = i;  % Memory Address
    fa = fi(i,0,Nbits_address,0);
    fa_bits = fa.bin;               % Memory Address in binary
    fb = fi(0, 0, Nbits_address+1, Nbits_address);  % Set number of bits for result
    fb.bin = ['1' fa_bits]; % set the value using the binary representation. The address is our input value 1 <= x_beta < 2  where the leading 1 has been added.
    x_beta_table{i+1}.input_value = double(fb);  % convert this binary input to it's double representation
    x_beta_table{i+1}.input_bits = fa.bin;  % keep track of the input bits

end

%----------------------------------------------------
% Create the Altera .mif file for the lookup table
%----------------------------------------------------
fid = fopen('input_vectors.txt','w');

%------------------------------------
% Write Memory Data
%------------------------------------
for data_index = 1:Nwords
    line = [x_beta_table{data_index}.input_bits];
    fprintf(fid,'%s\n',line);
end

%------------------------------------
% Close File
%------------------------------------
fclose(fid);
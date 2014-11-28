function data = read_RAW_file(filename,datatype,endianness)
% data = read_RAW_file(filename,datatype)
% datatype is a string e.g. 'float32', 'int16' etc.
% endianness can be 'l' for little endian or 'b' for big endian (optional,
%   if left unspecified the native endianness is used ).
% - returns the samples in a 1 x D matrix
if nargin  < 3
    endianness = 'n';
end

file = fopen(filename,'r',endianness);

data = fread(file,datatype);
fclose(file);

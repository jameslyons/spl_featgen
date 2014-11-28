function write_RAW_file(data, filename, datatype, endianness)
% write_RAW_file(data, filename, datatype, endianness)
% - write 'data' to the RAW formatted file with name 'filename'
% - data is in a 1 x N matrix
% datatype is e.g. 'int16' or 'float32'
% endianness is either 'l' or 'b' (optional).
if nargin  < 4
    endianness = 'n';
end
mfcfile = fopen(filename,'w',endianness);

fwrite(mfcfile,data,datatype);
fclose(mfcfile);

function write_NIST_file(filename,data,header)
%function write_NIST_file(filename,data,header)

file = fopen(filename,'w');
fwrite(file,header,'char');
fwrite(file,data,'int16');
fclose(file);

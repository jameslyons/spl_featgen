function write_HTK_file(data, filename, sampr, options)
% - function write_HTK_file(data, filename, sampr, options)
% - write 'data' to the HTK formatted file with name 'filename'
% - data is in a N x D matrix

mfcfile = fopen(filename,'w','b');
[nSamples, sampSize] = size(data);

fwrite(mfcfile,nSamples,'int');
fwrite(mfcfile,sampr,'int');
fwrite(mfcfile,sampSize*4,'int16');
fwrite(mfcfile,options,'int16');

fwrite(mfcfile,data','float');
fclose(mfcfile);
function [data,sampr,options] = read_HTK_file(filename)
% [data,sampr,options] = read_HTK_file(filename)
% - reads the HTK formatted file with name 'filename'
% - returns the samples in a N x D matrix

mfcfile = fopen(filename,'r','b');
nSamples = fread(mfcfile,1,'int');
sampr = fread(mfcfile,1,'int');
sampSize = fread(mfcfile,1,'int16')/4;
options = fread(mfcfile,1,'int16');

%data = zeros(sampSize,nSamples);
data = fread(mfcfile,[sampSize,nSamples],'float');
data = data';
fclose(mfcfile);

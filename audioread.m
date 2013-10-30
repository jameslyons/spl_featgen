function [sig,fs,header] = audioread(fname)
% read a NIST or wav file

% does file exist?
if exist(fname, 'file') ~= 2
    error(['audioread: file "',fname,'" does not exist or is not a file.']);
end

% try to read it as a wav
%iswave = 1;
try
    [sig,fs] = wavread(fname); 
    sig = sig';
    header = '';
catch err
    if (strcmp(err.identifier,'wavread:InvalidFile'))
        [sig,fs,header] = read_NIST_file(fname); 
        %iswave = 0;
    else
        rethrow(err);
    end
end

%if ~iswave   % couldn't open it as a wav, open it as a NIST
%    [sig,fs,header] = read_NIST_file(fname); 
%end
    
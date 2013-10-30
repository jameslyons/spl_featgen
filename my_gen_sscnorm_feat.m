function  my_gen_sscnorm_feat(nbands)
% the job of this script is to take a file "~files.txt" of wav
% files 1 per line and create mfc files from them

filelistname='../~allfiles.txt';
filelist = fopen(filelistname);
fname = fgetl(filelist);
numfile = 0;
NFFT=512;
fs = 16000;
H = get_mel_filterbank(26,NFFT/2,fs);

mean1 = [];
std1 = [];
while ischar(fname)

    speech = audioread(fname);
    frames = frame_sig(speech,0.025*fs,0.01*fs,@(x)hamming(x));
    pspec = abs(fft(frames,NFFT,2)).^2;
    pspec = pspec(:,1:NFFT/2);    
    
    R = repmat(1:size(pspec,2),size(pspec,1),1);
    a1 = H*(pspec'.*R') ./ (H*pspec');
    a1 = a1';
    if numfile==0 % first time through, measure mean and variance of file. Doesn't matter if it is not very accurate.
        mean1 = mean(a1);
        std1 = std(a1);
    end
    a1 = a1 - repmat(mean1,size(a1,1),1);
    a1 = a1 ./ repmat(std1,size(a1,1),1);

    [a b c] = fileparts(fname);
    newname = [a,'/',b,'.msscn'];
  %  fprintf('writing "%s" %dx%d\n', newname, size(X,1), size(X,2));
    write_HTK_file(a1,newname,10000,6);    

    fname = fgetl(filelist);
    numfile = numfile + 1;
    if mod(numfile,100) == 0
        fprintf(',');
    end
end
fprintf('Number of files processed (sscn) = %d\n',numfile);

fclose(filelist);




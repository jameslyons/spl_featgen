function my_gen_logfb_feat(nbands)
% the job of this script is to take a file "~files.txt" of wav
% files 1 per line and create mfc files from them

filelistname='../~allfiles.txt';
filelist = fopen(filelistname);
fname = fgetl(filelist);
numfile = 0;
NFFT=512;
fs = 16000;
H = get_mel_filterbank(26,NFFT/2,fs);

while ischar(fname)

    speech = audioread(fname);
    frames = frame_sig(speech,0.025*fs,0.01*fs,@(x)hamming(x));
    pspec = abs(fft(frames,NFFT,2)).^2;
    pspec = pspec(:,1:NFFT/2);    
    lfbe = log(pspec*H');   
    %lfbe = log(pspec);
    %lfbe = frames;
    [a b c] = fileparts(fname);
    newname = [a,'/',b,'.mlogfb'];
  %  fprintf('writing "%s" %dx%d\n', newname, size(X,1), size(X,2));
    write_HTK_file(lfbe,newname,10000,6);    

    fname = fgetl(filelist);
    numfile = numfile + 1;
    if mod(numfile,100) == 0
        fprintf(',');
    end
end
fprintf('Number of files processed (logfb) = %d\n',numfile);

fclose(filelist);




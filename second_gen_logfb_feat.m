function second_gen_logfb_feat(nbands)
% the job of this script is generate log filterbank energies
% - it generates basic features as well as whitened versions.
% - it depends on there being text files called '~train.txt','~allfiles.txt'
%   which have 1 file name per line.
NFFT=512;
fs = 16000;
H = get_mel_filterbank(26,NFFT/2,fs);
alldata = {};
totalsize = 0;
pass = 0;

for filelistname={'../~train.txt','../~allfiles.txt'}
    filelist = fopen(char(filelistname));
    fname = fgetl(filelist);
    numfile = 0;
    fprintf('%s:',char(filelistname));
    while ischar(fname)
        
        speech = audioread(fname);
        frames = frame_sig(speech,0.025*fs,0.01*fs,@(x)hamming(x));
        pspec = abs(fft(frames,NFFT,2)).^2;
        pspec = pspec(:,1:NFFT/2);
        lfbe = log(pspec*H');
        %lfbe = log(pspec);
        %lfbe = frames;
        
        if pass == 0
            fname = fgetl(filelist);
            numfile = numfile + 1;
            alldata{numfile} = lfbe;
            [L,W] = size(lfbe);
            totalsize = totalsize + L;
            if mod(numfile,100) == 0
                fprintf('.');
            end
        else
            lfbew = lfbe - repmat(mu1,size(lfbe,1),1);
            lfbew= (e*((e'*lfbew')./repmat(sqrt(diag(v)'),size(lfbew,1),1)'))';
            [a b c] = fileparts(fname);
            
            newname = [a,'/',b,'.mlogfb'];
            write_HTK_file(lfbe,newname,10000,6);
            newname = [a,'/',b,'.mlogfbw'];
            write_HTK_file(lfbew,newname,10000,6);
            fname = fgetl(filelist);
            numfile = numfile + 1;
            if mod(numfile,100) == 0
                fprintf(',');
            end
        end       
    end
    fclose(filelist);
    fprintf('\n');
    if pass == 0
        % collect all frames together, do whitening
        block = zeros(totalsize,W);
        q = 1;
        for i = 1:length(alldata)
            lfbe = alldata{i};
            [L,W] = size(lfbe);
            block(q:q+L-1,:) = lfbe;
            q = q + L;
        end
        mu1 = mean(block);
        block = block - repmat(mu1,size(block,1),1);
        [e v] = eig(cov(block));
    else
        fprintf('Number of files processed (logfbw) = %d\n',numfile);
    end
    pass = 1;
end






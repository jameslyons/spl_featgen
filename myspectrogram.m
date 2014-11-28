%______________________________________________________________________________________________________________________
% 
% @file         myspectrogram.m
% @author       Kamil Wojcicki
% @date         April 2007
% @revision     002
% @brief        Wrapper for Matlab's spectrogram function
%______________________________________________________________________________________________________________________
%
% @inputs       s       - speech signal
%               fs      - sampling frequency
%               nfft    - fft analysis length
%               T       - vector of frame width and frame shift (ms), i.e. [Tw, Ts]
%               w       - analysis window handle
%               Slim    - vector of spectrogram limits (dB), i.e. [Smin Smax]
%               alpha   - fir pre-emphasis filter coefficients
%               cmap    - color map 
%               cbar    - color bar (boolean)
%
% @output       handle  - plot handle
%______________________________________________________________________________________________________________________
%
% @usage        [handle] = myspectrogram(s, fs, nfft, T, w, Slim, alpha, cmap, cbar);
%               [handle] = myspectrogram(s, 8000, 1024, [18,1], @hamming, [-45 -2], false, 'default', false);
%               [handle] = myspectrogram(s, 8000, 1024, [18,1], @hamming, [-45 -2], [1 -0.97], 'default', true);
%______________________________________________________________________________________________________________________

function [handle] = myspectrogram(s, fs, nfft, T, w, Slim, alpha, cmap, cbar)


    %__________________________________________________________________________________________________________________
    % VALIDATE INPUTS 
    switch nargin
    case 1, cbar=false; cmap='default'; alpha=false; Slim=[-45,-2]; w=@hamming; T=[18,1]; nfft=1024; fs=8000;
    case 2, cbar=false; cmap='default'; alpha=false; Slim=[-45,-2]; w=@hamming; T=[18,1]; nfft=1024; 
    case 3, cbar=false; cmap='default'; alpha=false; Slim=[-45,-2]; w=@hamming; T=[18,1]; 
    case 4, cbar=false; cmap='default'; alpha=false; Slim=[-45,-2]; w=@hamming; 
    case 5, cbar=false; cmap='default'; alpha=false; Slim=[-45,-2]; 
    case 6, cbar=false; cmap='default'; alpha=false;
    case 7, cbar=false; cmap='default'; 
    case 8, cbar=false; 
    case 9
    otherwise, error('Invalid number of input arguments.');
    end


    %__________________________________________________________________________________________________________________
    % VARIABLES
    Tw = T(1);
    Ts = T(2);
    Nw = round(fs * Tw * 0.001);
    Ns = round(fs * Ts * 0.001);
    N  = length(s);
    Smin = Slim(1);
    Smax = Slim(2);
    if(isstr(w)), w = str2func(w); end;


    %__________________________________________________________________________________________________________________
    % PRE PROCESS SPEECH
    if(islogical(alpha) && alpha), s = filter([1 -0.97],1,s);
    elseif(~islogical(alpha)) s = filter(alpha,1,s); end;

       
    %__________________________________________________________________________________________________________________
    % GET SPECTROGRAM DATA 
    [S,F,T] = spectrogram(s,w(Nw).',Nw-Ns,nfft,fs);
    %[S,F,T] = specgram(s,nfft,fs,w(Nw).',Nw-Ns); % depreciated 
 
    
    %__________________________________________________________________________________________________________________
    % SET DYNAMIC RANGE 
    S = abs(S);
    S(S==0) = eps;
    S = 20*log10(S);
    S = S-max(max(S));


    %__________________________________________________________________________________________________________________
    % PLOT RESULTS 
    imagesc(T,F,S,[Smin Smax]);
    axis('xy'); axis([0 N/fs  0 fs/2]);
    xlabel('time (s)'); ylabel('frequency (Hz)');
    set(gca,'YDir','normal');

    if(cbar), colorbar; end

    switch(lower(cmap))
    case {'default','speech',''}
        colormap('gray');
        map=colormap;
        colormap(1-map);    
    otherwise, colormap(cmap);
    end
    
    handle = gca;


%______________________________________________________________________________________________________________________
%                                                       EOF

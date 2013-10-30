function q = get_mel_filterbank(numChans,NPOINTS,fs)
%function q = get_mel_filterbank(numChans,NPOINTS,fs)
% NPOINTS would usually be NFFT/2
f = linspace(0,fs/2,NPOINTS);
mel=2595*log10(f./700+1);
mel=mel./max(mel);
q = get_tri_filterbank(mel,numChans);
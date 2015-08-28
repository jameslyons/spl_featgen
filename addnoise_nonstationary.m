function corrupted = addnoise_nonstationary(clean,SNR,noise)
%corrupted = addnoise_nonstationary(clean,SNR,noise); 
% picks a random start point in 'noise' the same length as 'clean', generates
% a corrupted file with snr 'SNR'.

NL = length(noise);
NS = length(clean);

% ensure random seed
rand('twister',sum(100*clock));
start_point = floor((NL-NS)*rand(1));

noise_realisation = noise(start_point:(start_point+NS-1));

% ensure the mean is zero
noise_realisation = noise_realisation - mean(noise_realisation);
clean = clean - mean(clean);

% ensure the standard deviation is unity
noise_realisation = noise_realisation/std(noise_realisation);

% determine the power of the speech signal
pow = sum(clean.^2)/NS ;

% determine the noise power required to attain desired snr
ratio = 10^(SNR/10) ;
sd = sqrt(pow/ratio) ;

% add noise to speech
corrupted = clean + (sd*noise_realisation) ;

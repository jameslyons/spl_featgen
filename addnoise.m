function n_speech = addnoise(c_speech, snr) ;
% NOISY_SPEECH = ADDNOISE(CLEAN_SPEECH, SNR)
%
%   ADDNOISE is used to add white gaussian noise to CLEAN_SPEECH so that 
%   it's signal-to-noise ratio is equal to SNR dB.
%
%   CLEAN_SPEECH - column vector, original speech signal
%   NOISY_SPEECH - column vector, noisy speech signal with desired snr
%   SNR          - signal-to-noise ratio in dB
%

if size(c_speech,1) ~= length(c_speech)
    c_speech = c_speech';
end

n = length(c_speech) ;

% generate zero-mean unity-variance white gaussian noise
x = randn(n,1) ;

% ensure the mean is zero
av = sum(x)/n ;
x = x - av ;

% ensure the standard deviation is unity
var = sum(x.^2)/n ;
sd = sqrt(var) ;
x = x/sd ;

% determine the power of the speech signal
var = sum(c_speech.^2)/n ;

% determine the noise power required to attain desired snr
ratio = 10^(snr/10) ;
sd = sqrt(var/ratio) ;

% add noise to speech
n_speech = c_speech + (sd*x) ;



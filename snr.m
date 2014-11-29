
% =====================================================================================================================
% 
% File:         snr.m
% Author:       Kamil Wojcicki
% Date:         Feb 2006
% Revision:     001
% Purpouse:     Computes signal to noise ratio
%
% ---------------------------------------------------------------------------------------------------------------------
%
% Inputs:       clean       - clean signal
%               corrupt     - corrputed signal
%               type        - snr type (default: 'db'; options: 'lin', 'db')
%               
% Output:       SNR         - snr value
%
% Usage:        [SNR] = snr(clean, corrupt)
%               [SNR] = snr(clean, corrupt, type)
%                
% =====================================================================================================================

function [SNR]=snr(clean, corrupt, type)


    %%% VALIDATE INPUTS %%%
    switch nargin
    case 2
        type='db';
    case 3
    otherwise
        error('Invalid number of input arguments.');
    end

   
    %%% VARIABLES %%%
%    N=min([size(clean,2),size(corrupt,2)]);             % number of samples to use
%    clean=clean(:,1:N);
%    corrupt=corrupt(:,1:N);
    clean=clean(:);
    corrupt=corrupt(:);
    

    %%% COMPUTE SNR %%%
    switch lower(type)
    case {'db','log'}
        SNR=sum(clean.^2)./(eps+sum((clean-corrupt).^2));
        SNR=10*log10(SNR+eps);
    case {'lin','linear'}
        SNR=sum(clean.^2)./(eps+sum((clean-corrupt).^2));
    otherwise
        error('Unsupported SNR type.');
    end


% =====================================================================================================================
%                                                       EOF
% =====================================================================================================================


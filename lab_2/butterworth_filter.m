function Hd = butterworth_filter
%BUTTERWORTH_FILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.11 and DSP System Toolbox 9.13.
% Generated on: 08-Feb-2022 17:37:19

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 2000;  % Sampling Frequency

N   = 4;    % Order
Fc1 = 150;  % First Cutoff Frequency
Fc2 = 900;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

% [EOF]
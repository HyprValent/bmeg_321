%% Part B

%% 1. Input arguments of audiorecorder

% The input arguments of audiorecorder are as follows:

% Fs - a double that denotes the sampling frequency of the recording in Hz. The
% sampling rate can vary from system to system, but it has to be between
% 1000 Hz and 384000 Hz as restricted by MATLAB

% nBits - an integer that denotes bits per sample. The default is 8 bits
% but can be configured only else to 16 and 24 if there are floating point
% values in signal samples (since floating points require extra bits).

% NumChannels - an integer that denotes the number of channels the signal 
% is recorded in. The value can only be either 1 for mono output (set by default), or 2
% for stereo output

% ID - an integer denoting the ID of a device that will be used for audio
% input. It is set to -1 by default, although it can be configured to a
% specified ID produced by the audiodevinfo function

%% 2. Recording the audio
recObj = audiorecorder(44100,8,1);
recordblocking(recObj, 3);

%% Saving and playing the audio
sampleSpeech = getaudiodata(recObj);
timeAxis = (0:length(sampleSpeech)-1)*3 / length(sampleSpeech);
figure(1)
plot(timeAxis, sampleSpeech);
title("Plot of Audio Recording Amplitude vs. Time at 44100 Hz Sampling Rate");
xlabel("Time (s)");
ylabel("Amplitude");
% play(recObj);

% Without changing the timeAxis manually, the current grpah is plotted
% with a domain [0,14*10^4] based on the number of samples. The signal is
% discrete in time and amplitude

%% 3. changing the sampling frequency to 1000Hz
recObj_downsampled = audiorecorder(1000,8,1);
recordblocking(recObj_downsampled, 3);

%% Saving and playing the audio
sampleSpeech_downsampled = getaudiodata(recObj_downsampled);
timeAxis_downsampled = (0:length(sampleSpeech_downsampled)-1)*3 / length(sampleSpeech_downsampled);
figure(2)
plot(timeAxis_downsampled, sampleSpeech_downsampled);
title("Plot of Audio Recording Amplitude vs. Time at 1000 Hz Sampling Rate");
xlabel("Time (s)");
ylabel("Amplitude");
% play(recObj_downsampled);

% The downsampled frequency sounds more muffled and quiet than the original
% one. When observing the graph it also seems as though there is less
% detail/variation in the downsampled version due to less samples being
% recorded per second.

% This means that there is a loss of information when we choose to
% downsample, meaning that a lot of the voice going through the recording
% is cut out, causing the muffled/quieter output.

%% Part C
load("output\partB_env.mat") % Use prerecorded files

%% 1. FFT function

% The Fast Fourier Transform (FFT) function is used to find the frequency
% component of a noisy signal from its time domain. The input and output of
% the FFT function are discrete, much like the Discrete Fourier Transform
% (DFT) counterpart. This means that the frequency domain is also going to
% be sampled discretely, much like the time domain when it was recorded.
% Looking into the function further, it becomes evident that FFT is moreso
% a more efficient way of using DFT. Whereas in class, DFT is utilized by
% applying the defintion to each individual sample linearily across the
% length of the signal, FFT does so by applying said definition in chunks,
% usually in an attempt to be more efficient.

%% 2. Compute the FFt of audio recording
speechFFT = fft(sampleSpeech);
figure(3)
plot(speechFFT);
title("Plot of Fourier Transform of Audio Recording vs. Frequency")
xlabel("Magnitude of real component")
ylabel("Magnitude of imaginary component")

%% 3. Plot real and imaginary component of FFT
realFFT = real(speechFFT);
imaginaryFFT = imag(speechFFT);
freqAxis = (0:length(sampleSpeech)-1) * 44100 / length(sampleSpeech);
figure(4)
plot(freqAxis, realFFT);
title("Plot of Real Component of Fourier Transform of Audio Recording vs. Frequency")
xlabel("Frequency (Hz)")
ylabel("Amplitude")

figure(5)
plot(freqAxis, imaginaryFFT);
title("Plot of Imaginary Component of Fourier Transform of Audio Recording vs. Frequency")
xlabel("Frequency (Hz)")
ylabel("Amplitude")

%% Part D

%%

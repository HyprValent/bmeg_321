%% Prerecorded audio can be imported
load("output\partE_recording.mat")

%% Recording the audio
recObj = audiorecorder(44100,8,1);
recordblocking(recObj, 3);

%% Import impulse response audio files
[ir_1, Fs_1] = audioread("sounds\BatteryBenson.wav");
[ir_2, Fs_2] = audioread("sounds\PurgatoryChasm.wav");
[ir_3, Fs_3] = audioread("sounds\SquareVictoriaDome.wav");

%%
play(recObj);

%% Convolve impulse responses with recorded audio
sampleAudio = getaudiodata(recObj);

conv_1 = conv(ir_1(1:end, 1), sampleAudio);
conv_2 = conv(ir_2(1:end, 1), sampleAudio);
conv_3 = conv(ir_3(1:end, 1), sampleAudio);

% Play convoluted sounds
% sound(conv_1, 44100);
% sound(conv_2, 44100);
% sound(conv_3, 44100);

figure(1)
timeAxis = (0:length(conv_1)-1)*3 / length(conv_1);
plot(timeAxis, conv_1);
title("Plot of Convolution of Impulse Response 1 against Time")
xlabel("Time (s)")
ylabel("Amplitude")

figure(2)
timeAxis = (0:length(conv_2)-1)*3 / length(conv_2);
plot(timeAxis, conv_2);
title("Plot of Convolution of Impulse Response 2 against Time")
xlabel("Time (s)")
ylabel("Amplitude")

figure(3)
timeAxis = (0:length(conv_3)-1)*3 / length(conv_3);
plot(timeAxis, conv_3);
title("Plot of Convolution of Impulse Response 3 against Time")
xlabel("Time (s)")
ylabel("Amplitude")

%% Calculate FFT
X = fft(sampleAudio);

H_1 = fft(ir_1(1:end, 1));
H_2 = fft(ir_2(1:end, 1));
H_3 = fft(ir_3(1:end, 1));

% The size of H_1, H_2, and H_3 must be same as X in order to do matrix
% multiplication

new_H1 = zeros(size(X));
new_H1(1:size(H_1,1),1:size(H_1,2)) = H_1;
new_H2 = zeros(size(X));
new_H2(1:size(H_2,1),1:size(H_2,2)) = H_2;
new_H3 = zeros(size(X));
new_H3(1:size(H_3,1),1:size(H_3,2)) = H_3;

% FFT based on matrix multiplication
Y_1 = new_H1 .* X;
Y_2 = new_H2 .* X;
Y_3 = new_H3 .* X;

%% Plot each Y_i and compare to FFT of y_i
freqAxis = (0:length(Y_1)-1) * 44100 / length(Y_1);

figure(1)
plot(freqAxis, real(Y_1));
title("Plot of Y_1 against Frequency")
xlabel("Frequency (Hz)")
ylabel("Amplitude")

figure(2)
plot(freqAxis, real(Y_2));
title("Plot of Y_2 against Frequency")
xlabel("Frequency (Hz)")
ylabel("Amplitude")

figure(3)
plot(freqAxis, real(Y_3));
title("Plot of Y_3 against Frequency")
xlabel("Frequency (Hz)")
ylabel("Amplitude")

figure(4)
freqAxis = (0:length(real(fft(conv_1)))-1) * 44100 / length(real(fft(conv_1)));
plot(freqAxis, real(fft(conv_1)));
title("Plot of y_1 against Frequency")
xlabel("Frequency (Hz)")
ylabel("Amplitude")

figure(5)
freqAxis = (0:length(real(fft(conv_2)))-2) * 44100 / length(real(fft(conv_2)));
plot(freqAxis, real(fft(conv_2)));
title("Plot of y_2 against Frequency")
xlabel("Frequency (Hz)")
ylabel("Amplitude")

figure(6)
freqAxis = (0:length(real(fft(conv_3)))-1) * 44100 / length(real(fft(conv_3)));
plot(freqAxis, real(fft(conv_3)));
title("Plot of y_3 against Frequency")
xlabel("Frequency (Hz)")
ylabel("Amplitude")

%% Plot IFFT of Y_i and compare to y_i

figure(1)
subplot(2,2,[1,2])
timeAxis1 = (0:length(real(ifft(Y_1)))-1)*3 / length(real(ifft(Y_1)));
timeAxis2 = (0:length(conv_1)-1)*3 / length(conv_1);
plot(timeAxis1, real(ifft(Y_1)), timeAxis2, conv_1);
title("Subplot of IFFT of Y_1 and signal y_1 against Time")
xlabel("Time (s)")
ylabel("Amplitude")

figure(2)
subplot(2,2,[1,2])
timeAxis1 = (0:length(real(ifft(Y_2)))-1)*3 / length(real(ifft(Y_2)));
timeAxis2 = (0:length(conv_2)-1)*3 / length(conv_2);
plot(timeAxis1, real(ifft(Y_2)), timeAxis2, conv_2);
title("Subplot of IFFT of Y_2 and signal y_2 against Time")
xlabel("Time (s)")
ylabel("Amplitude")

figure(3)
subplot(2,2,[1,2])
timeAxis1 = (0:length(real(ifft(Y_3)))-1)*3 / length(real(ifft(Y_3)));
timeAxis2 = (0:length(conv_3)-1)*3 / length(conv_3);
plot(timeAxis1, real(ifft(Y_3)), timeAxis2, conv_3);
title("Subplot of IFFT of Y_3 and signal y_3 against Time")
xlabel("Time (s)")
ylabel("Amplitude")
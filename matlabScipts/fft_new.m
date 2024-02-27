function [fft_result_dB, fft_result_mag, freq]= fft_new(input, frame_length, fs)

X = fft(input);
X = fftshift(X);
fft_result_mag = abs(X);
fft_result_dB = 20*log10(abs(X));
freq = (-0.5:1/frame_length:0.5-1/frame_length) * fs;
freq = freq';
end
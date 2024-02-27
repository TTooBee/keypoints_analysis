close all; clear; clc
% CSV 파일 경로를 지정합니다.
filePath_rightFoot_toe = 'sinner_0203\result_11.csv';
filePath_rightFoot_heel = 'sinner_0203\result_8.csv';

filePath_leftFoot_toe = 'sinner_0203\result_10.csv';
filePath_leftFoot_heel = 'sinner_0203\result_7.csv';

% CSV 파일을 불러와서 배열에 저장합니다.
M_rightFoot_toe = readmatrix(filePath_rightFoot_toe);
M_rightFoot_heel = readmatrix(filePath_rightFoot_heel);
M_leftFoot_toe = readmatrix(filePath_leftFoot_toe);
M_leftFoot_heel = readmatrix(filePath_leftFoot_heel);

t = 1:height(M_rightFoot_toe);


x_rightFoot_toe = M_rightFoot_toe(:, 1);
y_rightFoot_toe = M_rightFoot_toe(:, 2);
z_rightFoot_toe = M_rightFoot_toe(:, 3);

% x_rightFoot_toe = smoothing(x_rightFoot_toe);
% y_rightFoot_toe = smoothing(y_rightFoot_toe);
% z_rightFoot_toe = smoothing(z_rightFoot_toe);

[X_dB, X_mag, freq] = fft_new(x_rightFoot_toe, length(x_rightFoot_toe), 30);


figure(1)
plot(x_rightFoot_toe)
axis([1 length(t) -1 1])

figure(2)
plot(y_rightFoot_toe)
axis([1 length(t) -1 1])

figure(3)
plot(z_rightFoot_toe)
axis([1 length(t) -1 1])

figure(4)
plot(t, x_rightFoot_toe, 'r', t, y_rightFoot_toe, 'b', t, z_rightFoot_toe, 'black')
legend('x', 'y', 'z')
axis([1 length(t) -1 1])

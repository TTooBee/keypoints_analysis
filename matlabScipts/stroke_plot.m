close all; clear; clc
% CSV 파일 경로를 지정합니다.
filePath = 'sinner_0203\result_20.csv';

% CSV 파일을 불러와서 배열에 저장합니다.
M = readmatrix(filePath);
t = 1:height(M);

% 배열 내용을 출력합니다.
disp(M);

disp(height(M));

x = M(:, 1);
y = M(:, 3);
z = (-1)*M(:, 2);

x = smoothing(x);
y = smoothing(y);
z = smoothing(z);

[azimuth,elevation,r] = cart2sph(x,y,z);

azimuth = azimuthTrans(azimuth);

% for i=1:length(azimuth)
%     if (azimuth(i)>-1*pi) && (azimuth(i)<-1*pi/2)
%         azimuth(i) = azimuth(i) + 2*pi;
%     end
%     azimuth(i) = azimuth(i) - pi/2;
% end

figure(1)
subplot(3, 1, 1); plot(azimuth);title('azimuth')
subplot(3, 1 ,2); plot(elevation);title('elevation')
subplot(3, 1 ,3); plot(r);title('r')

% figure(2)
% plot(res_theta)

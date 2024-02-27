close all; clear; clc
% CSV 파일 경로를 지정합니다.

% tenfitmen
% filePath_rightHand = 'keypoints\tenfitmen_backhand_0204\result_21.csv';
% filePath_leftHand = 'kepoints\tenfitmen_backhand_0204\result_20.csv';

% federer
% filePath_rightHand = 'keypoints\federer_0210\result_21.csv';
% filePath_leftHand = 'keypoints\federer_0210\result_20.csv';

% sinner
filePath_rightHand = 'keypoints\sinner_0203\result_21.csv';
filePath_leftHand = 'keypoints\sinner_0203\result_20.csv';

% wta game
% filePath_rightHand = 'keypoints\wta_game_0210\result_21.csv';
% filePath_leftHand = 'keypoints\wta_game_0210\result_20.csv';

% alcaraz
% filePath_rightHand = 'keypoints\alcaraz_0203\result_21.csv';
% filePath_leftHand = 'keypoints\alcaraz_0203\result_20.csv';

% ruusuvuori
% filePath_rightHand = 'keypoints\ruusuvuori_serve_0209\result_21.csv';
% filePath_leftHand = 'keypoints\ruusuvuori_serve_0209\result_20.csv';

% monfis
% filePath_rightHand = 'keypoints\monfis_0206\result_21.csv';
% filePath_leftHand = 'keypoints\monfis_0206\result_20.csv';

% thiem
% filePath_rightHand = 'keypoints\thiem_volleys_0212\result_21.csv';
% filePath_leftHand = 'keypoints\thiem_volleys_0212\result_20.csv';

% djokovic
% filePath_rightHand = 'keypoints\djokovic_nia_0214\result_21.csv';
% filePath_leftHand = 'keypoints\djokovic_nia_0214\result_20.csv';

% yoon
% filePath_rightHand = 'keypoints\yoon_game_0215\result_21.csv';
% filePath_leftHand = 'keypoints\yoon_game_0215\result_20.csv';





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%원점 좌표 보기(임시)
filePath_origin_coord = 'keypoints\sinner_0203\result_origin_coord.csv';
M_origin = readmatrix(filePath_origin_coord);
res_x_coord = getResidual(M_origin(:, 1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%원점 좌표 보기(임시)



% CSV 파일을 불러와서 배열에 저장합니다.
M_rightHand = readmatrix(filePath_rightHand);
M_leftHand = readmatrix(filePath_leftHand);

% 프레임별로 각 점간의 거리
speed_rightHand = getSpeed(M_rightHand);

% 플롯을 위한 벡터
t = 1:height(M_rightHand);

% 카메라 좌표계에서 월드 좌표계(와 비슷한?)로 변환
x_rightHand = M_rightHand(:, 1);
y_rightHand = M_rightHand(:, 3);
z_rightHand = -M_rightHand(:, 2);

x_leftHand = M_leftHand(:, 1);
y_leftHand = M_leftHand(:, 3);
z_leftHand = -M_leftHand(:, 2);

% moving average 적용
x_rightHand = smoothing(x_rightHand);
y_rightHand = smoothing(y_rightHand);
z_rightHand = smoothing(z_rightHand);

x_leftHand = smoothing(x_leftHand);
y_leftHand = smoothing(y_leftHand);
z_leftHand = smoothing(z_leftHand);







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%임시 벡터 미분
diff_x_rightHand = diff(x_rightHand);
diff_y_rightHand = diff(y_rightHand);
diff_z_rightHand = diff(z_rightHand);

mag_diff = zeros(height(diff_x_rightHand), 1);
for i=1:height(diff_x_rightHand)
    mag_diff(i) = (diff_x_rightHand(i)^2+diff_y_rightHand(i)^2+diff_z_rightHand(i)^2)^(1/2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%임시 벡터 미분

% 직교좌표계에서 구면좌표계로 변환
[azimuth_rightHand,elevation_rightHand,r_rightHand] = cart2sph(x_rightHand,y_rightHand,z_rightHand);
[azimuth_leftHand,elevation_leftHand,r_leftHand] = cart2sph(x_leftHand,y_leftHand,z_leftHand);

% azimuth를 y축이 0도로 바꿈(이래야 미분 불가능한 점 적게 나옴)
azimuth_rightHand = azimuthTrans(azimuth_rightHand);
azimuth_leftHand = azimuthTrans(azimuth_leftHand);


% azimuth의 미분 불가능한 점 없애기. 이 부분은 항상 azimuthTrans 이후에 나와야 한다
azimuth_rightHand = azimuthExpansion(azimuth_rightHand);
azimuth_leftHand = azimuthExpansion(azimuth_leftHand);

% azimuth에는 스무딩 절대 적용하지 말 것!!!!
% azimuth_rightHand = smoothing(azimuth_rightHand);
% azimuth_leftHand = smoothing(azimuth_leftHand);


% azimuth의 도함수
diff_azimuth_rightHand = diff(azimuth_rightHand);

% azimuth의 r*theta값. 아마 이 값은 안 쓸 듯 하다
r_xy_rightHand = r_rightHand.*cos(elevation_rightHand);
r_xy_leftHand = r_leftHand.*cos(elevation_leftHand);
r_xy_azimuth_rightHand = r_xy_rightHand.*azimuth_rightHand;
r_xy_azimuth_leftHand = r_xy_leftHand.*azimuth_leftHand;


% elevation의 r*theta값.
r_elevation_rightHand = r_rightHand.*elevation_rightHand;


figure(1)
subplot(2, 1 ,1); plot(azimuth_rightHand); title('azimuth rightHand')
subplot(2, 1 ,2); plot(azimuth_leftHand); title('azimuth leftHand')

figure(2)
subplot(2, 1 ,1); plot(elevation_rightHand); title('elevation rightHand')
subplot(2, 1 ,2); plot(elevation_leftHand); title('elevation leftHand')

figure(3)
subplot(2, 1 ,1); plot(r_rightHand); title('r rightHand')
subplot(2, 1 ,2); plot(r_leftHand); title('r leftHand')

figure(4)
plot(t, azimuth_rightHand/pi, t, r_xy_azimuth_leftHand/pi);
legend('right', 'left')

figure(5)
plot(smoothing(diff_azimuth_rightHand))

figure(6)
subplot(2 ,1 ,1); plot(azimuth_rightHand/pi); title('azimuth')
subplot(2 ,1 ,2); plot(r_xy_azimuth_rightHand); title('r azimuth')

figure(7)
subplot(3, 1 ,1); plot(azimuth_rightHand/pi);title('azimuth')
subplot(3, 1 ,2); plot(elevation_rightHand);title('elevation')
subplot(3, 1 ,3); plot(r_elevation_rightHand);title('r elevation')






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%임시 실험용. 위에서 본 오른손 모습. 나중에 지우기
x = x_rightHand(95:130);
y = y_rightHand(95:130);
z = z_rightHand(95:130);


figure(8)
hold on;
plot(y(1), z(1), 'r*')
plot(y(2:end), z(2:end), 'bo-');%axis([-0.3 0.4 -0.6 0.1]);
% plot(y(end), z(end), 'bo')
plot(0, 0, 'ro');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%임시 실험용. 나중에 지우기



figure(9)
subplot(2 ,1 ,1); plot(azimuth_rightHand);title('azimuth')
subplot(2 ,1 ,2); plot(mag_diff);title('mag diff')








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 여기서부터는 함수 사용하면서 알고리즘 시작




% 포백 분류 알고리즘
shots_idx = strokeForebackClassif(azimuth_rightHand);
% shots_idx = strokeForebackClassif(r_xy_azimuth_rightHand);

disp(shots_idx)


% playing/non-playing 분류 알고리즘
[playing_idx, non_playing_idx] = onPlayClassif(azimuth_rightHand, elevation_leftHand, r_rightHand);


disp(playing_idx)
disp(non_playing_idx)

ready_pos_azimuth = findReadyPosAzimuth(azimuth_rightHand);

disp(ready_pos_azimuth)








figure;
% hold on
% plot(M_origin(1,1), M_origin(1,2), 'r*')
% plot(M_origin(2:200, 1), M_origin(2:200, 2), 'bo-')
% axis([0 1000 0 600])

plot(M_origin(:,1)); % xlim([1 200])

figure;
stem(res_x_coord)

in_angle = inAngleClassif(M_origin(:,1));

figure;
subplot(3 ,1 ,1);plot(M_origin(:,1))
subplot(3, 1, 2);plot(res_x_coord)
subplot(3 ,1 ,3);stem(in_angle)

figure;
plot(x_rightHand)
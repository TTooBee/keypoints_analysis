close all; clear; clc
% 폴더의 csv 파일을 모두 불러 matrix로 저장.
matrices_temp = processCsvFilesToMatrices('keypoints\sinner_0203');
v = VideoReader('videos\sinner_0203.mp4');

disp(v.height)
disp(v.width)

% matrices 순서대로 정렬해줘야 함
matrices = cell(1, length(matrices_temp));
matrices{1} = matrices_temp{1};
matrices{2} = matrices_temp{2};
matrices{11} = matrices_temp{3};
matrices{12} = matrices_temp{4};
matrices{13} = matrices_temp{5};
matrices{14} = matrices_temp{6};
matrices{15} = matrices_temp{7};
matrices{16} = matrices_temp{8};
matrices{17} = matrices_temp{9};
matrices{18} = matrices_temp{10};
matrices{19} = matrices_temp{11};
matrices{20} = matrices_temp{12};
matrices{3} = matrices_temp{13};
matrices{21} = matrices_temp{14};
matrices{22} = matrices_temp{15};
matrices{23} = matrices_temp{16};
matrices{24} = matrices_temp{17};
matrices{4} = matrices_temp{18};
matrices{5} = matrices_temp{19};
matrices{6} = matrices_temp{20};
matrices{7} = matrices_temp{21};
matrices{8} = matrices_temp{22};
matrices{9} = matrices_temp{23};
matrices{10} = matrices_temp{24};

numPoints = 24; % 포인트의 총 개수

% 좌표 데이터를 저장할 구조체 초기화
coordinates = struct();

% 셀 배열 'matrices'에 저장된 각 포인트 데이터에 대해 반복
for i = 1:numPoints
    % 현재 포인트 데이터
    currentPoint = matrices{i};
    
    % 구조체 필드 이름 동적 생성 및 데이터 할당
    coordinates.(['x_point_', num2str(i-1)]) = currentPoint(:, 1);
    coordinates.(['y_point_', num2str(i-1)]) = currentPoint(:, 3);
    coordinates.(['z_point_', num2str(i-1)]) = -currentPoint(:, 2);

    coordinates.(['x_point_', num2str(i-1)]) = smoothing(coordinates.(['x_point_', num2str(i-1)]));
    coordinates.(['y_point_', num2str(i-1)]) = smoothing(coordinates.(['y_point_', num2str(i-1)]));
    coordinates.(['z_point_', num2str(i-1)]) = smoothing(coordinates.(['z_point_', num2str(i-1)]));

    [coordinates.(['azimuth_point_', num2str(i-1)]),coordinates.(['elevation_point_', num2str(i-1)]), ...
        coordinates.(['r_point_', num2str(i-1)])] = cart2sph( coordinates.(['x_point_', num2str(i-1)]), ...
         coordinates.(['y_point_', num2str(i-1)]),  coordinates.(['z_point_', num2str(i-1)]));

    coordinates.(['azimuth_point_', num2str(i-1)]) = azimuthTrans(coordinates.(['azimuth_point_', num2str(i-1)]));
    coordinates.(['elevation_point_', num2str(i-1)]) = azimuthTrans(coordinates.(['elevation_point_', num2str(i-1)]));
    coordinates.(['r_point_', num2str(i-1)]) = azimuthTrans(coordinates.(['r_point_', num2str(i-1)]));

    coordinates.(['azimuth_point_', num2str(i-1)]) = azimuthExpansion(coordinates.(['azimuth_point_', num2str(i-1)]));
    coordinates.(['elevation_point_', num2str(i-1)]) = azimuthExpansion(coordinates.(['elevation_point_', num2str(i-1)]));
    coordinates.(['r_point_', num2str(i-1)]) = azimuthExpansion(coordinates.(['r_point_', num2str(i-1)]));

end

% 원점 좌표 불러오기
result_origin_coord = readmatrix('keypoints\sinner_0203\result_origin_coord.csv');
origin_x = result_origin_coord(:, 1);
origin_y = result_origin_coord(:, 2);

% 이제 coordinate.x_point_키포인트번호,  로 키포인트 접근 가능. 

% 플롯을 위한 벡터
t = 1:length(coordinates.azimuth_point_0);

out_angle_vector = inAngleClassif(origin_x, v.width);


diff_origin_x = diff(origin_x);
diff_origin_y = diff(origin_y);

figure;
stem(diff_origin_x)


figure;
plot(coordinates.azimuth_point_21); title('azimuth right hand')

figure;
subplot(2 ,1 ,1);stem(origin_x); title('origin x')
subplot(2 ,1 ,2);stem(origin_y); title('origin y')

figure;
stem(out_angle_vector)
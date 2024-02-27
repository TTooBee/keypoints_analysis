function ready_pos_azimuth = findReadyPosAzimuth(azimuth)
azimuth = azimuth/pi;
loop_dis = 0.01; % -pi부터 pi까지 탐색하는 구간 간격
loop_width = 0.1; % 탐색 구간의 너비
counter = 0;
ready_pos_azimuth = 0;
max = 0;
loop_length = 2/loop_dis + 1;

% azimuth 값의 빈도를 계산
for i=1:loop_length
    k = i*loop_dis - 1 - loop_dis;
    for j=1:length(azimuth)
        if azimuth(j) > k-loop_width && azimuth(j) < k+loop_width
            counter = counter + 1;
        end
    end
    if max < counter
        max = counter;
        ready_pos_azimuth = k;
    end
    counter = 0;
end

% azimuth의 미분값을 계산
%for
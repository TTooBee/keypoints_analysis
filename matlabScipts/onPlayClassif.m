function [playing_idx, non_playing_idx] = onPlayClassif(azimuth, elevation, r)

frame_size = 90;

% playing/non-playing 분류에는 각도값 자체가 아닌 r*theta값이 사용된다.
r_xy = r.*cos(elevation);
r_xy_azimuth = r_xy.*azimuth;
r_elevation = r.*cos(elevation);

r_xy_azimuth = azimuth;

% 미분을 사용하여 손 좌표의 변화율이 큰 구간은 playing, 작은 구간은 non-playing
diff_r_xy_azimuth = diff(r_xy_azimuth);
diff_r_elevation = diff(r_elevation);

% 90개 프레임만 가져옴
section_diff_r_xy_azimuth = zeros(height(diff_r_xy_azimuth)-(frame_size-1), 1);
% 구간(90개 프레임)별 에너지
ener_diff_r_xy_azimuth = zeros(height(diff_r_xy_azimuth)-(frame_size-1), 1);
% 90 짜리 크기의 윈도우가 슬라이딩하며 에너지를 구하여 배열에 저장
for i=1:height(diff_r_xy_azimuth)-(frame_size-1)
    section_diff_r_xy_azimuth = diff_r_xy_azimuth(i:i+frame_size-1);
    ener_diff_r_xy_azimuth(i) = getEnergy(section_diff_r_xy_azimuth);
end


% min값 안쓰는게 나을듯
% min_ener = min(ener_diff_r_xy_azimuth);

non_playing_idx = zeros(1, 2);
playing_idx = zeros(1, 2);
non_playing_count = 0;
playing_count = 0;
temp = zeros(1, 2);

for i=2:length(ener_diff_r_xy_azimuth)
    if ener_diff_r_xy_azimuth(i-1) > 0.02 && ener_diff_r_xy_azimuth(i) > 0.02
        playing_count = playing_count + 1;
        if i == length(ener_diff_r_xy_azimuth)
            temp(1) = i - playing_count + (frame_size - 1);
            temp(2) = i + frame_size - 1;
            playing_idx = [playing_idx; temp];
        end
    elseif ener_diff_r_xy_azimuth(i-1) > 0.02 && ener_diff_r_xy_azimuth(i) < 0.02 % 크다가 작아지면
        temp(1) = i - (playing_count + 1) + frame_size;
        temp(2) = i - 1;
        playing_idx = [playing_idx; temp];
        playing_count = 0;
    elseif ener_diff_r_xy_azimuth(i-1) < 0.02 && ener_diff_r_xy_azimuth(i) < 0.02
        non_playing_count = non_playing_count + 1;
        if i == length(ener_diff_r_xy_azimuth)
            temp(1) = i - non_playing_count;
            temp(2) = i + frame_size - 1;
            non_playing_idx = [non_playing_idx; temp];
        end
    elseif ener_diff_r_xy_azimuth(i-1) < 0.02 && ener_diff_r_xy_azimuth(i) > 0.02 % 작다가 크면
        temp(1) = i - (non_playing_count + 1);
        temp(2) = i - 1 + (frame_size - 1);
        non_playing_idx = [non_playing_idx; temp];
        non_playing_count = 0;
    end
end
if height(playing_idx) > 1
    playing_idx = playing_idx(2:end, :);
end
if height(non_playing_idx) > 1
    non_playing_idx = non_playing_idx(2:end, :);
end
if playing_idx(1, 1) == frame_size + 1
    playing_idx(1, 1) = 1;
end
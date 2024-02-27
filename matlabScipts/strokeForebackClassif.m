function shots_idx = strokeForebackClassif(azimuth_rightHand)
% ball_dec은 공 위치를 통해 결정한 값. 큰 국면을 나타냄.
% ball_dec은 해당 프레임이 포인지 백인지 알려줌.

[diff_pos_idx_rightHand, diff_neg_idx_rightHand] = getDiffSection(azimuth_rightHand);
% [diff_pos_idx_leftHand, diff_neg_idx_leftHand] = getDiffSection(azimuth_leftHand);


above_thresh_pos_idx_rightHand = zeros(1, 2);
below_thresh_neg_idx_rightHand = zeros(1, 2);
% above_thresh_pos_idx_leftHand = zeros(1, 2);
% below_thresh_neg_idx_leftHand = zeros(1, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%여기는 공 감지 결과 사용하는 부분
% for i=1:height(diff_pos_idx_rightHand)
% 
% % 포핸드 구간 전부
% for i=1:height(ball_dec_fore)
%     section = azimuth_rightHand(ball_sec_fore(i, 1): ball_sec_fore(i, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%여기는 공 감지 결과 사용하는 부분






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%여기는 공 감지 결과 사용 X

% azimuth 회전각이 0.5pi 이상이면 샷일 가능성 커짐

for i=1:height(diff_pos_idx_rightHand)
    % section = azimuth_rightHand(diff_pos_idx_rightHand(i, 1): diff_pos_idx_rightHand(i, 2));
    if azimuth_rightHand(diff_pos_idx_rightHand(i, 2)) - azimuth_rightHand(diff_pos_idx_rightHand(i, 1)) > 0.5*pi
        above_thresh_pos_idx_rightHand = [above_thresh_pos_idx_rightHand; diff_pos_idx_rightHand(i, :)];
    end
end
for i=1:height(diff_neg_idx_rightHand)
    if azimuth_rightHand(diff_neg_idx_rightHand(i, 1)) - azimuth_rightHand(diff_neg_idx_rightHand(i, 2)) > 0.5*pi
        below_thresh_neg_idx_rightHand = [below_thresh_neg_idx_rightHand; diff_neg_idx_rightHand(i, :)];
    end
end
if height(above_thresh_pos_idx_rightHand) > 1
    above_thresh_pos_idx_rightHand = above_thresh_pos_idx_rightHand(2:end, :);
end
if height(below_thresh_neg_idx_rightHand) > 1
    below_thresh_neg_idx_rightHand = below_thresh_neg_idx_rightHand(2:end, :);
end



%기울기 양수면 0(포핸드)
above_thresh_pos_idx_rightHand = [above_thresh_pos_idx_rightHand zeros(height(above_thresh_pos_idx_rightHand), 1)];
%기울기 음수면 1(백핸드)
below_thresh_neg_idx_rightHand = [below_thresh_neg_idx_rightHand ones(height(below_thresh_neg_idx_rightHand), 1)];

% 두 배열 합친 후 인덱스 순서대로 정렬
pos_count = 1;
neg_count = 1;
above_thresh_idx_rightHand = zeros(height(above_thresh_pos_idx_rightHand)+height(below_thresh_neg_idx_rightHand), 3);

% 배열을 합치기 전 배열의 길이를 맞춰준다. 패딩은 '10*height(azimuth_rightHand)'(큰 값)으로 진행
if height(above_thresh_pos_idx_rightHand) > height(below_thresh_neg_idx_rightHand)
    above_thresh_pos_idx_rightHand = [above_thresh_pos_idx_rightHand; 10*height(azimuth_rightHand)*ones(1, width(above_thresh_pos_idx_rightHand))];
    below_thresh_neg_idx_rightHand = [below_thresh_neg_idx_rightHand; 10*height(azimuth_rightHand)*ones(height(above_thresh_pos_idx_rightHand)-height(below_thresh_neg_idx_rightHand)+1, width(below_thresh_neg_idx_rightHand))];
elseif height(above_thresh_pos_idx_rightHand) < height(below_thresh_neg_idx_rightHand)
    above_thresh_pos_idx_rightHand = [above_thresh_pos_idx_rightHand; 10*height(azimuth_rightHand)*ones(height(below_thresh_neg_idx_rightHand)-height(above_thresh_pos_idx_rightHand)+1, width(above_thresh_pos_idx_rightHand))];
    below_thresh_neg_idx_rightHand = [below_thresh_neg_idx_rightHand; 10*height(azimuth_rightHand)*ones(1, width(below_thresh_neg_idx_rightHand))];
else
    above_thresh_pos_idx_rightHand = [above_thresh_pos_idx_rightHand; 10*height(azimuth_rightHand)*ones(1, width(above_thresh_pos_idx_rightHand))];
    below_thresh_neg_idx_rightHand = [below_thresh_neg_idx_rightHand; 10*height(azimuth_rightHand)*ones(1, width(below_thresh_neg_idx_rightHand))];
end


% 배열 합치기. 순서는 오름차순
for i=1:height(above_thresh_idx_rightHand)
    if above_thresh_pos_idx_rightHand(pos_count, 1) < below_thresh_neg_idx_rightHand(neg_count, 1)
        above_thresh_idx_rightHand(i, :) = above_thresh_pos_idx_rightHand(pos_count, :);
        pos_count = pos_count + 1;
    elseif above_thresh_pos_idx_rightHand(pos_count, 1) > below_thresh_neg_idx_rightHand(neg_count, 1)
        above_thresh_idx_rightHand(i, :) = below_thresh_neg_idx_rightHand(neg_count, :);
        neg_count = neg_count + 1;
    end
end


% 인접한 구간에서 기울기가 제일 가파르다면 샷으로 판단. 그게 아니면 pass.
shots_idx = zeros(1, 3);
slope = zeros(height(above_thresh_idx_rightHand), 1);
slope_abs = zeros(height(above_thresh_idx_rightHand), 1);
% 기울기 구하기
for i=1:height(above_thresh_idx_rightHand)
    slope(i) = (azimuth_rightHand(above_thresh_idx_rightHand(i, 2))-azimuth_rightHand(above_thresh_idx_rightHand(i, 1)))/(above_thresh_idx_rightHand(i, 2)-above_thresh_idx_rightHand(i, 1));
    slope_abs(i) = abs(slope(i));
end


if above_thresh_idx_rightHand(2, 1) < above_thresh_idx_rightHand(1, 2)+(above_thresh_idx_rightHand(1, 2)-above_thresh_idx_rightHand(1, 1))/3
    if slope_abs(1) > slope_abs(2)
        shots_idx = [shots_idx; above_thresh_idx_rightHand(1, :)];
    end
else
    shots_idx = [shots_idx; above_thresh_idx_rightHand(1, :)];
end
for i=2:height(above_thresh_idx_rightHand)-1
    prev_flag = 0;
    next_flag = 0;
    if above_thresh_idx_rightHand(i-1, 2) > above_thresh_idx_rightHand(i, 1)-(above_thresh_idx_rightHand(i, 2)-above_thresh_idx_rightHand(i, 1))/3
        if slope_abs(i) > slope_abs(i-1)
            prev_flag = 1;
        end
    else
        prev_flag = 1;
    end
    if above_thresh_idx_rightHand(i+1, 1) < above_thresh_idx_rightHand(i, 2)+(above_thresh_idx_rightHand(i, 2)-above_thresh_idx_rightHand(i, 1))/3
        if slope_abs(i) > slope_abs(i+1)
            next_flag = 1;
        end
    else
        next_flag = 1;
    end
    if prev_flag == 1 && next_flag == 1
        shots_idx = [shots_idx; above_thresh_idx_rightHand(i, :)];
    end
end
if above_thresh_idx_rightHand(height(above_thresh_idx_rightHand)-1, 2) > above_thresh_idx_rightHand(height(above_thresh_idx_rightHand), 1)-(above_thresh_idx_rightHand(height(above_thresh_idx_rightHand), 2)-above_thresh_idx_rightHand(height(above_thresh_idx_rightHand), 1))/3
    if slope_abs(height(above_thresh_idx_rightHand)) > slope_abs(height(above_thresh_idx_rightHand)-1)
        shots_idx = [shots_idx; above_thresh_idx_rightHand(height(above_thresh_idx_rightHand), :)];
    end
else
    shots_idx = [shots_idx; above_thresh_idx_rightHand(height(above_thresh_idx_rightHand), :)];
end
if height(shots_idx) > 1
    shots_idx = shots_idx(2:end, :);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%여기는 공 감지 결과 사용 X
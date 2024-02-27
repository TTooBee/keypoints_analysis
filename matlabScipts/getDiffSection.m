function [diff_pos_idx, diff_neg_idx] = getDiffSection(input)
% 입력은 벡터, 출력은 도함수가 양수인 구간들과 음수인 구간들의 인덱스
diff_pos_idx = zeros(1, 2);
diff_neg_idx = zeros(1, 2);

diff_input = diff(input);

pos_count = 0;
neg_count = 0;

temp = zeros(1, 2);

for i=2:length(diff_input)
    if diff_input(i) >= 0 && diff_input(i-1) >= 0
        pos_count = pos_count + 1;
        if i == length(diff_input)
            temp(1) = i - pos_count;
            temp(2) = i;
            diff_pos_idx = [diff_pos_idx; temp];
        end
    elseif diff_input(i) < 0 && diff_input(i-1) >= 0
        temp(1) = i - (pos_count + 1);
        temp(2) = i - 1;
        diff_pos_idx = [diff_pos_idx; temp];
        pos_count = 0;
    elseif diff_input(i) < 0 && diff_input(i-1) < 0
        neg_count = neg_count + 1;
        if i == length(diff_input)
            temp(1) = i - neg_count;
            temp(2) = i;
            diff_neg_idx = [diff_neg_idx; temp];
        end
    elseif diff_input(i) >= 0 && diff_input(i-1) < 0
        temp(1) = i - (neg_count + 1);
        temp(2) = i - 1;
        diff_neg_idx = [diff_neg_idx; temp];
        neg_count = 0;
    end
end

if height(diff_pos_idx) > 1
    diff_pos_idx = diff_pos_idx(2:end, :);
end
if height(diff_neg_idx) > 1
    diff_neg_idx = diff_neg_idx(2:end, :);
end
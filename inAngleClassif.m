function out_angle_vector = inAngleClassif(origin_x, width)

% i에 대해 양쪽 값과의 차이를 행렬에 저장해둠
diff_matrix = zeros(length(origin_x), 1);
for i=2:length(origin_x)-1
    diff_matrix(i, 1) = abs(origin_x(i-1)-origin_x(i));
    diff_matrix(i, 2) = abs(origin_x(i)-origin_x(i+1));
end

out_angle_vector = zeros(length(origin_x), 1);
flag = 0;
for i=1:height(diff_matrix)
    if abs(diff_matrix(i, 1)) < 50 && abs(diff_matrix(i, 2)) > 50 % sb
        if origin_x(i) < 50 || origin_x(i) > width-50 % 앵글 밖
            % out_angle_vector(i+1) = 1;
            flag = 1;
        else
            if flag == 1
                out_angle_vector(i) = 1;
            end
        end
    elseif abs(diff_matrix(i, 1)) > 50 && abs(diff_matrix(i, 2)) < 50 % bs
        if origin_x(i) < 50 || origin_x(i) > width-50 % 앵글 밖
            % out_angle_vector(i-1) = 1;
            flag = 0;
        else
            if flag == 1
                out_angle_vector(i) = 1;
            end
        end
    elseif abs(diff_matrix(i, 1)) < 50 && abs(diff_matrix(i, 2)) < 50 % ss
        if flag == 1
            out_angle_vector(i) = 1;
        end
    elseif abs(diff_matrix(i, 1)) > 50 && abs(diff_matrix(i, 2)) > 50 % bb
        out_angle_vector(i) = 1;
    end
end

figure;
stem(out_angle_vector)

disp(diff_matrix)
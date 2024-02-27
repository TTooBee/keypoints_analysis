function speed = getSpeed(input_matrix)
    % 입력 행렬의 행 수에 따라 속도 벡터를 초기화합니다.
    speed = zeros(size(input_matrix, 1), 1);

    % 각 행에 대해 반복하여 속도를 계산합니다.
    for i = 2:size(input_matrix, 1)
        % 연속된 행렬 행의 차이를 계산합니다.
        delta = input_matrix(i, :) - input_matrix(i-1, :);
        % 유클리드 거리(속도)를 계산합니다.
        speed(i) = sqrt(sum(delta.^2));
    end
end
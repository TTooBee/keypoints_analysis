function azimuth_expanded = azimuthExpansion(azimuth)
% azimuth의 미분 불가능한 점을 없애는 알고리즘
pos_to_neg_flag = 0;
neg_to_pos_flag = 0;

azimuth_expanded = zeros(height(azimuth), 1);

azimuth_expanded(1) = azimuth(1);

for i=2:height(azimuth)
    if pos_to_neg_flag == 0 && neg_to_pos_flag == 0 % 현재는 정상적인 상황
        if azimuth(i-1) < -0.8*pi && azimuth(i) > 0.8*pi % azimuth가 감소해서 -pi->pi로 감
            neg_to_pos_flag = 1;
            pos_to_neg_flag = 0;
            difference = pi - azimuth(i);
            azimuth_expanded(i) = -pi - difference;
        elseif azimuth(i-1) > 0.8*pi && azimuth(i) < -0.8*pi % azimuth가 감소해서 -pi->pi로 감
            neg_to_pos_flag = 0;
            pos_to_neg_flag = 1;
            difference = azimuth(i) + pi;
            azimuth_expanded(i) = pi + difference;
        else
            azimuth_expanded(i) = azimuth(i); % 미분 불가능한 점을 통과하지 않은 정상적인 상태
        end
    elseif pos_to_neg_flag == 0 && neg_to_pos_flag == 1 % 현재는 -pi에서 pi로 넘어온 상태
        if azimuth(i-1) > 0.8*pi && azimuth(i) < -0.8*pi % 다시 -pi쪽으로 넘어가면?
            neg_to_pos_flag = 0;
            azimuth_expanded(i) = azimuth(i);
        else
            difference = pi - azimuth(i);
            azimuth_expanded(i) = -pi - difference;
        end
    elseif pos_to_neg_flag == 1 && neg_to_pos_flag == 0 % 현재는 pi에서 -pi로 넘어온 상태
        if azimuth(i-1) < -0.8*pi && azimuth(i) > 0.8*pi % 다시 pi쪽으로 넘어가면?
            pos_to_neg_flag = 0;
            azimuth_expanded(i) = azimuth(i);
        else
            difference = pi + azimuth(i);
            azimuth_expanded(i) = pi + difference;
        end
    end
end
origin_coord = 1:100;
origin_coord(50) = 400;
origin_coord(80) = 400;

not_diff = 0;
diff_origin_coord = diff(origin_coord);
for i=1:length(diff_origin_coord)
    if diff_origin_coord(i) > 50 || diff_origin_coord(i) < -50
        not_diff = [not_diff; i];
    end
end
not_diff = not_diff(2:end);

figure;
plot(diff_origin_coord)

disp(not_diff)
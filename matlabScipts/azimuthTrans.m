function azimuth_new = azimuthTrans(azimuth)
azimuth_new = zeros(length(azimuth), 1);
for i=1:length(azimuth)
    if (azimuth(i)>-1*pi) && (azimuth(i)<-1*pi/2)
        azimuth_new(i) = azimuth(i) + 2*pi;
    else
        azimuth_new(i) = azimuth(i);
    end
    azimuth_new(i) = azimuth_new(i) - pi/2;
end
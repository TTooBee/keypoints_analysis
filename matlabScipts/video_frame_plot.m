% 영상 파일을 불러옵니다.
v = VideoReader('D:\Users\Sehyun Sohn\keypoints_analysis\videos\thiem_volleys_0212.mp4');

% 특정 프레임을 읽습니다. 여기서는 10번째 프레임입니다.
frame = read(v, 156);

% 읽은 프레임을 표시합니다.
figure(30);
imshow(frame);

title('Frame');
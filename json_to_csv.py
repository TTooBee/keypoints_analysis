import json
import pandas as pd
import os

# JSON 파일 경로를 지정하세요.
file_path = 'pose_keypoints/yoon_game_0215.json'

# CSV 파일을 생성할 디렉토리 경로를 지정하세요.
output_directory = 'keypoints/yoon_game_0215'

# JSON 파일을 읽습니다.
with open(file_path, 'r') as file:
    data = json.load(file)

# 각 키포인트의 xyz 데이터를 저장할 딕셔너리를 초기화합니다.
keypoints_data = {k: [] for k in range(24)}

# # 데이터를 반복하면서 idx가 1인 항목의 pred_xyz_jts 데이터를 추출합니다.
# for entry in data:
#     if entry.get('idx') == 1:  # idx가 1인 경우
#         pred_xyz_jts = entry.get('pred_xyz_jts', [])
#         for i, xyz in enumerate(pred_xyz_jts):
#             keypoints_data[i].append(xyz)
            
            
# image_id별로 데이터를 그룹화하고, 각 그룹에서 box 높이가 가장 큰 데이터를 추출합니다.
grouped_data = {}
for entry in data:
    image_id = entry['image_id']
    if image_id not in grouped_data:
        grouped_data[image_id] = []
    grouped_data[image_id].append(entry)

for image_id, entries in grouped_data.items():
    # Box 높이가 가장 큰 entry를 찾습니다.
    max_height_entry = max(entries, key=lambda x: x['box'][3])
    # pred_xyz_jts 데이터를 추출하고 저장합니다.
    pred_xyz_jts = max_height_entry.get('pred_xyz_jts', [])
    for i, xyz in enumerate(pred_xyz_jts):
        keypoints_data[i].append(xyz)

# 출력 디렉토리가 존재하지 않으면 생성합니다.
if not os.path.exists(output_directory):
    os.makedirs(output_directory)

# 각 키포인트에 대해 DataFrame을 생성하고 지정된 디렉토리에 CSV 파일로 저장합니다.
for i in range(24):
    df = pd.DataFrame(keypoints_data[i], columns=['x', 'y', 'z'])
    csv_file_name = os.path.join(output_directory, f'result_{i}.csv')
    df.to_csv(csv_file_name, index=False)

print("CSV 파일이 지정된 디렉토리에 생성되었습니다.")
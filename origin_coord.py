import json
import pandas as pd

# Specify the path to your JSON file
file_path = 'pose_keypoints\monfis_0206.json'

# Read the JSON data from the file
with open(file_path, 'r') as file:
    data = json.load(file)

# Initialize a list to hold the x and y coordinates for the "idx" 1 keypoints
origin_coords = []

# Iterate through the data to find the entries where "idx" is 1 and extract the first two keypoints
for entry in data:
    if entry.get('idx') == 1:  # Filter for entries where "idx" is 1
        keypoints = entry.get('keypoints', [])
        # Extract the x and y coordinates of the first keypoint (assuming keypoints are stored in a flat list)
        if len(keypoints) >= 2:
            x_coord = keypoints[0]
            y_coord = keypoints[1]
            origin_coords.append([x_coord, y_coord])

# Convert the list of coordinates into a DataFrame
df_origin_coords = pd.DataFrame(origin_coords, columns=['x', 'y'])

# Define the path where you want to save the CSV file
csv_file_path = 'keypoints/monfis_0206/result_origin_coord.csv'

# Save the DataFrame to a CSV file
df_origin_coords.to_csv(csv_file_path, index=False)

print(f"CSV 파일이 다음의 경로에 생성됨 {csv_file_path}")
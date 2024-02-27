import json
import pandas as pd

# Specify the path to your JSON file
file_path = 'pose_keypoints/sinner_0203.json'

# Read the JSON data from the file
with open(file_path, 'r') as file:
    data = json.load(file)

# Initialize a list to store the box sizes
box_sizes = []

# Group data by image_id
grouped_data = {}
for entry in data:
    image_id = entry['image_id']
    if image_id not in grouped_data:
        grouped_data[image_id] = []
    grouped_data[image_id].append(entry)

# Iterate through the grouped data
for image_id, entries in grouped_data.items():
    # Find the entry with the largest box by height
    max_height_entry = max(entries, key=lambda x: x['box'][3])
    # Extract the box size (width and height)
    box_width = max_height_entry['box'][2]
    box_height = max_height_entry['box'][3]
    box_sizes.append([box_width, box_height])

# Convert the list of box sizes into a DataFrame
df_box_sizes = pd.DataFrame(box_sizes, columns=['width', 'height'])

# Define the path where you want to save the CSV file
csv_file_path = 'keypoints/sinner_0203/result_box_size.csv'

# Save the DataFrame to a CSV file
df_box_sizes.to_csv(csv_file_path, index=False)

print(f"CSV 파일 생성 완료 {csv_file_path}")
import os

# Define the path inside the Docker container where you want to save the text file
docker_path = '/mnt/geojson/filename.txt'

# Text content you want to write to the file
text_content = "Hello, this is a sample text file created inside the Docker container!"

# Ensure the directory exists
os.makedirs(os.path.dirname(docker_path), exist_ok=True)

# Write the content to the text file
with open(docker_path, 'w') as f:
    f.write(text_content)

print(f"Text file created at {docker_path}")

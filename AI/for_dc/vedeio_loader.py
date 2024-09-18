import cv2
import os
import numpy as np
from torch.utils.data import Dataset, DataLoader

# Custom dataset class
class AviVideoDataset(Dataset):
    def __init__(self, video_dir, transform=None):
        """
        Args:
            video_dir (str): Directory containing video files
            transform (callable, optional): Optional transform to be applied on a sample
        """
        self.video_paths = [os.path.join(video_dir, f) for f in os.listdir(video_dir) if f.endswith('.avi')]
        self.transform = transform

    def __len__(self):
        return len(self.video_paths)

    def __getitem__(self, idx):
        video_path = self.video_paths[idx]
        cap = cv2.VideoCapture(video_path)  # Open the video file
        frames = []
        
        while True:
            ret, frame = cap.read()  # Read video frame by frame
            if not ret:
                break
            
            # Convert the frame to grayscale and stack it to create 2 channels
            gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            two_channel_frame = np.stack((gray_frame, gray_frame), axis=0)  # Create 2 channels

            if self.transform:
                two_channel_frame = self.transform(two_channel_frame)

            frames.append(two_channel_frame)

        cap.release()

        # Convert the list of frames into a numpy array
        video_array = np.stack(frames, axis=0)  # Shape: (number of frames, 2, height, width)
        return video_array


# Function to create the DataLoader
def create_dataloader(video_dir, batch_size=4, shuffle=True, num_workers=0):
    dataset = AviVideoDataset(video_dir=video_dir)
    dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=shuffle, num_workers=num_workers)
    return dataloader


# Example usage
if __name__ == "__main__":
    video_dir = "path_to_video_folder"  # Path to the directory containing the video files
    dataloader = create_dataloader(video_dir, batch_size=2)
    
    for batch in dataloader:
        print(batch.shape) 
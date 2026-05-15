import os
import time
import subprocess
import shutil
import sys

def create_dummy_video(directory: str):
    file_name = "test_video.mp4"
    file_path = os.path.join(directory, file_name)
    print(f"Creating dummy video file: {file_path}")
    with open(file_path, "wb") as f:
        f.write(os.urandom(1024)) # 1KB of random data
    return file_path

def main():
    test_dir = "./test_watchdog_dir"
    if not os.path.exists(test_dir):
        os.makedirs(test_dir)
    
    print(f"Starting watchdog in {test_dir}...")
    # Start the watchdog in a subprocess
    try:
        # Use sys.executable to ensure we use the same python interpreter
        process = subprocess.Popen([sys.executable, "src/video_transcoder/watchdog.py", test_dir], 
                                   env={"PYTHONPATH": "."},
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        time.sleep(2) # Wait for watchdog to start
        
        # Create the dummy file
        create_dummy_video(test_dir)
        
        # Wait and see if it detects it
        time.sleep(5)
        
        process.terminate()
        print("Test completed.")
    except Exception as e:
        print(f"Test failed: {e}")
    finally:
        if os.path.exists(test_dir):
            shutil.rmtree(test_dir)

if __name__ == "__main__":
    main()

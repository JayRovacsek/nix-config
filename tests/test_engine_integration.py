import os
import subprocess
import pytest
from src.video_transcoder.engine import transcode

def test_transcode_basic(tmp_path):
    # 1. Create a dummy video file using ffmpeg
    input_file = tmp_path / "input.mp4"
    # Create a tiny black video
    subprocess.run([
        "ffmpeg", "-y", "-f", "lavfi", "-i", "testsrc=duration=1:size=320x240:rate=30",
        "-c:v", "h264", str(input_file)
    ], check=True, capture_output=True)

    # 2. Run the transcode function
    output_file = tmp_path / "output.mp4"
    transcode(str(input_file), codec="h264", output=str(output_file))

    # 3. Assertions
    assert os.path.exists(output_file)
    assert os.path.getsize(output_file) > 0

if __name__ == "__main__":
    pytest.main([__file__])

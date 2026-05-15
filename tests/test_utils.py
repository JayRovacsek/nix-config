import pytest
import subprocess
import os
import stat
from src.video_transcoder.utils import get_metadata, preserve_permissions

@pytest.fixture
def dummy_video(tmp_path):
    """Creates a tiny valid video file for testing."""
    video_path = tmp_path / "test.mp4"
    cmd = [
        "ffmpeg",
        "-f", "lavfi",
        "-i", "testsrc=duration=1:size=16x16:rate=1",
        "-t", "1",
        str(video_path),
        "-y"
    ]
    subprocess.run(cmd, capture_output=True, check=True)
    return str(video_path)

def test_get_metadata_returns_correct_format(dummy_video):
    result = get_metadata(dummy_video)
    assert "format" in result
    assert "duration" in result["format"]

def test_preserve_permissions(tmp_path):
    original = tmp_path / "original.txt"
    target = tmp_path / "target.txt"
    original.write_text("original content")
    target.write_text("target content")
    
    # Set original to be non-readable/executable (e.g., mode 0o400)
    os.chmod(original, stat.S_IREAD)
    
    preserve_permissions(str(original), str(target))
    
    # Check if target has same mode as original
    assert stat.S_IMODE(os.stat(target).st_mode) == stat.S_IMODE(os.stat(original).st_mode)

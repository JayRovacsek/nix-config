import json
import subprocess
import shutil
from typing import Any, Dict
import os

def get_metadata(path: str) -> Dict[str, Any]:
    """
    Extracts metadata from a video file using ffprobe.
    Returns a dictionary containing the format information.
    """
    command = [
        "ffprobe",
        "-v", "error",
        "-show_format",
        "-print_format", "json",
        path
    ]
    
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        data = json.loads(result.stdout)
        return data
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Failed to run ffprobe: {e}") from e
    except json.JSONDecodeError as e:
        raise RuntimeError(f"Failed to parse ffprobe output: {e}") from e
    except Exception as e:
        raise RuntimeError(f"An unexpected error occurred during metadata extraction: {e}") from e

def preserve_permissions(original: str, target: str) -> None:
    """
    Copies the permission bits (mode) from the original file to the target file.
    """
    try:
        shutil.copymode(original, target)
    except Exception as e:
        raise RuntimeError(f"Failed to preserve permissions from {original} to {target}: {e}") from e

def check_disk_space(path: str, required_bytes: int) -> bool:
    """
    Checks if there is enough available disk space in the given path.
    Returns True if space is available, False otherwise.
    """
    try:
        usage = shutil.disk_usage(path)
        return usage.free > required_bytes
    except Exception as e:
        raise RuntimeError(f"Failed to check disk space at {path}: {e}") from e

import os
import subprocess
import tempfile
import shutil
from typing import List, Optional
from video_transcoder.utils import preserve_permissions, get_metadata, check_disk_space

def transcode(
    path: str, 
    codec: Optional[str] = None, 
    ffmpeg_args: List[str] = None, 
    output: Optional[str] = None,
    use_nvenc: bool = False,
    optimise_with_llm: bool = False,
    api_key: Optional[str] = None
) -> None:

    """
    Transcodes a video file using FFmpeg.
    
    Args:
        path: The input file path.
        codec: The target video codec (e.g., 'h264').
        ffmpeg_args: Additional FFmpeg arguments.
        output: The output file path. If None, uses a default name.
        use_nvenc: Whether to use NVIDIA NVENC acceleration.
        optimise_with_llm: Whether to request LLM-driven optimisation.
        api_key: API key for the LLM optimiser.
    """
    if not os.path.exists(path):
        raise FileNotFoundError(f"Input file not found: {path}")
    
    # 1. Extract Metadata
    metadata = get_metadata(path)
    
    if output is None:
        base, ext = os.path.splitext(path)
        output = f"{base}_transcoded{ext}"

    # 2. Determine Codec and NVENC
    target_codec = codec
    if use_nvenc:
        # If NVENC is requested but no codec is provided, default to h264_nvenc
        if not target_codec:
            target_codec = "h264_nvenc"
        elif "_nvenc" not in target_codec:
            # Map generic names to their NVENC equivalents or append if appropriate
            nvenc_map = {
                "h264": "h264_nvenc",
                "hevc": "hevc_nvenc",
                "h265": "hevc_nvenc",
            }
            if target_codec in nvenc_map:
                target_codec = nvenc_map[target_codec]
            elif "lib" not in target_codec:
                target_codec = f"{target_codec}_nvenc"

    # 3. LLM Optimisation (if requested)
    additional_flags = list(ffmpeg_args) if ffmpeg_args else []
    if optimise_with_llm and api_key:
        optimiser = LLM_Optimiser(api_key=api_key)
        import asyncio
        try:
            suggested_flags = asyncio.run(optimiser.suggest_optimisations(metadata, additional_flags))
        except RuntimeError:
            # If an event loop is already running (e.g. in tests), we fallback to a simpler approach or log it.
            # For now, we'll try to get the loop if asyncio.run fails.
            loop = asyncio.get_event_loop()
            suggested_flags = loop.run_until_complete(optimiser.suggest_optimisations(metadata, additional_flags))
        
        # Validate suggested flags before using them
        if FlagValidator.validate_flags(suggested_flags):
            additional_flags.extend(suggested_flags)

    # 4. Prepare Output Directory and Temp File
    output_dir = os.path.dirname(os.path.abspath(output))
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Check disk space before proceeding (sanity check: 100MB)
    if not check_disk_space(output_dir, 100 * 1024 * 1024):
        raise RuntimeError(f"Insufficient disk space in {output_dir} to perform transcoding (need ~100MB minimum).")

    temp_file = None
    try:
        # Create a temporary file in the same directory to ensure atomic move works.
        # We use mkstemp to get a unique path and close the FD immediately so FFmpeg can write to it.
        _, ext = os.path.splitext(output)
        fd, temp_file = tempfile.mkstemp(dir=output_dir, suffix=ext if ext else ".tmp")
        os.close(fd)

        # 5. Build the command
        cmd = ["ffmpeg", "-y", "-i", path]
        if target_codec:
            cmd.extend(["-c:v", target_codec])
        
        # Add additional flags (including LLM suggested ones)
        cmd.extend(additional_flags)
        
        # Final output
        cmd.append(temp_file)

        # 6. Execute Transcoding
        subprocess.run(cmd, capture_output=True, text=True, check=True)
        
        # 7. Atomic Swap
        shutil.move(temp_file, output)
        
        # 8. Preserve permissions and metadata
        preserve_permissions(path, output)

    except Exception as e:
        if temp_file and os.path.exists(temp_file):
            os.remove(temp_file)
        raise e
    finally:
        if temp_file and os.path.exists(temp_file):
            os.remove(temp_file)

if __name__ == "__main__":
    # For local testing
    pass

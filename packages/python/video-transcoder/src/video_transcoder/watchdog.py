import os
import time
import asyncio
import logging
import argparse
import sys
from video_transcoder.engine import transcode

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("watchdog")

class PollingWatchdog:
    """
    A simple watchdog that polls a directory for new files.
    """
    def __init__(self, monitor_dir: str, transcode_args: dict):
        self.monitor_dir = monitor_dir
        self.transcode_args = transcode_args
        self.supported_extensions = {'.mp4', '.mkv', '.mov', '.avi', '.flv', '.wmv'}
        self.known_files = set()

    async def run(self):
        """
        Main loop for the polling watchdog.
        """
        if not os.path.exists(self.monitor_dir):
            os.makedirs(self.monitor_dir)

        # Initialize known files to avoid transcoding existing files immediately if desired.
        # For this implementation, we will only watch for NEW files created after startup.
        logger.info(f"Polling watchdog started monitoring: {self.monitor_dir}")
        logger.info(f"Transcoding settings: {self.transcode_args}")
        
        try:
            while True:
                for filename in os.listdir(self.monitor_dir):
                    file_path = os.path.join(self.monitor_dir, filename)
                    
                    if os.path.isfile(file_path):
                        ext = os.path.splitext(file_path)[1].lower()
                        if ext in self.supported_extensions and file_path not in self.known_files:
                            # Check if the file is still being written to (size stability)
                            if self._is_file_ready(file_path):
                                self.known_files.add(file_path)
                                logger.info(f"New video file detected: {file_path}")
                                asyncio.create_task(self._transcode_task(file_path))
                
                await asyncio.sleep(2) # Poll every 2 seconds
        except asyncio.CancelledError:
            logger.info("Polling watchdog stopping...")
        except Exception as e:
            logger.error(f"Polling watchdog error: {e}")

    def _is_file_ready(self, file_path: str) -> bool:
        """
        Checks if a file is stable (not being actively written to).
        """
        try:
            initial_size = os.path.getsize(file_path)
            time.sleep(0.5)
            final_size = os.path.getsize(file_path)
            return initial_size == final_size and initial_size > 0
        except Exception:
            return False

    async def _transcode_task(self, file_path: str):
        logger.info(f"Starting background transcoding for: {file_path}")
        try:
            # Use the provided arguments for transcoding
            transcode(path=file_path, **self.transcode_args)
            logger.info(f"Background transcoding completed: {file_path}")
        except Exception as e:
            logger.error(f"Background transcoding failed for {file_path}: {e}")

async def run_watchdog(monitor_dir: str, transcode_args: dict):
    """
    Entry point for the watchdog service.
    """
    watcher = PollingWatchdog(monitor_dir, transcode_args)
    await watcher.run()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Video Transcoder Polling Watchdog Service")
    parser.add_argument("directory", help="Directory to monitor for new video files")
    parser.add_argument("--codec", help="Video codec to use (e.g., 'h264', 'h264_nvenc')")
    parser.add_argument("--output", help="Output directory/file pattern")
    parser.add_argument("--optimise", action="store_true", help="Enable LLM-driven optimisation")
    parser.add_argument("--api-key", help="API key for the LLM optimiser")
    parser.add_argument("--use-nvenc", action="store_true", help="Use NVIDIA NVENC acceleration")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose output")
    args = parser.parse_args()

    if not os.path.isdir(args.directory):
        print(f"Error: {args.directory} is not a directory.")
        sys.exit(1)

    # Prepare the dictionary of arguments to pass to transcode
    transcode_args = {
        "codec": args.codec,
        "output": args.output,
        "optimise_with_llm": args.optimise,
        "api_key": args.api_key,
        "use_nvenc": args.use_nvenc
    }

    try:
        asyncio.run(run_watchdog(args.directory, transcode_args))
    except KeyboardInterrupt:
        pass


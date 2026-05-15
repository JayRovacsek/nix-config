import argparse
import sys
import os
from video_transcoder.engine import transcode

def main():
    parser = argparse.ArgumentParser(description="Video Transcoder CLI")
    parser.add_argument("input", help="Input video file path")
    parser.add_argument("--codec", help="Video codec to use (e.g., 'h264', 'h264_nvenc')")
    parser.add_argument("--output", help="Output video file path")
    parser.add_argument("--optimise", action="store_true", help="Enable LLM-driven optimisation")
    parser.add_argument("--api-key", help="API key for the LLM optimiser")
    parser.add_argument("--use-nvenc", action="store_true", help="Use NVIDIA NVENC acceleration")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose output")

    args = parser.parse_args()

    if not os.path.exists(args.input):
        print(f"Error: Input file not found: {args.input}")
        sys.exit(1)

    try:
        if args.verbose:
            print(f"Starting transcoding: {args.input}")
            print(f"  Codec: {args.codec}")
            print(f"  Output: {args.output}")
            print(f"  Optimise: {args.optimise}")
            print(f"  NVENC: {args.use_nvenc}")

        transcode(
            path=args.input,
            codec=args.codec,
            output=args.output,
            use_nvenc=args.use_nvenc,
            optimise_with_llm=args.optimise,
            api_key=args.api_key
        )

        if args.verbose:
            print("Transcoding completed successfully.")
        else:
            print(f"Successfully transcoded {args.input} to {args.output or 'default output'}")

    except Exception as e:
        print(f"Transcoding failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

# Video Transcoder Package

A high-performance Python-based video transcoding system that leverages FFmpeg, LLM-driven parameter optimisation (via OpenAI), and a directory watchdog service.

## Features

- **Core Transcoding Engine**: Robust implementation of FFmpeg transcoding with atomic file replacement to ensure data integrity.
- **LLM-Driven Optimisation**: Uses OpenAI's Structured Outputs to suggest optimal FFmpeg flags (e.g., `-crf`, `-preset`) based on video metadata.
- **Safety & Validation**: Includes a strict flag validator to prevent shell injection and invalid FFmpeg parameters.
- **Watchdog Service**: A background service that monitors directories for new video files and automatically starts transcoding them.
- **Performance**: Supports NVIDIA NVENC hardware acceleration.
- **Reliability**: Checks for sufficient disk space before starting long-running jobs.

---

## Installation & Environment

This project is designed to run within a Nix-managed environment. Ensure you have the necessary dependencies (FFmpeg, Python, etc.) available via your Nix shell.

```bash
# Example: Run within a nix shell if configured
nix-shell -p python3 ffmpeg
```

---

## Usage

### 1. Command Line Interface (CLI)

The CLI is the primary way to perform one-off transcoding tasks.

#### Basic Usage

```bash
python3 src/video_transcoder/cli.py input_video.mp4
```

#### Using Hardware Acceleration (NVENC)

```bash
python3 src/video_transcoder/cli.py input_video.mp4 --use-nvenc
```

#### Using LLM Optimisation

Provide an OpenAI API key to allow the system to suggest optimal flags for your video.

```bash
python3 src/video_transcoder/cli.py input_video.mp4 --optimise --api-key "YOUR_OPENAI_API_KEY"
```

#### Specifying Codec and Output

```bash
python3 src/video_transcoder/cli.py input_video.mp4 --codec h264 --output output_file.mp4
```

---

### 2. Watchdog Service

The watchdog service monitors a directory and automatically transcodes any new video file detected (e.g., `.mp4`, `.mkv`, `.mov`, `.avi`, `.flv`, `.wmv`).

#### Basic Usage

```bash
python3 src/video_transcoder/watchdog.py /path/to/monitor_directory
```

#### Usage with Transcoding Flags

You can configure the watchdog to use specific transcoding parameters for every file it finds:

**Example: Monitor a directory and use NVENC with LLM optimisation:**

```bash
python3 src/video_transcoder/watchdog.py /path/to/monitor_directory \
    --use-nvenc \
    --optimise \
    --api-key "YOUR_OPENAI_API_KEY"
```

**Example: Monitor a directory and force a specific codec:**

```bash
python3 src/video_transcoder/watchdog.py /path/to/monitor_directory \
    --codec h264
```

---

## Component Overview

- **`engine.py`**: The core logic responsible for metadata extraction, flag preparation, LLM interaction, and the FFmpeg execution loop.
- **`cli.py`**: The entry point for user interactions via terminal.
- **`llm.py`**: Manages communication with OpenAI to request optimised FFmpeg parameters.
- **`validator.py`**: Ensures that all flags (including those suggested by the LLM) are safe and syntactically correct.
- **`utils.py`**: Provides utility functions for metadata extraction, permission preservation, and disk space checks.
- **`watchdog.py`**: A polling-based service for continuous directory monitoring.

---

## Development & Testing

To run the integration tests:

```bash
PYTHONPATH=. python3 tests/test_watchdog_integration.py
```

---

## Usage

### 1. Command Line Interface (CLI)

The CLI is the primary way to perform one-off transcoding tasks.

#### Basic Usage

```bash
python3 src/video_transcoder/cli.py input_video.mp4
```

#### Using Hardware Acceleration (NVENC)

```bash
python3 src/video_transcoder/cli.py input_video.mp4 --use-nvenc
```

#### Using LLM Optimisation

Provide an OpenAI API key to allow the system to suggest optimal flags for your video.

```bash
python3 src/video_transcoder/cli.py input_video.mp4 --optimise --api-key "YOUR_OPENAI_API_KEY"
```

#### Specifying Codec and Output

```bash
python3 src/video_transcoder/cli.py input_video.mp4 --codec h264 --output output_file.mp4
```

---

### 2. Watchdog Service

The watchdog service monitors a directory and automatically transcodes any new video file detected (e.g., `.mp4`, `.mkv`, `.mov`, etc.).

#### Running the Watchdog

```bash
python3 src/video_transcoder/watchdog.py /path/to/monitor_directory
```

_Note: The watchdog currently performs a standard transcode without LLM optimisation unless the engine is modified to pass keys._

---

## Component Overview

- **`engine.py`**: The core logic responsible for metadata extraction, flag preparation, LLM interaction, and the FFmpeg execution loop.
- **`cli.py`**: The entry point for user interactions via terminal.
- **`llm.py`**: Manages communication with OpenAI to request optimised FFmpeg parameters.
- **`validator.py`**: Ensures that all flags (including those suggested by the LLM) are safe and syntactically correct.
- **`utils.py`**: Provides utility functions for metadata extraction, permission preservation, and disk space checks.
- **`watchdog.py`**: A polling-based service for continuous directory monitoring.

---

## Development & Testing

To run the integration tests:

```bash
PYTHONPATH=. python3 tests/test_watchdog_integration.py
```

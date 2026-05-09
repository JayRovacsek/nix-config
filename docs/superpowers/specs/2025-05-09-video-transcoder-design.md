# Design: Video Transcoder System

## Overview

A robust, efficient video transcoding system consisting of a stateless Python CLI package (`video-transcoder`) and an intelligent NixOS service module (`video-transcoder-service`).

## 1. Core Package: `video-transcoder` (Python)

The core package is a stateless CLI tool designed for high-performance video transcoding using FFmpeg with hardware acceleration (e.g., CUDA).

### Features

- **Batch Mode**: Recursively scans a directory, uses `ffprobe` to check for the target codec, and performs the encoding.
- **Single File Mode**: Processes a specific file using provided FFmpeg arguments.
- **Safety & Integrity**:
  - **Atomic Replacement**: To prevent data loss, the script will transcode to a temporary file, verify its integrity via `ffprobe`, and then use an atomic swap (`os.replace`) to replace the original file.
  - **Metadata Parity**: Preserves original filenames, locations, and file permissions (using `shutil.copymode` or similar).
  - **Safe Defaults**: Uses "safe defaults" to prevent destructive actions on unsuitable files and gracefully handles errors during the transcoding process.
- **Hardware Acceleration**: Designed to leverage FFmpeg's hardware acceleration (e.g., `-hwaccel cuda`) and specific encoders like `av1_nvenc` when requested.
- **LLM Optimisation Component**:
  - **Input**: Metadata (via `ffprobe`) and current FFmpeg flags.
  - **Mechanism**: Uses the `openai` package to communicate with a configurable endpoint.
  - **Structured Outputs**: Uses a strict JSON schema (via OpenAI's Structured Outputs) to return exactly two fields: `suggested_flags` and `reasoning`.
  - **Logic**: Analyses the file profile to suggest flags that optimise the balance between size and quality.
  - **Strict Constraint**: The LLM is prohibited from changing the target codec; it is restricted to refining parameters for the existing codec.

### CLI Interface

- `--directory <path>`: Recursively scans the directory.
- `--file <path>`: Processes a single file.
- `--codec <codec>`: Target codec (e.g., `av1`, `hevc`).
- `--ffmpeg-args <args>`: Custom FFmpeg flags for encoding.
- `--llm-optimise`: Enables the LLM optimisation step.
- `--openai-endpoint <url>`: Custom API endpoint (e.g., for local `llama-cpp`).
- `--openai-api-key <key>`: Optional API key.
- `--llm-model <model>`: Model identifier to use.

## 2. NixOS Module: `video-transcoder-service`

A module that wraps the core package into a `systemd` service and manages the "intelligence":

- **Daemon Mode**: Uses the `watchdog` library to monitor filesystem events.
- **State Management**: Maintains a lightweight SQLite database to track processed files, preventing redundant `ffprobe` calls and ensuring the service doesn't re-process files upon restart.
- **NixOS Options**:
  - `videoTranscoder.watchDirectory`: The directory to monitor.
  - `videoTranscoder.targetCodec`: The default codec (e.g., `"av1"`).
  - `videoTranscoder.ffmpegArgs`: Custom FFmpeg options provided as a string.
  - `videoTranscoder.stateDatabase`: Path to the SQLite database.
  - `videoTranscoder.maxConcurrentEncodes`: Limit on simultaneous encoding tasks (default: `1`).
  - `videoTranscoder.enableLLMOptimisation`: Boolean to enable/disable the advisory optimisation step.
  - `videoTranscoder.openaiApiKey`: Optional API key for OpenAI service.
  - `videoTranscoder.openaiEndpoint`: Custom API endpoint (e.g., `http://localhost:8080/v1`) to allow for local `llama-cpp` or other compatible services.
  - `videoTranscoder.llmModel`: The model identifier to use (e.g., `gpt-4o` or `llama-3`).
  - Standard systemd options (user, group, etc.).

### Workflow & Concurrency

1. Filesystem event detected by `watchdog`.
2. Module checks the SQLite database to see if the file/path was already processed.
3. If new, the task is added to an internal execution queue.
4. The service manages a worker pool controlled by `maxConcurrentEncodes` to process the queue.
5. **Conflict Prevention**: The queue management and SQLite state ensure that no file is processed more than once and no two tasks target the same file path simultaneously.
6. Upon successful completion, the file path is recorded in the SQLite database.

## 3. Technology Stack

- **Core Logic**: Python 3.x
- **FFmpeg**: For video processing and `ffprobe` for inspection.
- **Database**: SQLite (for state tracking).
- **Monitoring**: `watchdog` library.
- **LLM Integration**: `openai` package.
- **System Integration**: NixOS / systemd.

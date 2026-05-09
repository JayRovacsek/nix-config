# Design: Video Transcoder System

## Overview

A robust, efficient video transcoding system consisting of a stateless Python CLI package (`video-transcoder`) and an intelligent NixOS service module (`video-transcoder-service`).

## 1. Core Package: `video-transcoder` (Python)

The core package is a stateless CLI tool designed for high-performance video transcoding using FFmpeg with hardware acceleration (e.g., CUDA).

### Features

- **Batch Mode**: Recursively scans a directory, uses `ffprobe` to check for the target codec, and performs the encoding.
- **Single File Mode**: Processes a specific file using provided FFmpeg arguments.
- **Safety & Integrity**:
  - Preserves original filenames, locations, and file permissions.
  - Uses "safe defaults" to prevent destructive actions on unsuitable files.
  - Gracefully handles errors during the transcoding process.
- **Hardware Acceleration**: Designed to leverage FFmpeg's hardware acceleration (e.g., `-hwaccel cuda`).

### CLI Interface

- `--directory <path>`: Recursively scans the directory.
- `--file <path>`: Processes a single file.
- `--codec <codec>`: Target codec (e.g., `av1`, `hevc`).
- `--ffmpeg-args <args>`: Custom FFmpeg flags for encoding.

## 2. NixOS Module: `video-transcoder-service`

A systemd-based service module that provides "intelligence" and persistent monitoring for the core package.

### Features

- **Daemon Mode**: Uses the `watchdog` library to monitor the filesystem for new files or changes in the target directory.
- **State Management**: Maintains a lightweight SQLite database to track processed files, preventing redundant `ffprobe` calls and ensuring efficiency across restarts.
- **NixOS Options**:
  - `videoTranscoder.watchDirectory`: The directory to monitor.
  - `videoTranscoder.targetCodec`: The default codec (default: `"av1"`).
  - `videoTranscoder.ffmpegArgs`: Custom FFmpeg options provided as a string.
  - `videoTranscoder.stateDatabase`: Path to the SQLite database.
  - Standard systemd options (user, group, etc.).

### Workflow

1. Filesystem event detected by `watchdog`.
2. Module checks the SQLite database to see if the file/path was already processed.
3. If new, the module invokes `video-transcoder --file <path> --codec <codec> --ffmpeg-args <args>`.
4. Upon successful completion, the file path is recorded in the SQLite database.

## 3. Technology Stack

- **Core Logic**: Python 3.x
- **FFmpeg**: For video processing and `ffprobe` for inspection.
- **Database**: SQLite (for state tracking).
- **Monitoring**: `watchdog` library.
- **System Integration**: NixOS / systemd.

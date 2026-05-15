# Video Transcoder System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a stateless Python CLI (`video-transcoder`) and a NixOS/systemd service (`video-transcoder-service`) for efficient, LLM-optimised video transcoding.

**Architecture:** A decoupled architecture consisting of a stateless CLI tool (`video-transcoder`) and a stateful service (`video-transcoder-service`) that manages a worker pool and maintains a SQLite database for idempotency.

**Tech Stack:** Python 3, FFmpeg (CUDA/NVENC), SQLite (WAL mode), Watchdog, OpenAI API (for LLM optimisation).

---

### Phase 1: Core Package (`video-transcoder`)

**Files:**

- Create: `src/video_transcoder/cli.py` (CLI Entrypoint)
- Create: `src/video_transcoder/engine.py` (Transcoding Logic)
- Create: `src/video_transcoder/llm.py` (LLM Optimisation)
- Create: `src/video_transcoder/utils.py` (Metadata & File Ops)
- Create: `src/video_transcoder/validator.py` (FFmpeg Flag Validation)
- Test: `tests/test_cli.py`, `tests/test_engine.py`, `tests/test_llm.py`

#### Task 1: Basic CLI and Metadata Utilities

- [ ] **Step 1: Write the failing test** for metadata extraction using `ffprobe`.
- [ ] **Step 2: Implement `utils.py`** with `get_metadata(path)` and `preserve_permissions(original, target)`.
- [ ] **Step 3: Implement basic CLI structure** in `cli.py` using `argparse`.
- [ ] **Step 4: Run tests and verify.**

#### Task 2: Atomic Transcoding Engine

- [ ] **Step 1: Write failing test** for atomic swap using `os.replace` and temporary files.
- [ ] **Step 2: Implement `engine.py`** with `transcode(path, codec, ffmpeg_args)`.
- [ ] **Step 3: Implement the "Safe Default" logic** and error handling.
- [ ] **Step 4: Run tests and verify.**

#### Task 3: LLM Optimisation Component

- [ ] **Step 1: Write test** for Structured Output parsing using the `openai` client mock.
- [ ] **Step 2: Implement `llm.py`** with `get_optimised_flags(metadata, current_args)`.
- [ ] **Step 3: Implement strict constraint logic** to ensure the codec is never changed.
- [ ] **Step 4: Run tests and verify.**

#### Task 4: FFmpeg Flag Validation

- [ ] **Step 1: Implement `validator.py`** to check against a whitelist of safe/known-good flags.
- [ ] **Step 2: Integrate validator into `engine.py`**.
- [ ] **Step 3: Run tests and verify.**

---

### Phase 2: NixOS Module (`video-transcoder-service`)

**Files:**

- Create: `src/video_transcoder/service.py` (Watchdog Service)
- Create: `src/video_transcoder/db.py` (SQLite Manager)
- Create: `modules/video-transcoder.nix` (NixOS Module)
- Test: `tests/test_service.py`, `tests/test_db.py`

#### Task 5: State Management (SQLite)

- [ ] **Step 1: Implement `db.py`** with `is_processed(path)` and `mark_processed(path)`.
- [ ] **Step 2: Use SQLite WAL mode** for high concurrency.
- [ ] **Step 3: Run tests and verify.**

#### Task 6: Watchdog Daemon and Worker Pool

- [ ] **Step 1: Implement `service.py`** using `watchdog`.
- [ ] **Step 2: Implement "Settle Time" logic** (wait for file stability before processing).
- [ ] **Step 3: Implement the Worker Pool** controlled by `maxConcurrentEncodes`.
- [ ] **Step 4: Integrate SQLite/DB checks** into the watcher loop.
- [ ] **Step 5: Run tests and verify.**

#### Task 7: NixOS Module Implementation

- [ ] **Step 1: Create `modules/video-transcoder.nix`** with all configured options (directory, codec, args, etc.).
- [ ] **Step 2: Define the `systemd` service** that launches the `service.py` daemon.
- [ ] **Step 3: Test module integration via `nixos-rebuild build-vm` (if possible) or manual unit testing.**

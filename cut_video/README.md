# Video Cutting Script

A Bash script that allows you to cut video files (MP4, MKV, AVI, MOV) either from a single file or an entire folder.  
The script uses `ffmpeg` to cut videos based on start and end times and supports optional renaming and saving to a new folder.

## Features

- Cut a single video file or all videos in a folder
- Specify start and end times for cutting (hh:mm:ss format)
- Option to rename output files
- Option to save cut videos to a new folder or the same folder
- Automatically detects Linux distribution and installs `ffmpeg` if missing
- Supports multiple Linux distributions: Ubuntu, Debian, Fedora, CentOS, Arch, Alpine, openSUSE, etc

### How to Run

1.Give execution permission (first time only):
chmod +x cut-videos.sh

2. ./cutV.sh

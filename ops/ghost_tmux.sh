#!/usr/bin/env bash
tmux new-session -d -s ghost "ghost"
tmux split-window -v "watch -n 5 ghost_status"
tmux split-window -h "tail -F var/logs/rituals.log"
tmux attach -t ghost

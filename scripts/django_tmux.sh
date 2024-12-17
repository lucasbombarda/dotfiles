#!/bin/env bash


if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi
cd $1 || exit 1

PROJECT_NAME=$(basename "$1")

tmux new-session -d -s $PROJECT_NAME

# Editor
tmux rename-window -t $PROJECT_NAME:1 'editor'
tmux send-keys -t $PROJECT_NAME:1 '. venv/bin/activate' C-m
tmux send-keys -t $PROJECT_NAME:1 'vim .' C-m

# Django server
tmux new-window -t $PROJECT_NAME:2 -n 'server'
tmux send-keys -t $PROJECT_NAME:2 '. venv/bin/activate' C-m
tmux send-keys -t $PROJECT_NAME:2 'python manage.py runserver' C-m

# Shell
tmux new-window -t $PROJECT_NAME:3 -n 'shell'
tmux send-keys -t $PROJECT_NAME:3 '. venv/bin/activate' C-m

tmux select-window -t $PROJECT_NAME:1
tmux attach -t $PROJECT_NAME


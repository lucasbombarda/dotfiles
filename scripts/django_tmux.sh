#!/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi
cd $1 || exit 1

SHELL_TYPE=$(basename $SHELL)
PROJECT_NAME=$(basename "$1")

tmux new-session -d -s $PROJECT_NAME

# Editor
tmux rename-window -t $PROJECT_NAME:1 'editor'
if [ $SHELL_TYPE = "fish" ]; then
    tmux send-keys -t $PROJECT_NAME:1 '. venv/bin/activate.fish' C-m
else
    tmux send-keys -t $PROJECT_NAME:1 '. venv/bin/activate' C-m
fi
tmux send-keys -t $PROJECT_NAME:1 'vim .' C-m

# Django server
tmux new-window -t $PROJECT_NAME:2 -n 'server'
if [ $SHELL_TYPE = "fish" ]; then
    tmux send-keys -t $PROJECT_NAME:2 '. venv/bin/activate.fish' C-m
else
    tmux send-keys -t $PROJECT_NAME:2 '. venv/bin/activate' C-m
fi
tmux send-keys -t $PROJECT_NAME:2 'python manage.py runserver' C-m

# Shell
tmux new-window -t $PROJECT_NAME:3 -n 'shell'
if [ $SHELL_TYPE = "fish" ]; then
    tmux send-keys -t $PROJECT_NAME:3 '. venv/bin/activate.fish' C-m
else
    tmux send-keys -t $PROJECT_NAME:3 '. venv/bin/activate' C-m
fi

tmux select-window -t $PROJECT_NAME:1
tmux attach -t $PROJECT_NAME


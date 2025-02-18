set -g fish_greeting
set -x BUN_INSTALL $HOME/.bun
set -x PATH $BUN_INSTALL/bin $PATH





# Zoxide
set -x PATH $HOME/.local/bin $PATH
zoxide init fish --cmd cd | source

# TheFuck
#eval (thefuck --alias)

# Nim
set -x PATH $HOME/.nimble/bin $PATH

# Go compiler
set -x PATH $PATH /usr/local/go/bin

# Android SDK
set -x ANDROID_HOME /usr/lib/android-sdk
set -x PATH $PATH $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools


function cam
    sudo modprobe v4l2loopback; and scrcpy --video-source=camera --no-audio --no-video-playback --v4l2-sink=/dev/video0 --camera-{id=0,ar=16:9,fps=30} -m1920
end

function camv
    sudo modprobe v4l2loopback; and scrcpy --video-source=camera --no-audio --v4l2-sink=/dev/video0 --camera-{id=0,ar=16:9,fps=30} -m1920
end

function clip
    xclip -selection clipboard $argv
end

function android-studio
    sudo /usr/local/android-studio/bin/studio.sh $argv
end

function update
    $HOME/scripts/update_all.sh $argv
end

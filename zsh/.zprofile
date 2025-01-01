if [ -d "/opt/homebrew" ]; then
   eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# to render Electron apps properly on Wayland (Asahi + Fedora + Gnome)
if [ -v WAYLAND_DISPLAY ]; then 
    export ELECTRON_OZONE_PLATFORM_HINT=auto
fi

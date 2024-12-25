#!/bin/bash

set -eu

echo "Installing flatpaks"
flatpak install -y --or-update \
    com.mattjakeman.ExtensionManager \
    com.github.tchx84.Flatseal \
    io.beekeeperstudio.Studio \
    io.missioncenter.MissionCenter \
    io.podman_desktop.PodmanDesktop

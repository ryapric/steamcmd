#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if [[ "${1}" == "init" ]]; then

  useradd -m steam

  apt-get update
  apt-get install -y \
    jq \
    software-properties-common \
    sudo

  # I can only seem to get these to work by piping it...?
  echo steam steam/license note '' | debconf-set-selections
  echo steam steam/question select "I AGREE" | debconf-set-selections

  dpkg --add-architecture i386
  add-apt-repository 'deb http://ftp.us.debian.org/debian buster main contrib non-free'

  apt-get update
  apt-get install -y \
    lib32gcc1 \
    libsdl2-2.0-0:i386  \
    steamcmd

  ln -fs /usr/games/steamcmd /usr/bin/steamcmd

  steamcmd +login anonymous +quit

elif [[ "${1}" == "run" ]]; then

  # cd /home/steam || exit 1

  app_name="${2}"
  app_id=$(jq -r --arg app_name "${app_name}" '.[] | select(.app_name == $app_name) | .app_id' apps.json)
  app_runcmd=$(jq -r --arg app_name "${app_name}" '.[] | select(.app_name == $app_name) | .app_runcmd' apps.json)
  printf "Will install server data for %s, using Steam App ID %s\n" "${app_name}" "${app_id}" > /dev/stderr
  steamcmd +login anonymous +force_install_dir ./"${app_name}" +app_update "${app_id}" +quit

else
  printf "ERROR: bad call to %s\n" "${0}" > /dev/stderr
  printf 'Usage: steamcmd.sh [init | run app_name]\n' > /dev/stderr
  exit 1
fi

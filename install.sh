#! /bin/bash

if [ ! -d "./out/" ]; then
  echo -e "\033[0;31mError:\033[0m \033[1m./out/\033[0m does not exist. Did you run \"\033[1;34mnpm build:linux\033[0m\"?"
  exit 1;
fi

echo -e -n "\033[0;34mCopying application data...\033[0m "
if cp -R out/electron-yt-tv-linux-x64/ $HOME/.local/share/ ; then
  echo -e "\033[0;32mDone\033[0m"
else
  echo -e "\033[0;31mFailed\033[0m"
fi

echo -e -n "\033[0;34mPreparing desktop entry...\033[0m "
if sed "s,~\/,$HOME\/," yt-electron.desktop > out/yt-electron.desktop ; then
  echo -e "\033[0;32mDone\033[0m"
else
  echo -e "\033[0;31mFailed\033[0m"
fi

echo -e -n "\033[0;34mCopying desktop entry...\033[0m "
if desktop-file-install ./out/yt-electron.desktop --dir=$HOME/.local/share/applications ; then
  echo -e "\033[0;32mDone\033[0m"
else
  echo -e "\033[0;31mFailed\033[0m"
fi

echo -e -n "\033[0;34mRefreshing desktop entry database...\033[0m "
if update-desktop-database ~/.local/share/applications ; then
  echo -e "\033[0;32mDone\033[0m"
else
  echo -e "\033[0;31mFailed\033[0m"
fi
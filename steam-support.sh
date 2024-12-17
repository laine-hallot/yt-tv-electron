
# normally running electron-yt-tv through steam fails since steam changes the library path
#
# this script is based on this workaround:
#  https://github.com/ValveSoftware/steam-runtime/issues/579#issuecomment-1489541881
# and will try to manually copy the missing libs into your electron-yt-tv installation


function errorNoX () {
  echo -e "\033[0;31mError\033[0m: \033[1m$1\033[0m does not exist"
}
function errorNoXInY () {
  echo -e "\033[0;31mError\033[0m: Can't find \033[1m$1\033[0m in \033[1m$2\033[0m"
}


INSTALLATION_DIR="${ELECTRON_YT_DIR:=$HOME/.local/share/electron-yt-tv-linux-x64}"
LIBS="${LIBS_DIRECTORY:=/usr/lib}"

if [ ! -d "$INSTALLATION_DIR" ] ; then
  errorNoXInY "electron-yt-tv-linux-x64/" "$HOME/.local/share/"
  echo "Did you install electron-yt?"
  exit 1;
fi

if [ ! -d "$LIBS" ] ; then
  errorNoX "$LIBS" 
  exit 1;
fi

function findLibFile() {
  echo -e -n "\t $1 "
  if [ -f "$LIBS/$1" ] ; then
    echo -e "\033[0;34m Found\033[0m"
    return 1
  else
    echo -e "\033[0;32m missing\033[0m \033[2m$LIBS/$1\033[0m"
    return 1
  fi
}

function copyLibFile() {
  echo -e -n "\t Copying: $1... "
  if cp "$LIBS/$1" "$INSTALLATION_DIR/$2" ; then
    echo -e "\033[0;32m Success\033[0m"
    return 0
  else
    echo -e "\033[0;31m missing\033[0m \033[2m$LIBS/$1\033[0m"
    return 1
  fi
}



BASE_LIB_CUPS=libcups.so.2
BASE_LIB_VAHI_CLIENT=libavahi-client.so.3.2.9
BASE_LIB_VAHI_COMMON=libavahi-common.so.3.5.4

FINAL_LIB_CUPS=libcups.so.2
FINAL_LIB_VAHI_CLIENT=libvahi-client.so.3
FINAL_LIB_VAHI_COMMON=libvahi-common.so.3

echo -e "\033[0;34mSearching for base libraries...\033[0m "
findLibFile "$BASE_LIB_CUPS"
FOUND_BASE_LIB_CUPS=$?
findLibFile "$BASE_LIB_VAHI_CLIENT"
FOUND_BASE_LIB_VAHI_CLIENT=$?
findLibFile "$BASE_LIB_VAHI_COMMON"
FOUND_BASE_LIB_VAHI_COMMON=$?

echo "meow $FOUND_BASE_LIB_CUP"
echo "meow $FOUND_BASE_LIB_VAHI_CLIENT"
echo "meow $FOUND_BASE_LIB_VAHI_COMMON"
if [ FOUND_BASE_LIB_CUPS == "1" ] ; then
  exit 1
fi
if [ FOUND_BASE_LIB_VAHI_CLIENT == "1" ] ; then
  exit 1
fi

if [ FOUND_BASE_LIB_VAHI_COMMON == "1" ] ; then
  exit 1
fi


echo -e "\033[0;34mCopying libraries to $INSTALLATION_DIR...\033[0m "
copyLibFile "$BASE_LIB_CUPS" "$FINAL_LIB_CUPS"
COPIED_LIB_CUPS=$?
copyLibFile "$BASE_LIB_VAHI_CLIENT" "$FINAL_LIB_VAHI_CLIENT"
COPIED_LIB_VAHI_CLIENT=$?
copyLibFile "$BASE_LIB_VAHI_COMMON" "$FINAL_LIB_VAHI_COMMON"
COPIED_LIB_VAHI_COMMON=$?

echo "meow $COPIED_LIB_CUPS"
echo "meow $COPIED_LIB_VAHI_CLIENT"
echo "meow $COPIED_LIB_VAHI_COMMON"
if [ COPIED_LIB_CUPS == "1" ] ; then
  exit 1
fi
if [ COPIED_LIB_VAHI_CLIENT == "1" ] ; then
  exit 1
fi
if [ COPIED_LIB_VAHI_COMMON == "1" ] ; then
  exit 1
fi
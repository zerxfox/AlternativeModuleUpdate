module_update() {
  CURRENT_VERSION="0.0.0" #your version of module [change it]
  UPDATE_URL="https://raw.githubusercontent.com/*****/*****/main/update.json" #your link to update.json [change it]
  ZIP_FILE="/data/local/tmp/*****.zip" # the name of your module's archive. [change it]
  : > "$ZIP_FILE"

  echo "Checking for updates"
  LATEST_VERSION=$(curl -s $UPDATE_URL | grep '"version":' | awk -F '"' '{print $4}')

  if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
      ZIP_URL=$(curl -s $UPDATE_URL | grep '"zipUrl":' | awk -F '"' '{print $4}')
      echo "Downloading new version from: \n$ZIP_URL"

      curl -L -o $ZIP_FILE $ZIP_URL

      if [ -f $ZIP_FILE ]; then
        echo "Installing new version"

        if [ -d "/data/adb/magisk" ]; then
          magisk --install-module $ZIP_FILE
        elif ksud --version >/dev/null 2>&1 && [ -d "/data/adb/ksu" ]; then
          ksud module install $ZIP_FILE
        elif apd --version >/dev/null 2>&1 && [ -d "/data/adb/ap" ]; then
          apd module install $ZIP_FILE
        else
          echo "Failed to determine the module manager"
          exit 1
        fi

        echo "Module updated to version: $LATEST_VERSION"
        
        echo -n "Do you want to reboot? (1: Yes, 2: No): "
        read -r shtdwn
        if [ "$shtdwn" -eq 1 ]; then
          reboot
        fi
      else
        echo "Failed to download update"
      fi
  else
    echo "No updates available"
  fi
}
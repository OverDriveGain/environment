echo $(. /etc/os-release && echo "$VERSION_CODENAME")"" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  echo "$(. /etc/os-release && [ $VERSION_CODENAME = 'wilma' ] && echo "Linux mint detected changing to noble" && echo 'noble' || echo "$VERSION_CODENAME")"

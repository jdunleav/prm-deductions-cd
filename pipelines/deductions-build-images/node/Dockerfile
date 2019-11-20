FROM debian:stretch-slim

RUN apt-get update && apt-get install -y wget curl jq unzip zip python3 gnupg make && \
  curl -O https://bootstrap.pypa.io/get-pip.py && \
  python3 get-pip.py && \
  pip3 install awscli && \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash && \
  export NVM_DIR="$HOME/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get install -y nodejs

#!/bin/bash


ARCH=$(uname -m)
case $ARCH in
  armv7*) ARCH="arm";;
  aarch64) ARCH="arm64";;
  x86_64) ARCH="amd64";;
esac

echo "Installing required dependencies"
if [ -f  "/etc/system-release" ] ; then
  if cat /etc/system-release | grep -i 'Amazon Linux' ; then
    sudo amazon-linux-extras install testing
    sudo apt install curl -y -qq

    curl -L https://litmus-http-proxy.s3.amazonaws.com/server/toxiproxy-server-linux-${ARCH}.tar.gz --output toxiproxy-server-linux-${ARCH}.tar.gz && \
    tar zxvf toxiproxy-server-linux-${ARCH}.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/toxiproxy-server && \
    rm toxiproxy-server-linux-${ARCH}.tar.gz

    curl -L https://litmus-http-proxy.s3.amazonaws.com/cli/toxiproxy-cli-linux-${ARCH}.tar.gz --output toxiproxy-cli-linux-${ARCH}.tar.gz && \
    tar zxvf toxiproxy-cli-linux-${ARCH}.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/toxiproxy-cli && \
    rm toxiproxy-cli-linux-${ARCH}.tar.gz

    if [[ ! "$( which iptables 2>/dev/null )" ]]
    then
        sudo apt-get install iproute2 -y -qq
    fi
  else
    echo "There was a problem installing dependencies."
    exit 1
  fi
elif cat /etc/issue | grep -i Ubuntu ; then
  sudo apt-get update -y
  sudo DEBIAN_FRONTEND=noninteractive sudo apt-get install curl -y

  curl -L https://litmus-http-proxy.s3.amazonaws.com/server/toxiproxy-server-linux-${ARCH}.tar.gz --output toxiproxy-server-linux-${ARCH}.tar.gz && \
  tar zxvf toxiproxy-server-linux-${ARCH}.tar.gz -C /usr/local/bin/ && \
  chmod +x /usr/local/bin/toxiproxy-server && \
  rm toxiproxy-server-linux-${ARCH}.tar.gz

  curl -L https://litmus-http-proxy.s3.amazonaws.com/cli/toxiproxy-cli-linux-${ARCH}.tar.gz --output toxiproxy-cli-linux-${ARCH}.tar.gz && \
  tar zxvf toxiproxy-cli-linux-${ARCH}.tar.gz -C /usr/local/bin/ && \
  chmod +x /usr/local/bin/toxiproxy-cli && \
  rm toxiproxy-cli-linux-${ARCH}.tar.gz

  if [[ ! "$( which iptables 2>/dev/null )" ]]
  then
      sudo apt-get install iproute2 -y -qq
  fi
else
  echo "There was a problem installing dependencies."
  exit 1
fi


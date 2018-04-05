#!/bin/sh

ini_files=$(find /etc/frp -name '*.ini')

for file in $ini_files; do
  while read line || [ -n "$line" ]; do
    eval echo "$line"
  done < "$file">"/etc/frp-in-docker/$(basename $file)"
done

frps_config=/etc/frp-in-docker/frps.ini
frpc_config=/etc/frp-in-docker/frpc.ini

case $FRP_MODE in
  frpc|frp-client)
    frpc -c $frpc_config
    exit 0
    ;;
  frps|frp-server)
    frps -c $frps_config
    exit 0
    ;;
  both)
    frpc -c $frpc_config
    frps -c $frps_config
    exit 0
    ;;
  *)
    echo "\$FRP_MODE not set, run as existed config file"
    if [ ! -f $frpc_config ] && [ ! -f $frps_config ]; then
      echo "Error: no config file"
      exit 1
    fi
    [ -f $frpc_config ] && frpc -c $frpc_config
    [ -f $frps_config ] && frps -c $frps_config
    exit 0
    ;;
esac

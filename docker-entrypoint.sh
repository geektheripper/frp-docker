#!/bin/sh

ini_files=$(find /etc/frp -name '*.ini')

for file in $ini_files; do
  while read line || [ -n "$line" ]; do
    eval echo "$line"
  done < "$file">"/tmp/$(basename $file)"
done

frps_config_source=/etc/frp/frps.ini
frpc_config_source=/etc/frp/frpc.ini

frps_config=/tmp/frps.ini
frpc_config=/tmp/frpc.ini

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
    if [ ! -f $frpc_config_source ] && [ ! -f $frps_config_source ]; then
      echo "Error: config file not found"
      exit 1
    fi
    echo "\$FRP_MODE not set, run as existed config file"
    [ -f $frpc_config_source ] && frpc -c $frpc_config
    [ -f $frps_config_source ] && frps -c $frps_config
    exit 0
    ;;
esac

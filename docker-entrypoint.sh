#!/bin/bash
gnunet-arm -s > $HOME/gnunet.log 2>&1
gnunet-config -s rest -o BIND_TO -V "0.0.0.0"
gnunet-config -s rest -o BIND_TO6 -V "::"
gnunet-arm -i reclaim
gnunet-arm -i rest

exec bash

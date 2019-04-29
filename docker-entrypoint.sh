#!/bin/bash
gnunet-arm -s > $HOME/gnunet.log 2>&1
#Listen on all interfaces in docker
gnunet-config -s rest -o BIND_TO -V "0.0.0.0"
gnunet-config -s rest -o BIND_TO6 -V "::"
#Restart
gnunet-arm -r
#Monitor loop
gnunet-arm -m

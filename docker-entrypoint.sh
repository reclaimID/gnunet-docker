#!/bin/bash
gnunet-arm -s > $HOME/gnunet.log 2>&1
gnunet-arm -i reclaim
exec bash

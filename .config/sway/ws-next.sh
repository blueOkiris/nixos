#!/bin/bash

CUR_WS=`i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2`
NEXT_WS=$(($CUR_WS+1))
i3-msg workspace $NEXT_WS


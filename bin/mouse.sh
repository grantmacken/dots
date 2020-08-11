#!/bin/sh
DEVICE_ID=$(xinput list |  grep "G300" | grep keyboard | sed 's/.*id=\([0-9]*\).*/\1/')
# echo $DEVICE_ID
if xinput -list-props $DEVICE_ID | grep "Device Enabled" | grep "1$" > /dev/null
then
        xinput set-int-prop $DEVICE_ID "Device Enabled" 8 0
fi

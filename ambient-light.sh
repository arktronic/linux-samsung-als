#!/bin/bash

# Minimum ALS value that you care about
# (Anything lower will get min backlight)
SENSOR_MIN=5

# Maximum ALS value that you care about
# (Anything higher will get max backlight)
SENSOR_MAX=300

# Location of the ALS value that is to be read
SENSOR=/sys/bus/iio/devices/iio\:device0/in_illuminance_raw

# Minimum backlight value
BACKLIGHT_MIN=200

# Maximum backlight value
BACKLIGHT_MAX=4648

# Backlight change amount
# (Change steps are calculated based on this and max-min)
BACKLIGHT_SET_DELTA=400

# Location of the backlight value that is to be written
BACKLIGHT=/sys/class/backlight/intel_backlight/brightness

# How long to sleep (in seconds) between ALS reads/backlight writes
PAUSE=2

# ---------------------

backlight_steps=$(echo "($BACKLIGHT_MAX-$BACKLIGHT_MIN)/$BACKLIGHT_SET_DELTA" | bc)
sensor_step_delta=$(echo "($SENSOR_MAX-$SENSOR_MIN)/$backlight_steps" | bc)

backlight_last=0

while [ 1 ]
do
    sensor=$(cat $SENSOR)
    step=$(echo "$sensor/$sensor_step_delta" | bc)

    backlight_value=$(echo "$step*$BACKLIGHT_SET_DELTA" | bc)
    if [ $step -gt $backlight_steps ]; then
        backlight_value=$BACKLIGHT_MAX
    fi

    if [ $step -lt 1 ]; then
        backlight_value=$BACKLIGHT_MIN
    fi

    if [ $backlight_value -ne $backlight_last ]; then
        echo $backlight_value > $BACKLIGHT
    fi

    backlight_last=$backlight_value
    sleep $PAUSE
done

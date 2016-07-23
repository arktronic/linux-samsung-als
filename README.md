What is this?
=============

The shell script in this repo controls Samsung laptops' backlight
automatically based on the current value of the ambient light sensor
built in to the laptop.


Who is this for?
================

This script is for people with Samsung Series 7/Chronos laptops
running Linux. It might work on other devices, or it might not. No
guarantees.


How do I use it?
================

Copy the script somewhere and then execute it on system bootup. One
way to do this is to add the following line to your
`/etc/rc.local`:

    /path/to/ambient-light.sh &

The ampersand is EXTREMELY important for letting your system finish
booting. Don't miss it!

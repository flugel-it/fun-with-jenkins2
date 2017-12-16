#!/bin/bash

echo TEST

SERVICE="docker"
RESULT=`ps -a | sed -n /${SERVICE}/p`

if [ "${RESULT:-null}" = null ]; then
    echo "Docker is not running"
else
    echo "Docker is running"
fi



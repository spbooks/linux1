#!/bin/sh

COUNTER=0
while true;
do
  echo $COUNTER
  let COUNTER++
  sleep 1;
done

#!/bin/sh

cd tools
echo 'Drop :dev database'
psql -U nevertire postgres -c 'drop database never_tire_dev

echo 'Create :dev database'
createdb -O nevertire never_tire_dev

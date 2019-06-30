#!/bin/sh

cd tools
echo 'Drop :development database'
psql -U nevertire postgres -c 'drop database never_tire_development'

echo 'Create :development database'
createdb -O nevertire never_tire_development

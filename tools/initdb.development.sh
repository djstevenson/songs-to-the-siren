#!/bin/sh

cd tools
echo 'Drop :development database'
psql -U nevertire postgres -c 'DROP DATABASE IF EXISTS never_tire_development'

echo 'Create :development database'
createdb -U postgres -O nevertire never_tire_development

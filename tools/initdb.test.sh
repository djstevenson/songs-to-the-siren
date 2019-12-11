#!/bin/sh

cd tools
echo 'Drop :test database'
psql -U nevertire postgres -c 'DROP DATABASE IF EXISTS never_tire_test'

echo 'Create :test database'
createdb -U postgres -O nevertire never_tire_test

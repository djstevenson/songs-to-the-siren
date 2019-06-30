#!/bin/sh

cd tools
echo 'Drop :test database'
psql -U nevertire postgres -c 'drop database never_tire_test'

echo 'Create :test database'
createdb -O nevertire never_tire_test

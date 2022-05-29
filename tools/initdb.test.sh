#!/bin/sh

cd tools
echo 'Drop :test database'
psql -U songstothesiren postgres -c 'DROP DATABASE IF EXISTS songstothesiren_test'

echo 'Create :test database'
createdb -U songstothesiren -O songstothesiren songstothesiren_test

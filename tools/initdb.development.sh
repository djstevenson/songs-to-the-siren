#!/bin/sh

cd tools
echo 'Drop :development database'
psql -U songstothesiren postgres -c 'DROP DATABASE IF EXISTS songstothesiren_development'

echo 'Create :development database'
createdb -U postgres -O songstothesiren songstothesiren_development

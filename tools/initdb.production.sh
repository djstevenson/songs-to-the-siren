#!/bin/sh

cd tools
echo 'Drop :production database'
psql -U songstothesiren postgres -c 'DROP DATABASE IF EXISTS songstothesiren_production'

echo 'Create :production database'
createdb -U postgres -O songstothesiren songstothesiren_production

# Songs I'll Never Tire Of blog

## INIT test DB

`sh tools/inittestdb`

## Run app

`carton exec -- morbo script/never-tire`

# Show routes

`carton exec -- script/never-tire routes`

# Rebuild deps

`rm -rf local vendor cpanfile.snapshot ; carton install ; carton bundle`



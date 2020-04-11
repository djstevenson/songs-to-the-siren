# ARTWORKS

I'm not including artwork in the repo cos it's obviously subject to copyright.

What I would have here are @1 thru @4 resolution images for each song. These would be named, for example:

 * song-to-the-siren-1x.jpg (res 160x160)
 * song-to-the-siren-2x.jpg (res 320x320)
 * song-to-the-siren-3x.jpg (res 480x480)
 * song-to-the-siren-4x.jpg (res 640x640)

I usually generate these from a square larger image, using ImageMagick:

```
$ for i in 1 2 3 4 ; do magick source.jpg -resize `dc -e "160 $i * p"` jubilee-twist-${i}x.jpg ; done
```

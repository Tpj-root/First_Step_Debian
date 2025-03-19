#! /usr/bin/env /usr/bin/python3
import mapnik
map = mapnik.Map(210,297) # create a 600x300 pixel map
mapnik.load_map(map, 'points.xml') # loat style file
map.zoom_all() # make sure all data is visible
map.zoom(-1.1) # zoom out a bit more to avoid clipping
mapnik.render_to_file(map, 'point.png', 'png') # render



# Zappa is an amazing CoffeeScript centered wrapper around express/connect.
# It uses the connect middleware to serve the static files. By default
# it points to _public_.

zappa = require('zappa') -> @use 'static'

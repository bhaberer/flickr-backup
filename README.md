Flickr Photo Downloader
=======================

Ruby script to download all your photos from your flickr account, placing them
in corresponding Collection and Set folders.

The bones of this are from mrtuxhdb/flickr-photo-downloader, but I've
basically rewritten it for my purposes at this point.

Usage
-----

Checkout the code and install libs:

    git clone git://github.com/bhaberer/flickr-backup.git
    cd flickr-backup
    bundle install

Copy the config.yml.example to config.yml and edit it to real values.
Follow this link to get an [API key and shared secret](https://secure.flickr.com/services/apps/create/apply)

Once you have that, you should be able to run flick_auth.rb to retrieve your
token and secret.

Once your config.yml is setup, run the script passing the URL to your photostream:

    ruby backup.rb download_profile

Note: This only downloads your photos (i.e. you can't currently use it to dump
another user's stuff), but it should get all of them, in a hierarchy.

License
-------

Source code released under an [MIT license](http://en.wikipedia.org/wiki/MIT_License)

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

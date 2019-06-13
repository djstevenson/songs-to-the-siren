The code behing the "Songs I'll Never Tire Of" blog
---------------------------------------------------

INIT test DB
============

Creates a test database `never_tire_test` - deleting any existing content.

`sh tools/inittestdb`

This drops the DB and re-creates it empty. The schema will be created when the app starts up.

Installation
============

TODO Insert instructions on using plenv/carton/etc to install deps.

Run app
=======

`carton exec -- morbo script/never-tire`

Optional overrides via the environment:

 * `TEST_BCRYPT_COST=4` (say): Cheaper Bcrypts for faster tests. Don't set it this low in production. Default is 13.


To list routes
==============

`carton exec -- script/never-tire routes`

Rebuild deps
============

`rm -rf local vendor cpanfile.snapshot ; carton install ; carton bundle`

TESTS
=====

### Unit tests for Perl code

TODO Add details on this

### Selenium-based functional tests

TODO Add details on this


FAQ
===

### Why do we need another blog engine / CMS?

We don't. It's just a demo app so I can show some code if/when looking for a new job. Which I'm not, at the moment. But you never know what's ahead.

### Isn't the blog title gramatically incorrect?

Arguably yes. But it's not a great name already and changing it to "Songs Of Which I'll Never Tire" doesn't exactly improve it!

Licence
=======

Coming soon, likely to be something fairly permissive.

Author
======

David Stevenson david@ytfc.com

The code behing the "Songs To The Siren" blog
---------------------------------------------

INIT test DB
============

Create a dev database `songstothesiren_development` - deleting any existing content.

`sh tools/initdb.development.sh`

This drops the DB and re-creates it empty. The schema will be created when the app starts up.

Installation
============

TODO Insert instructions on using plenv/carton/etc to install deps.

Run app
=======

`carton exec -- morbo script/songs-to-the-siren`

Optional overrides via the environment:

 * `TEST_BCRYPT_COST=4` (say): Cheaper Bcrypts for faster tests. Don't set it this low in production. Default is 13.

SCSS
====

CSS stylesheets are written in SCSS. To covert to CSS, install the scss ruby gem and run (from the project's root dir):

```
scss --watch assets/songs-to-the-siren.scss:public/songs-to-the-siren.css
```

Full dev
========

The full comment for starting up a dev server with a new DB, that has a small amount of test data created already, is:

```
export MOJO_MODE=development ; \
export MOJO_LOG_LEVEL=debug ; \
export TEST_BCRYPT_COST=4 ; \
sh tools/initdb.$MOJO_MODE.sh ; \
carton exec -- script/songs-to-the-siren newadmin --name=admin --password=xyzzy --email=admin@ytfc.com; \
psql -Usongstothesiren songstothesiren_$MOJO_MODE < tools/$MOJO_MODE\_data.sql ; \
DBIC_TRACE=0 carton exec -- morbo script/songs-to-the-siren
```

Note, for 'test' and 'development' modes, this creates an admin user with the name 'admin' and password 'xyzzy'.

Test Server
===========

Start up a test server with the same, but changing the mode, ie:

```
export MOJO_MODE=test ; \
export MOJO_LOG_LEVEL=debug ; \
export TEST_BCRYPT_COST=4 ; \
sh tools/initdb.$MOJO_MODE.sh ; \
carton exec -- script/songs-to-the-siren newadmin --name=admin --password=xyzzy --email=admin@ytfc.com; \
psql -Usongstothesiren songstothesiren_$MOJO_MODE < tools/$MOJO_MODE\_data.sql ; \
DBIC_TRACE=0 carton exec -- morbo script/songs-to-the-siren
```

To list routes
==============

`carton exec -- script/songs-to-the-siren routes`

Rebuild deps
============

`rm -rf local vendor cpanfile.snapshot ; carton install ; carton bundle`

TESTS
=====

### Unit tests for Perl code

To run the Perl unit test suite:

`carton exec -- forkprove -MMoose -MDBIx::Class -I. -j8 -lr t`

(-j8 is the level of parallelism, you can change this depending on core count of your CPU)

### Cypress.io functional tests

`npm i` to install

`npx cypress open` to open the test UI, ready for testing in Electron or Chrome

`npx cypress run` to run headless.


FAQ
===

### Why do we need another blog engine / CMS?

We don't. It's just a demo app so I can show some code if/when looking for a new job. Which I'm not, at the moment. But you never know what's ahead.

Licence
=======

MIT License (sic), see the LICENSE file.

Author
======

David Stevenson david@ytfc.com

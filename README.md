The code behing the "Songs I Will Never Tire Of" blog
-----------------------------------------------------

INIT test DB
============

Creates a dev database `never_tire_development` - deleting any existing content.

`sh tools/initdb.development.sh`

This drops the DB and re-creates it empty. The schema will be created when the app starts up.

Installation
============

TODO Insert instructions on using plenv/carton/etc to install deps.

Run app
=======

`carton exec -- morbo script/never-tire`

Optional overrides via the environment:

 * `TEST_BCRYPT_COST=4` (say): Cheaper Bcrypts for faster tests. Don't set it this low in production. Default is 13.


Full dev
========

The full comment for starting up a dev server with a new DB, that has a small amount of test data created already, is:

```
export MOJO_MODE=development ; \
export MOJO_LOG_LEVEL=debug ; \
export TEST_BCRYPT_COST=4 ; \
sh tools/initdb.$MOJO_MODE.sh ; \
carton exec -- script/never-tire newadmin --name=admin --password=xyzzy --email=admin@ytfc.com; \
psql never_tire_$MOJO_MODE < tools/$MOJO_MODE\_data.sql ; \
carton exec -- morbo script/never-tire
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
carton exec -- script/never-tire newadmin --name=admin --password=xyzzy --email=admin@ytfc.com; \
psql never_tire_$MOJO_MODE < tools/$MOJO_MODE\_data.sql ; \
 carton exec -- morbo script/never-tire
```

To list routes
==============

`carton exec -- script/never-tire routes`

Rebuild CPAN (Perl) deps
========================

`rm -rf local vendor cpanfile.snapshot ; carton install ; carton bundle`

Rebuild Node deps for functional tests
======================================

`nvm use; rm -rf node_modules; npm install`

Run functional tests
====================

#### Run with Electron-based UI

`npx cypress open`

#### Run headless

`npx cypress run`


Perl unit tests
===============

To run the Perl unit test suite:

`carton exec -- forkprove -MMoose -MDBIx::Class -I. -j8 -lr t`

(-j8 is the level of parallelism, you can change this depending on core count of your CPU)


FAQ
===

### Why do we need another blog engine / CMS?

We don't. It's just a demo app so I can show some code if/when looking for a new job. Which I'm not, at the moment. But you never know what's ahead.

### Isn't the blog title gramatically incorrect?

Probably yes. But it's not a great name already and changing it to "Songs Of Which I Will Never Tire" doesn't seem to improve it a lot.

License
=======

MIT License.  See the file "LICENSE" in the root directory.

Author
======

David Stevenson david@ytfc.com

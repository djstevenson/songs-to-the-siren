## Running in parallel with forkprove

`carton exec -- forkprove -MMoose -MDBIx::Class -I. -j8 -lr t`

## Running in series

`for i in $(find t -type f -name \*.t) ; do TEST_BCRYPT_COST=4 carton exec -- $i ; done`

## Running individual test class

`carton exec -- t/blah.t`


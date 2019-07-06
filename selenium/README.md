# Running Selenium Functional Tests

Open two terminal windows.

## First window

From the app root directory, run:

```
export MOJO_MODE=test; \
sh tools/initdb.$MOJO_MODE.sh; \
psql never_tire_$MOJO_MODE < tools/$MOJO_MODE\_data.sql; \
DBIC_TRACE=0 TEST_BCRYPT_COST=4 carton exec -- morbo script/never-tire
```

## Second window

From the 'selenium' directory, run:

```
./gradlew clean test
```

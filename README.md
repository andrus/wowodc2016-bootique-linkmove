A simple Bootique/LinkMove app created live at WOWODC 2016.

TODO: link to the presentation video once that becomes available.

## Prerequisites 

I used Docker on OSX with Kitematic to create source and target DB (but you don't have to).

### Source DB - PostgreSQL

```
docker run --name lmsrc-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

If this finishes successfully, PostgreSQL should be available at 192.168.99.100:5432 and you can execute 
```sql/source.sql``` to generate source DB schema and load some data.

### Target DB - MySQL

```
docker run --name lmtarget-mysql -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -d mysql:5.7
```

If this finishes successfully, MySQL should be available at 192.168.99.100:3306, and you can execute 
```sql/target.sql``` to generate target DB schema:

```
cat sql/target.sql | mysql -p -u root -h 192.168.99.100
```

## The App

``` 
mvn clean package
java -jar target/lm-demo-0.0.1-SNAPSHOT.jar 
java -jar target/lm-demo-0.0.1-SNAPSHOT.jar  --exec --job=sync --config=test.yml
```



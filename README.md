### About

This is a modified fork of https://github.com/sburn/docker-apache-atlas

With an attempt to build from Atlas master with custom modifications

## Prerequisites

Build the Atlas Server distributable

```
mvn clean install -U -Dmaven.wagon.http.ssl.ignore.validity.dates=true -DskipTests=true && mvn clean package -Pdist -Dmaven.wagon.http.ssl.ignore.validity.dates=true
```

Place it in this directory as apache-atlas-3.0.0-SNAPSHOT-server.tar.gz

If you have changed the tarball name or built from a different version make sure you replace the filenames everywhere

The atlas config and start.py are created when apache atlas starts, the files here contain changes. If you change the version or commit
you will need to build them again by taking the relevant files from the server filepath
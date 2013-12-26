Heroku Buildpack: LibreOffice
=============================

Heroku buildpack for LibreOffice that can be used by [unoconv](https://github.com/dagwieers/unoconv), [docsplit](http://documentcloud.github.io/docsplit), etc.

Usage
------

LibreOffice depends on Java, so the Java buildpack is needed. Hence, we have to create a [multipack](https://github.com/ddollar/heroku-buildpack-multi) app.

    heroku create --buildpack https://github.com/ddollar/heroku-buildpack-multi.git
    
Next, add the Java buildpack, and this one to `.buildpacks`:

    echo "https://github.com/heroku/heroku-buildpack-java.git
    https://github.com/rishihahs/heroku-buildpack-libreoffice.git" > .buildpacks
    
Heroku's Java buildpack requires a `pom.xml`, so if you don't have one, create a dummy:

    echo '<project><modelVersion>4.0.0</modelVersion><groupId>com.dummy</groupId><artifactId>dummy</artifactId><version>1.0-SNAPSHOT</version><packaging>pom</packaging></project>' > pom.xml
    
Finally:
    
    git push heroku master
    
Build
-----

Binaries used in the buildpack are prebuilt and hosted on SourceForge for convenience, but you can build them yourself like so:

    heroku create --buildpack https://github.com/heroku/heroku-buildpack-java.git
    
Make sure you create a dummy `pom.xml` (as shown above in Usage), and after pushing:

    heroku run bash
    ./build/libreoffice.sh
    
The binaries will be in `$temp_dir/release`.

Licence
--------

Licenced under the MIT Licence. See `LICENCE` file.

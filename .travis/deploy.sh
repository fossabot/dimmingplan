#!/bin/bash
cd `dirname $0`/.. 
echo $PWD

if [ -z "$SONATYPE_USERNAME" ]
then
    echo "Please set SONATYPE_USERNAME and SONATYPE_PASSWORD environment variable"
    exit 1
else
    echo "SONATYPE_USERNAME okay"
fi

if [ -z "$SONATYPE_PASSWORD" ]
then
    echo "Please set SONATYPE_PASSWORD environment variable"
    exit 1
else
    echo "SONATYPE_PASSWORD okay"    
fi

if [ ! -z "$TRAVIS_TAG" ]
then
    echo "on a tag -> set pom.xml <version> to $TRAVIS_TAG"
    mvn --settings .travis/settings.xml org.codehaus.mojo:versions-maven-plugin:2.1:set -DnewVersion=$TRAVIS_TAG 1>/dev/null 2>/dev/null
else
    echo "not on a tag -> keep snapshot version in pom.xml"
fi

mvn clean deploy --settings .travis/settings.xml -DskipTests=true -P attachJdocSources,deployToOssrh -B -U

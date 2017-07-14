#!/bin/bash
echo "Publishing..."

EXIT_STATUS=0

if [[ $TRAVIS_REPO_SLUG == "grails/gorm-graphql" && $TRAVIS_PULL_REQUEST == 'false' && $EXIT_STATUS -eq 0 ]]; then

  echo "Publishing archives"
  export GRADLE_OPTS="-Xmx1500m -Dfile.encoding=UTF-8"
  if [[ $TRAVIS_TAG =~ ^v[[:digit:]] ]]; then

    if [[ $EXIT_STATUS -eq 0 ]]; then
        ./gradlew publish --no-daemon || EXIT_STATUS=$?
    fi

    if [[ $EXIT_STATUS -eq 0 ]]; then
        ./gradlew bintrayUpload --no-daemon || EXIT_STATUS=$?
    fi
  else
    # for snapshots only to repo.grails.org
    ./gradlew  publish || EXIT_STATUS=$?
  fi
  if [[ $EXIT_STATUS -eq 0 ]]; then
    echo "Publishing Successful."
  fi


  if [[ $EXIT_STATUS -eq 0 ]]; then
    echo "Publishing Successful."

    echo "Publishing Documentation..."
    ./gradlew docs:docs

    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global credential.helper "store --file=~/.git-credentials"
    echo "https://$GH_TOKEN:@github.com" > ~/.git-credentials


    git clone https://${GH_TOKEN}@github.com/grails/grails-data-mapping.git -b gh-pages gh-pages --single-branch > /dev/null
    cd gh-pages

    if [[ -n $TRAVIS_TAG ]]; then
        version="$TRAVIS_TAG"
        version=${version:1}

        majorVersion=${version:0:4}
        majorVersion="${majorVersion}x"

        mkdir -p "$version/graphql"
        cp -r ../docs/build/docs/. "./$version/graphql/"
        git add "$version/graphql/*"

        mkdir -p "$majorVersion/graphql"
        cp -r ../docs/build/docs/. "./$majorVersion/graphql/"
        git add "$majorVersion/graphql/*"

    else
        # If this is the master branch then update the snapshot
        mkdir -p snapshot/graphql
        cp -r ../docs/build/docs/. ./snapshot/graphql/

        git add snapshot/graphql/*
    fi


    git commit -a -m "Updating GraphQL Docs for Travis build: https://travis-ci.org/$TRAVIS_REPO_SLUG/builds/$TRAVIS_BUILD_ID"
    git push origin HEAD
    cd ../../..
    rm -rf gh-pages
  fi  
fi

exit $EXIT_STATUS
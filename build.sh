#!/bin/bash

export JEKYLL_ENV=production
bundle exec jekyll build
rm -rf ../gk7huki.github.io/*
cp -r _site/* ../gk7huki.github.io

cd ../gk7huki.github.io
git add .
git commit -am 'latest build'
git push -u origin master

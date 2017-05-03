---
layout: post
title: Archives and GitHub Pages
date: 2017-05-03 18:45:44 +0530
categories: general
tags: [jekyll, gh-pages]
---

Previously, I posted about adding tags and categories support to your Jekyll site with the help of the `jekyll-archives` plugin. If you're planning to host your Jekyll site directly from GitHub Pages, there is just one caveat. 

GitHub Pages enables a minimal list of [whitelisted plugins](https://pages.github.com/versions/) when building your site with Jekyll. As of writing this post, `jekyll-archives` isn't one of them. Adding `jekyll-archives` to the whitelist has been a long running request, and if you're interested, you should follow [Pull Request #106](https://github.com/github/pages-gem/pull/106).

If you're like me and you prefer not to have your Jekyll plugin choices restricted, then your best bet is to build the site locally and upload the generated site (i.e., the `_site` folder) to your GitHub repo. Fortunately, the process can be effortlessly automated... *what cannot?* ;)

Firstly, create a new `user.github.io` folder right beside your Jekyll site folder. Initialize an empty git repository inside `user.github.io` and have it point to your remote GitHub repository. Back in your Jekyll site folder, you should add a `build.sh` script that's going to automate your build process. You might want to edit `_config.yml` to exclude this file from the build process.
~~~yaml
exclude:
  - Gemfile
  - Gemfile.lock
  - build.sh
~~~

The `build.sh` script performs several activities:
1. Build the Jekyll site locally in `production` environment.
1. Clear out existing files from `user.github.io`.
1. Copy the freshly generated files from `_site`.
1. Commit and push the changes to your remote repo.

~~~bash
#!/bin/bash

export JEKYLL_ENV=production
bundle exec jekyll build
rm -rf ../gk7huki.github.io/*
cp -r _site/* ../gk7huki.github.io

cd ../gk7huki.github.io
git add .
git commit -am 'latest build'
git push -u origin master
~~~

Note that the `rm` command does not touch hidden folders like `.git`, so your repository is safe.

Now, running `./build.sh` on your Jekyll site ensures that your site is generated locally with the latest changes and synced with your remote `user.github.io` repo, and the whole process is automated. You should see changes to your site reflected online within seconds of running the build script. :)

*The procedure is inspired from [charlieparker.org - Jekyll with Plugins](http://charliepark.org/jekyll-with-plugins/).*

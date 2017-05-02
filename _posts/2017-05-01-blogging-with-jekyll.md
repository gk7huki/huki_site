---
layout: post
title:  "Blogging with Jekyll"
date:   2017-05-01 19:57:40 +0530
categories: general
tags: [announcement, jekyll]
comments: true
---

*Welcome to my [Jekyll] powered blog.* Jekyll initially came up in an internal discussion with [jigebren] when we considered re-working our Re-Volt [project page](http://rv12.revoltzone.net/). We were looking for a simple and efficient way to manage our content, preferably in a text-based syntax like `Markdown`, without having to compromise on our unique layout and design choices. With both of us getting busy with our personal lives, that idea never came to fruition. We were also heavy Windows users with little idea about `Ruby`, so there's that. Today, with Linux having taken over as my primary system, I decided to go ahead and give this a try.

Getting a blog up and running with Jekyll took surprisingly little time. Of course, if you're a Windows user, *your mileage may vary*.
~~~bash
$ gem install jekyll bundler
$ jekyll new test-site
$ cd test-site
$ bundle exec jekyll serve
~~~
That's it. I can already start saving my blog posts in the `_posts` folder. A newly generated site uses the `jekyll-minima` theme by default. I want my webpage to be *responsive*, gracefully reflowing across desktop, tablet and mobile screens. The `minima` theme was quite satisfactory in this regard.

A typical Jekyll website is made up of a `YAML` front-matter, `Liquid` powered HTML layouts and `SCSS` stylesheets. Jekyll churns them together with your content written in `Markdown`, `Liquid` or even HTML. Functionality is further extended with plugins. With the Minima theme, `jekyll-feed` was enabled by default.

On the surface, there is some native support for *categories* and *tags*, but it's still up to the user to collect together and display posts belonging to each category. This requires two parts: a plugin that generates each category page, and layout files that decide the actual content displayed on those pages.

The simplest option is to use `jekyll-archives`. In my case, I have it set up to follow the same permalink structure as the posts themselves.
~~~yaml
jekyll-archives:
  enabled:
    - categories
    - tags
  layouts:
    category: category
    tag: tag
  permalinks:
    tag: '/tag/:name/'
    category: '/:name/'
~~~
With this, a post belonging to the `general` category may be found at `http://site/general/2017/05/01/blogging-with-jekyll.html`, and a page displaying all posts belonging to the `general` category can be found at `http://site/general/`. *Note that this only works neatly as long as your posts all have a single category!*

The layout files are placed in `_layouts/category.html` and `_layouts/tag.html`. Jekyll uses these layouts to generate a unique page for each category or tag. It's actually pretty straightforward.
~~~html{% raw %}
<h1 class="page-heading">Posts archived in “{{ page.title }}”</h1>

<ul class="post-list">
  {% for post in page.posts %}
    <li>...</li>
  {% endfor %}
</ul>
{% endraw %}~~~

The final touch is adding the current post's tags below the post title. Minima doesn't display them by default, so I had to override the `post.html` layout to add the following bit.
~~~html{% raw %}
{% for tag in page.tags %}
  {% if tag == page.tags[0] %} • {% endif %}
  <span itemprop="tag"><a href="/tag/{{ tag }}">{{ tag }}</a></span>
{% endfor %}
{% endraw %}~~~

My only other modification to the Minima theme is to have the list of posts displayed in *two columns* on large screens and switch to a single column layout on palm devices. This was achieved by overriding the default CSS sheet with a custom `assets/main.scss`.
~~~scss
---
---

@import "minima";

/**
 * Page content
 */
.post-list {
  display: flex;
  flex-flow: row wrap;

  > li {
    flex: 0 0 50%;
  }
}

@include media-query($on-palm) {
  .post-list {
    flex-flow: column wrap;
  }
}
~~~

To start writing blog posts, I simply create a new markdown file prefixed with the current date in the `_posts` folder, with the appropriate YAML front-matter. This is easily automated with a shell script that I run from within the `_posts` folder.
~~~bash
#!/bin/bash

echo -n "Title: "
read title
if [ ! "$title" ]; then
  exit 2
fi

name=${title,,}
name=${name// /-}
name=${name//[^[:alnum:]-]/}

file="$(date +'%Y-%m-%d')-$name.md"
date=$(date +"%Y-%m-%d %H:%M:%S %z")

echo "---" > "$file"
echo "layout: post" >> "$file"
echo "title: $title" >> "$file"
echo "date: $date" >> "$file"
echo "categories: draft" >> "$file"
echo "tags: " >> "$file"
echo "---" >> "$file"
~~~

As I spent several days setting up and tweaking my site, I came across several helpful and excellently designed Jekyll-powered blogs which really help demonstrate the customizing capability of this tool. If you're looking for a starting point or some inspiration for your Jekyll page, these sites might help you, as they did for me. :)

- [charilepark.org - Tags in Jekyll](http://charliepark.org/tags-in-jekyll/)
- [codinfox.github.io - Using Tags and Categories](http://codinfox.github.io/dev/2015/03/06/use-tags-and-categories-in-your-jekyll-based-github-pages/)
- [perfectlyrandom.org - Adding Disqus to Jekyll](http://www.perfectlyrandom.org/2014/06/29/adding-disqus-to-your-jekyll-powered-github-pages/)
- [olivermak.es - Considering Jekyll](https://olivermak.es/2016/03/consider-jekyll/)

[Jekyll]: https://jekyllrb.com/
[jigebren]: http://jigebren.free.fr/

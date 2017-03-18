#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'my name'
SITENAME = 'title of my blog'
SITEURL = '/' # e.g., https://mydomain.com
SITEDESCRIPTION = 'a brief description'

GA_ACCOUNT = 'UA-12312312-1'
TWITTER_ACCOUNT = 'twitteracct'

PATH = 'content' # path to content
STATIC_PATHS = ['images', 'favicon.ico', 'CNAME'] # statics to pass thru

# for sitemap.xml, robots.txt, humans.txt:
DIRECT_TEMPLATES = ('index', 'categories', 'authors', 'archives', 'sitemap', 'robots', 'humans')
ROBOTS_SAVE_AS = 'robots.txt'
HUMANS_SAVE_AS = 'humans.txt'
SITEMAP_SAVE_AS = 'sitemap.xml'

THEME = '../pelicanyan' # https://github.com/thomaswilley/pelicanyan

TIMEZONE = 'US/Eastern'

DEFAULT_LANG = 'en'

DATE_FORMATS = {
        'en': '%B %d, %Y',
        }

TYPOGRIFY = True

# Feed options
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Links appearing at the bottom of the left nav (blogroll)
LINKS = (('Github', 'https://github.com/your-github-acct'),)

DEFAULT_PAGINATION = 10

# URI prefs
ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}'
ARTICLE_SAVE_AS = '{0}/index.html'.format(ARTICLE_URL)

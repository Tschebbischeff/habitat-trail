from jinja2.ext import Extension
import urllib.parse


class UrlQuoteExtension(Extension):
    def __init__(self, environment):
        super(UrlQuoteExtension, self).__init__(environment)
        environment.filters['urlquote'] = lambda s: urllib.parse.quote(s, safe='')

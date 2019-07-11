#! /usr/bin/python3.6
i
import logging
import sys
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, '/home/username/FlaskApp/')
from my_flask_app import app as application
application.secret_key = 'anything'

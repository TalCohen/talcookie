import os

# Flask config
DEBUG = False
HOST_NAME = os.environ.get('TALCOOKIE_HOST_NAME', 'talcookie.app.csh.rit.edu')
APP_NAME = os.environ.get('TALCOOKIE_APP_NAME', 'talcookie')
IP = os.environ.get('TALCOOKIE_SERVER_IP', '0.0.0.0')
PORT = int(os.environ.get('TALCOOKIE_SERVER_PORT', '8080'))

# Database config
SQLALCHEMY_DATABASE_URI = os.environ.get('TALCOOKIE_DB_URI', '')

# Firebase config
SERVER_KEY = os.environ.get('TALCOOKIE_SERVER_KEY', '')

# APNS config
APNS_CERT_PEM = os.environ.get('TALCOOKIE_APNS_CERT_PEM', '/run/talcookie/apns-certs/cert.pem')
APNS_KEY_PEM = os.environ.get('TALCOOKIE_APNS_KEY_PEM', '/run/talcookie/apns-certs/key.pem')

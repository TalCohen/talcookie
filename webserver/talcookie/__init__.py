import os

from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

from talcookie.utils.push import create_apns

app = Flask(__name__)

if os.path.exists(os.path.join(os.getcwd(), "config.py")):
    app.config.from_pyfile(os.path.join(os.getcwd(), "config.py"))
else:
    app.config.from_pyfile(os.path.join(os.getcwd(), "config.env.py"))

app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

create_apns()

db = SQLAlchemy(app)
migrate = Migrate(app, db)

from talcookie.blueprints.register import register_bp
from talcookie.blueprints.message import message_bp

app.register_blueprint(register_bp)
app.register_blueprint(message_bp)

@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

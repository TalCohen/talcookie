from flask import Blueprint, request, render_template, json

from talcookie.models.models import User
from talcookie.util.utils import handle_response
from talcookie import db

register_bp = Blueprint('register_bp', __name__)

@register_bp.route('/register/client', methods=['POST'])
def register_client():
    client_id = request.form.get('client_id')

    # Check if it's valid
    if not client_id:
        return handle_response(False, "Invalid client ID.")

    # Create the user
    user = User(client_id)
    db.session.add(user)
    db.session.commit()
    
    return handle_response(True, "Successfully registered client.")

@register_bp.route('/register/device', methods=['POST'])
def register_device():
    client_id = request.form.get('client_id')
    device_token = request.form.get('device_token')
    ios = request.form.get('ios')

    # Check if it's valid
    if not client_id:
        return handle_response(False, "Invalid client ID.")
    if not device_token:
        return handle_response(False, "Invalid device token.")
    if ios is None:
        return handle_response(False, "Invalid device type.")

    # Check to see if they are upadting their client ID
    user = User.query.filter_by(device_token=device_token).first()
    if user:
        # Update the old record
        user_old = User.query.filter_by(client_id=user.client_id).first()
        user_old.device_token = None

        # Update the new record
        user.client_id = client_id
    else:
        # Otherwise pair the device
        # Get the user
        user = User.query.filter_by(client_id=client_id).first()

        # Check to see if it exists
        if user is None:
            return handle_response(False, "Client ID does not exist.")

        # Update the user
        user.device_token = device_token
        user.ios = ios

    db.session.commit()

    return handle_response(True, "Successfully paired device.")

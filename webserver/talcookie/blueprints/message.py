import requests
#from apns import APNS, Payload

from flask import Blueprint, request, render_template, json

from talcookie.models.models import User
from talcookie.util.push import generate_payload, send_ios_push
from talcookie.util.utils import handle_response
from talcookie import app, db

message_bp = Blueprint('message_bp', __name__)

@message_bp.route('/notify', methods=['POST'])
def notify():
    client_id = request.form.get('client_id')
    is_wrath = request.form.get('is_wrath')
    print(request.form)

    # Check if it's valid
    if not client_id:
        return handle_response(False, "Invalid client ID.")

    # Get the user
    user = User.query.filter_by(client_id=client_id).first()

    # Check to see if it exists
    if user is None:
        return handle_response(False, "Client ID does not exist.")
    
    # Check to see if they paired a device
    device_token = user.device_token
    if not device_token:
        return handle_response(False, "No paired device found.")

    # Build the message
    cookie_type = "Wrath Cookie" if is_wrath == 'true' else "Golden Cookie"
    message = "A %s has spawned!" % cookie_type

    # Create the payload
    payload = generate_payload(cookie_type, message, "GOLDEN_COOKIE")

    # Send the notification
    if user.ios:
        send_ios_push(device_token, payload)
    else:
        # TODO: Send android push
        pass

    return handle_response(True, "Successfully notified the user.")

@message_bp.route('/click', methods=['POST'])
def click():
    device_token = request.form.get('device_token')

    # Check if it's valid
    if not device_token:
        return handle_response(False, "Invalid device token.")

    # Get the user
    user = User.query.filter_by(device_token=device_token).first()

    # Check to see if it exists
    if user is None:
        return handle_response(False, "Device token does not exist.") 

    # Send the message to firebase which will send it to the chrome extension
    url = "https://fcm.googleapis.com/fcm/send"
    headers = {'Authorization': "key=%s" % app.config['SERVER_KEY'], 'Content-Type': 'application/json'}
    r = requests.post(url, json={"to": user.client_id}, headers=headers) 

    # Check if it was successful
    if r.status_code == 200:
        return handle_response(True, "Successfully sent a click.")
    else:
        return handle_response(False, "Unable to send a click.")

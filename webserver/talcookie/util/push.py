from apns3 import APNs, Payload

from talcookie import app

def create_apns():
    # Create apns object
    app.ios_push = APNs(use_sandbox=True, cert_file=app.config.get('APNS_CERT_PEM', ''), key_file=app.config.get('APNS_KEY_PEM', ''))

def generate_payload(title, message, category):
    # Create the payload
    payload = {
        "aps" : {
            "alert" : {
                "title" : title,
                "body" : message,
            },
            "badge" : 0,
            "sound" : "default",
            "content-available" : 1,
            "category": category,
        },
        "message" : message,
    }

    return payload

def send_ios_push(device_token, payload, retries=3):
    try:
        # Send a notification
        app.ios_push.gateway_server.send_notification(device_token, Payload(custom=payload))
    except:
        # If there was an error and we should retry, let's try again
        if retries:
            create_apns()
            send_ios_push(device_token, payload, retries-1)

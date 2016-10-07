from apns3 import Payload

from talcookie import ios_push

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

def send_ios_push(device_token, payload):
    # Send a notification
    ios_push.gateway_server.send_notification(device_token, Payload(custom=payload))

from flask import json

def handle_response(success, message):
    d = {
        "success": success,
        "message": message
    }

    return json.dumps(d)

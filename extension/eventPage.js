function registerCallback(registrationId) {
  if (chrome.runtime.lastError) {
    // When the registration fails, handle the error and retry the
    // registration later.
    console.log(chrome.runtime.lastError);
    return;
  }

  // Send the registration token to your application server.
  sendRegistrationId(registrationId, function(succeed) {
    // Once the registration token is received by your server,
    // set the flag such that register will not be invoked
    // next time when the app starts up.
    if (succeed)
      chrome.storage.local.set({registered: true});
  });
}

function sendRegistrationId(registrationId, callback) {
  // Send the registration token to your application server
  // in a secure way.
  $.ajax({
    method: "POST",
    url: "http://talcookie.app.csh.rit.edu/register/client",
    data: { 
      client_id: registrationId
    },
    success: function(data) {
      data = $.parseJSON(data);
      if (data['success']) {
        chrome.storage.local.set({registrationId: registrationId});
        callback(true);
      } else {
        callback(false); 
      }
    },
    error: function(data) {
      callback(false);
    }
  });
}

chrome.runtime.onInstalled.addListener(function() {
  chrome.storage.local.get("registered", function(result) {
    // If already registered, bail out.
    if (result["registered"])
      return;

    // Up to 100 senders are allowed.
    var senderIds = ["911735082627"];
    chrome.gcm.register(senderIds, registerCallback);
  });

  // By default, send notifications
  chrome.storage.local.set({sendNotifications: true});
});

chrome.gcm.onMessage.addListener(function(message) {
  // A message is an object with a data property that
  // consists of key-value pairs.
  console.log(message);
  chrome.tabs.query({url: "http://orteil.dashnet.org/cookieclicker/"}, function(tabs) {
    chrome.tabs.sendMessage(tabs[0].id, {click: true});
  });
});

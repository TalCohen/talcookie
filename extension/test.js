function registerCallback(registrationId) {
  if (chrome.runtime.lastError) {
    // When the registration fails, handle the error and retry the
    // registration later.
    return;
  }

  // Send the registration token to your application server.
  sendRegistrationId(function(succeed) {
    // Once the registration token is received by your server,
    // set the flag such that register will not be invoked
    // next time when the app starts up.
    if (succeed)
      chrome.storage.local.set({registered: true});
  });
}

function sendRegistrationId(callback) {
  // Send the registration token to your application server
  // in a secure way.
}

$.ajax({
        method: "POST",
        url: "http://gravity.csh.rit.edu:5000/test/post",
        data: {testname: "testval"},
        complete: function(data) {
            console.log(data);
        }
    });

chrome.runtime.onStartup.addListener(function() {
$.ajax({
        method: "POST",
        url: "http://gravity.csh.rit.edu:5000/test/post",
        data: {testname: "testval"},
        complete: function(data) {
            console.log(data);
        }
    });
  chrome.storage.local.get("registered", function(result) {
    // If already registered, bail out.
    if (result["registered"])
      return;

    // Up to 100 senders are allowed.
    var senderIds = ["Your-Sender-ID"];
    chrome.gcm.register(senderIds, registerCallback);
  });
});

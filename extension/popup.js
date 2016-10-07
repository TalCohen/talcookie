$(document).ready(function() {
  chrome.storage.local.get('sendNotifications', function(result) {
    $('#notifs').prop('checked', result['sendNotifications']);
  });

  $('#notifs').change(function() {
    chrome.storage.local.set({sendNotifications: $(this).prop('checked')});
  });
});

document.addEventListener('DOMContentLoaded', function() {
  chrome.storage.local.get('registrationId', function(result) {
    var registrationId = result['registrationId'];
    if (registrationId) {
      $('#qrcode').text('');
      $('#qrcode').qrcode(registrationId);
    }
  });
});


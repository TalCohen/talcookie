function checkGoldenCookie() {
    var timeout = 1000; // Check every second
    var gc = $('.shimmer')

    // If there is a golden cookie
    if (gc.length) {
        timeout = 1000 * 60; // Don't check again for at least a minute
        console.log("Golden cookie detected!");

        // Determine if it's a wrath cookie
        var isWrath = false;
        img = gc.css('background-image').split("url(")[1].split("img/")[1];
        if (img.startsWith("wrath")) {
            isWrath = true;
        }
        
        // Notify the user of the golden cookie
        chrome.storage.local.get(["registrationId", "sendNotifications"], function(result) {
            if (result["registrationId"]) {
                if (result["sendNotifications"]) {
                    console.log("Sending notification...");
                    notifyUser(isWrath, result["registrationId"]);
                }
            } else {
                console.log("Unable to send notification - browser not registered."); 
            }
        });
    }

    setTimeout(checkGoldenCookie, timeout);
}

function notifyUser(isWrath, registrationId) {
    $.ajax({
        method: "POST",
        url: "http://gravity.csh.rit.edu:3333/notify",
        data: {
            is_wrath: isWrath,
            client_id: registrationId
        },
        complete: function(data) {
            console.log(data);
        }
    });
}

checkGoldenCookie();

chrome.runtime.onMessage.addListener(
    function(request, sender, sendResponse) {
        if (request.click) {
            var gc = $('.shimmer')

            // If there is a golden cookie
            if (gc.length) {
                console.log("Clicking!");
                gc.click();
            }
        }
    });

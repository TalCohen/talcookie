function checkGoldenCookie() {
    var timeout = 1000; // Check every second
    var shimmers = $('.shimmer')

    for (var i = 0; i < shimmers.length; i++) {
        var shimmer = shimmers.eq(i);
        var shimmerType = getShimmerType(shimmer);

        // Make sure it's not just a reindeer
        if (!shimmerType.startsWith("frostedReindeer")) {
            console.log("Golden cookie detected!");
            timeout = 1000 * 60; // Don't check again for at least a minute

            // Determine if it's a wrath cookie
            var isWrath = false;
            if (shimmerType.startsWith("wrath")) {
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

            // Break out of checking
            break;
        }
    }

    setTimeout(checkGoldenCookie, timeout);
}

function getShimmerType(shimmer) {
    return shimmer.css('background-image').split("url(")[1].split("img/")[1];
}

function notifyUser(isWrath, registrationId) {
    $.ajax({
        method: "POST",
        url: "http://talcookie.app.csh.rit.edu/notify",
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
            var shimmers = $('.shimmer')

            // If there is a golden cookie
            for (var i = 0; i < shimmers.length; i++) {
                var shimmer = shimmers.eq(i);
                var shimmerType = getShimmerType(shimmer);
                if (!shimmerType.startsWith("frostedReindeer")) {
                    console.log("Clicking!");
                    shimmer.click();
                    break;
                }
            }
        }
    });

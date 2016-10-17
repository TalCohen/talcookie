package talcohen.talcookie;

import android.app.IntentService;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;

/**
 * Created by talcohen on 10/16/16.
 */

public class ClickIntentService extends IntentService {

    public ClickIntentService() {
        super("ClickIntentService");
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        Log.d("ClickIntentService", "Clicking...");

//        String request = "http://talcookie.app.csh.rit.edu/click";
//        String clientId = rawResult.getText();
//        String params = "client_id=" + clientId + "&device_token=" + FirebaseInstanceId.getInstance().getToken();
        // Send

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.cancel(0);
        sendBroadcast(new Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS));
    }
}

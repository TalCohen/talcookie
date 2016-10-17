package talcohen.talcookie;

import android.*;
import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import android.util.Log;
import android.view.View;

import com.google.firebase.iid.FirebaseInstanceId;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        final int status = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(this);
        if (status != ConnectionResult.SUCCESS)
        {
            Log.d("MainActivity", "Attempting to update GooglePlayServices...");
            GoogleApiAvailability.getInstance().makeGooglePlayServicesAvailable(this);
        }

        String token = FirebaseInstanceId.getInstance().getToken();
        Log.d("MainActivity", "FirebaseInstanceIdToken: " + token);

        if (ContextCompat.checkSelfPermission(this,
                android.Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, 1);
        }
    }

    public void pairButtonTapped(View v) {
        Log.d("TEST", "BUTTON TAPPED");
        startActivity(new Intent(this, QRReaderActivity.class));
    }
}

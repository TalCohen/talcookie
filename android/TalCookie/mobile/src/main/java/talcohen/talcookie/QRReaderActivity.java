package talcohen.talcookie;

import android.app.Activity;
import android.os.Bundle;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.zxing.Result;
import me.dm7.barcodescanner.zxing.ZXingScannerView;

/**
 * Created by talcohen on 10/16/16.
 */

public class QRReaderActivity extends Activity implements ZXingScannerView.ResultHandler {
    private ZXingScannerView mScannerView;

    @Override
    public void onCreate(Bundle state) {
        super.onCreate(state);
        mScannerView = new ZXingScannerView(this);   // Programmatically initialize the scanner view
        setContentView(mScannerView);                // Set the scanner view as the content view
    }

    @Override
    public void onResume() {
        super.onResume();
        mScannerView.setResultHandler(this); // Register ourselves as a handler for scan results.
        mScannerView.startCamera();          // Start camera on resume
    }

    @Override
    public void onPause() {
        super.onPause();
        mScannerView.stopCamera();           // Stop camera on pause
    }

    @Override
    public void handleResult(Result rawResult) {
        // Do something with the result here
//        if (rawResult.getBarcodeFormat() != BarcodeFormat.) {
//            Log.d("QRReaderActivity", "Found a barcode that isn't a QR code.");
//            mScannerView.resumeCameraPreview(this);
//            return;
//        }

        String request = "http://talcookie.app.csh.rit.edu/register/device";

        String clientId = rawResult.getText();
        boolean ios = false;
        String params = "client_id=" + clientId + "&device_token=" + FirebaseInstanceId.getInstance().getToken() + "&ios=" + ios;
        new RequestHelper().execute(request, params);

//        Settings.

        finish();
    }
}
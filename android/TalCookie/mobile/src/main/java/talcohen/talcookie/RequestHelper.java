package talcohen.talcookie;

import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Created by talcohen on 10/16/16.
 */

public class RequestHelper extends AsyncTask<String, String, String> {

    @Override
    protected String doInBackground(String... params) {
        Log.d("RequestHelper", "Starting");
        String request = params[0];
        byte[] postData = params[1].getBytes(StandardCharsets.UTF_8);
        int postDataLength = postData.length;

        String result = "";
        InputStream in = null;
        try {
            Log.d("RequestHelper", "Creating URL");
            URL url = new URL(request);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setInstanceFollowRedirects(false);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("charset", "utf-8");
            conn.setRequestProperty("Content-Length", Integer.toString(postDataLength));
            conn.setUseCaches(false);

            Log.d("RequestHelper", "Creating output stream");
            DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
            wr.write(postData);
            wr.flush();
            wr.close();

            Log.d("RequestHelper", "Creating input stream");
            in = new BufferedInputStream(conn.getInputStream());
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.d("RequestHelper", "Getting input stream");
        result = in.toString();

        Log.d("RequestHelper", result);

        return result;
    }

    @Override
    protected void onPostExecute(String s) {
        super.onPostExecute(s);
    }
}

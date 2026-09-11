/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utility;
import com.google.gson.JsonObject;
import java.io.IOException;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class InviaSms {
    public static String  invia_sms(String destinatario, String testo){
        OkHttpClient client = new OkHttpClient();

        JsonObject json = new JsonObject();
        json.addProperty("sender", "Bioenergia");
        json.addProperty("recipient", destinatario);
        json.addProperty("content", testo);

        RequestBody body = RequestBody.create(MediaType.parse("application/json"),json.toString());

        Request request = new Request.Builder()
                .url("https://api.brevo.com/v3/transactionalSMS/sms")
                .addHeader("accept", "application/json")
                .addHeader("api-key", Config.get("BREVO_API_KEY"))
                .addHeader("content-type", "application/json")
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println("HTTP status: " + response.code());
            System.out.println("Response: " + response.body().string());
            return response.code()+"";
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }
    

}
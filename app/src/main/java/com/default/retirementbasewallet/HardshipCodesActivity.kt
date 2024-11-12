package com.default.retirementbasewallet

import android.os.Bundle
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.default.retirementbasewallet.api.ApiService
import okhttp3.OkHttpClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class HardshipCodesActivity : AppCompatActivity() {

    private lateinit var hardshipCodesText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_hardship_codes)

        hardshipCodesText = findViewById(R.id.hardshipCodesText)

        val userAddress = "user_address_placeholder" // Replace with actual user address
        loadHardshipCodes(userAddress)
    }

    private fun loadHardshipCodes(address: String) {
        val retrofit = Retrofit.Builder()
            .baseUrl("http://your-backend-url.com/") // Replace with your backend URL
            .client(OkHttpClient.Builder().build())
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val apiService = retrofit.create(ApiService::class.java)
        apiService.getHardshipCodes(address).enqueue(object : Callback<List<String>> {
            override fun onResponse(call: Call<List<String>>, response: Response<List<String>>) {
                if (response.isSuccessful && response.body() != null) {
                    val codes = response.body()!!.joinToString("\n")
                    hardshipCodesText.text = "Hardship Codes:\n$codes"
                } else {
                    Toast.makeText(this@HardshipCodesActivity, "Failed to load hardship codes", Toast.LENGTH_SHORT).show()
                }
            }

            override fun onFailure(call: Call<List<String>>, t: Throwable) {
                Toast.makeText(this@HardshipCodesActivity, "Error: ${t.message}", Toast.LENGTH_SHORT).show()
            }
        })
    }
}

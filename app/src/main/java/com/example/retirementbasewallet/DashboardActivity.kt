package com.example.retirementbasewallet

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import org.web3j.protocol.Web3j
import org.web3j.protocol.http.HttpService

class DashboardActivity : AppCompatActivity() {
    private lateinit var web3j: Web3j
    private lateinit var balanceText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)

        balanceText = findViewById(R.id.balanceText)
        val depositButton = findViewById<Button>(R.id.depositButton)
        val withdrawButton = findViewById<Button>(R.id.withdrawButton)

        web3j = Web3j.build(HttpService("https://base-mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID"))

        depositButton.setOnClickListener {
            Toast.makeText(this, "Deposit not yet implemented", Toast.LENGTH_SHORT).show()
        }

        withdrawButton.setOnClickListener {
            Toast.makeText(this, "Withdraw not yet implemented", Toast.LENGTH_SHORT).show()
        }

        loadBalance()
    }

    private fun loadBalance() {
        balanceText.text = "Balance: 0.0 ETH" // Placeholder
    }
}

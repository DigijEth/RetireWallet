package com.example.retirementbasewallet

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import org.web3j.protocol.Web3j
import org.web3j.protocol.http.HttpService

class MainActivity : AppCompatActivity() {
    private lateinit var web3j: Web3j

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        web3j = Web3j.build(HttpService("https://base-mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID"))

        val connectMetaMaskButton = findViewById<Button>(R.id.connectMetaMaskButton)
        val connectCoinbaseButton = findViewById<Button>(R.id.connectCoinbaseButton)

        connectMetaMaskButton.setOnClickListener {
            connectToWallet("MetaMask")
        }

        connectCoinbaseButton.setOnClickListener {
            connectToWallet("Coinbase Wallet")
        }
    }

    private fun connectToWallet(wallet: String) {
        Toast.makeText(this, "$wallet connected", Toast.LENGTH_SHORT).show()
        startActivity(Intent(this, DashboardActivity::class.java))
    }
}

package com.default.retirementbasewallet

import org.web3j.crypto.Credentials
import org.web3j.crypto.ECKeyPair
import org.web3j.crypto.Keys
import java.lang.IllegalArgumentException

object WalletImportUtils {

    /**
     * Imports a wallet using a raw private key string.
     * @param privateKeyString The private key string in hexadecimal format.
     * @return WalletData containing the address and private key.
     * @throws IllegalArgumentException if the private key is invalid.
     */
    fun importWalletFromPrivateKey(privateKeyString: String): WalletData {
        try {
            val privateKey = privateKeyString.toBigInteger(16)
            val ecKeyPair = ECKeyPair.create(privateKey)
            val credentials = Credentials.create(ecKeyPair)
            val address = credentials.address
            return WalletData("", privateKeyString, address)
        } catch (e: Exception) {
            throw IllegalArgumentException("Invalid private key format")
        }
    }
}

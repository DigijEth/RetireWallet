package com.default.retirementbasewallet

import org.web3j.crypto.Credentials
import org.web3j.crypto.ECKeyPair
import org.web3j.crypto.Wallet
import org.web3j.crypto.WalletFile
import org.web3j.crypto.CipherException
import com.fasterxml.jackson.databind.ObjectMapper
import java.io.IOException

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

    /**
     * Imports a wallet using a JSON keystore file.
     * @param keystoreJson The JSON string of the keystore file.
     * @param password The password to decrypt the keystore.
     * @return WalletData containing the address and private key.
     * @throws IOException if the JSON is invalid or an I/O error occurs.
     * @throws CipherException if the password is incorrect.
     */
    fun importWalletFromKeystore(keystoreJson: String, password: String): WalletData {
        try {
            val objectMapper = ObjectMapper()
            val walletFile = objectMapper.readValue(keystoreJson, WalletFile::class.java)
            val ecKeyPair = Wallet.decrypt(password, walletFile)
            val credentials = Credentials.create(ecKeyPair)
            val address = credentials.address
            return WalletData("", credentials.ecKeyPair.privateKey.toString(16), address)
        } catch (e: CipherException) {
            throw IllegalArgumentException("Invalid password or keystore JSON")
        } catch (e: IOException) {
            throw IllegalArgumentException("Invalid keystore JSON format")
        }
    }
}

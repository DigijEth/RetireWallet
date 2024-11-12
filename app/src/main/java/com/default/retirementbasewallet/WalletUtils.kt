package com.default.retirementbasewallet

import org.bitcoinj.crypto.MnemonicCode
import org.bitcoinj.wallet.DeterministicSeed
import org.web3j.crypto.Credentials
import org.web3j.crypto.ECKeyPair
import org.web3j.crypto.Keys
import org.web3j.crypto.MnemonicUtils
import java.security.SecureRandom

object WalletUtils {

    // Generate a new wallet and return mnemonic, private key, and address
    fun createNewWallet(): WalletData {
        // Generate a random 12-word mnemonic phrase
        val secureRandom = SecureRandom()
        val entropy = ByteArray(16) // 128-bit entropy for 12-word mnemonic
        secureRandom.nextBytes(entropy)
        val mnemonic = MnemonicUtils.generateMnemonic(entropy)

        // Generate seed from mnemonic
        val seed = MnemonicUtils.generateSeed(mnemonic, null)

        // Generate private key from seed
        val ecKeyPair = ECKeyPair.create(seed)
        val credentials = Credentials.create(ecKeyPair)
        val address = credentials.address

        return WalletData(mnemonic, credentials.ecKeyPair.privateKey.toString(16), address)
    }
}

data class WalletData(val mnemonic: String, val privateKey: String, val address: String)

package com.default.retirementbasewallet

import org.web3j.crypto.Credentials
import org.web3j.crypto.ECKeyPair
import org.web3j.crypto.MnemonicUtils

object WalletRestoreUtils {

    fun restoreWallet(mnemonic: String): WalletData {
        val seed = MnemonicUtils.generateSeed(mnemonic, null)
        val ecKeyPair = ECKeyPair.create(seed)
        val credentials = Credentials.create(ecKeyPair)
        val address = credentials.address

        return WalletData(mnemonic, credentials.ecKeyPair.privateKey.toString(16), address)
    }
}

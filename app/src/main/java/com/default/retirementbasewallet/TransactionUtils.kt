package com.default.retirementbasewallet

import android.content.Context
import org.web3j.crypto.Credentials
import org.web3j.crypto.RawTransaction
import org.web3j.crypto.TransactionEncoder
import org.web3j.utils.Numeric
import org.web3j.protocol.Web3j
import org.web3j.protocol.core.methods.response.EthSendTransaction
import org.web3j.protocol.core.methods.response.EthGasPrice
import org.web3j.protocol.core.methods.response.EthGetTransactionCount
import java.math.BigInteger

object TransactionUtils {

    fun sendTransaction(
        context: Context,
        web3j: Web3j,
        toAddress: String,
        amount: BigInteger
    ): EthSendTransaction {
        val privateKey = SecureStorage.loadPrivateKey(context)
            ?: throw IllegalStateException("No private key found")

        val credentials = Credentials.create(privateKey)

        // Get the nonce
        val nonce = web3j.ethGetTransactionCount(credentials.address, "latest").send().transactionCount

        // Create raw transaction
        val gasPrice = web3j.ethGasPrice().send().gasPrice
        val gasLimit = BigInteger.valueOf(21000)
        val rawTransaction = RawTransaction.createEtherTransaction(nonce, gasPrice, gasLimit, toAddress, amount)

        // Sign and send transaction
        val signedMessage = TransactionEncoder.signMessage(rawTransaction, credentials)
        val hexValue = Numeric.toHexString(signedMessage)
        return web3j.ethSendRawTransaction(hexValue).send()
    }
}

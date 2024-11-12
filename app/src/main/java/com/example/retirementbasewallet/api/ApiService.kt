package com.example.retirementbasewallet.api

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path

interface ApiService {
    @GET("/api/hardship/{address}")
    fun getHardshipCodes(@Path("address") address: String): Call<List<String>>
}

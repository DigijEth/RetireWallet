# Web3j
-keepclassmembers class * {
    @org.web3j.abi.datatypes.annotation.Bin public *;
}
-dontwarn org.web3j.**

# Retrofit and OkHttp
-dontwarn okhttp3.**
-dontwarn retrofit2.**

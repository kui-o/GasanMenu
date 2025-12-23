package com.example.gasanmenu

import java.time.MonthDay

data class Restaurant (
    val id: String,
    val name: String,
    val time: String,
    val price: String,
    val distance: String,
    val thumbnail: String,
    val mapUrl: String,
    val menuUrl: String,
    private val imageProvider: () -> Pair<String, MonthDay?>
) {
    private val imageCache = DailyCachedMenu(imageProvider)

    val menuImageURL: String
        get() = imageCache.get()

    fun forceRefresh() {imageCache.get(true)}
}
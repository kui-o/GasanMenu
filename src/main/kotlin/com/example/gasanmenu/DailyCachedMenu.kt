package com.example.gasanmenu

import java.time.DayOfWeek
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.MonthDay
import java.time.ZoneId
import java.time.temporal.ChronoUnit

class DailyCachedMenu(private val provider: () -> Pair<String, MonthDay?>) {

    @Volatile
    private var cachedUrl: String = ""
    @Volatile
    private var cachedDate: MonthDay? = null

    @Volatile
    private var lastUpdatedDate: LocalDateTime = LocalDateTime.MIN

    @Synchronized
    fun get(forceRefresh: Boolean = false): String {
        val now = LocalDateTime.now(ZoneId.of("UTC"))
        val todayMonthDay = MonthDay.from(now)
        val minutesSinceLastParse = ChronoUnit.MINUTES.between(lastUpdatedDate, now)

        val isWeekend = now.dayOfWeek == DayOfWeek.SATURDAY || now.dayOfWeek == DayOfWeek.SUNDAY

        if (forceRefresh || (!isWeekend && cachedDate != todayMonthDay && minutesSinceLastParse > 10)) {
            lastUpdatedDate = now

            try {
                var (newUrl, newDate) = provider()
                newDate = newDate ?: run {
                    if(cachedUrl == newUrl) cachedDate else todayMonthDay
                }

                cachedUrl = newUrl
                cachedDate = newDate
            } catch (e: Exception) {
                e.printStackTrace()
                cachedUrl = ""
                cachedDate = null
            }
        }

        return cachedUrl
    }
}
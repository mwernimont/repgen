context("utils-time tests")

wd <- getwd()
setwd(dir = tempdir())

test_that('flexibleTimeParse can parse dates with UTC', {
  time_str <- "2013-10-02T08:00:00.000Z"
  timezone <- "Etc/GMT+6"
  parsed_time <- flexibleTimeParse(time_str, timezone)
  
  expect_is(parsed_time, "POSIXct")
  expect_true(hour(parsed_time) == 2)
})

test_that('flexibleTimeParse can parse dates with offsets', {
  time_str <- "2013-10-02T08:00:00.000-06:00"
  timezone <- "Etc/GMT+6"
  parsed_time <- flexibleTimeParse(time_str, timezone)
  
  expect_is(parsed_time, "POSIXct")
  expect_true(hour(parsed_time) == 8)
})

test_that('flexibleTimeParse can parse DV values', {
  time_str <- "2013-10-02"
  timezone <- "Etc/GMT+6"
  parsed_time <- flexibleTimeParse(time_str, timezone)
  
  expect_is(parsed_time, "POSIXct")
  expect_true(hour(parsed_time) == 12)
})

test_that('toStartOfDay works', {
  time_str <- "2013-10-02T21:00:00.000-06:00"
  timezone <- "Etc/GMT+6"
  parsed_time <- flexibleTimeParse(time_str, timezone)
  parsed_time <- toStartOfDay(parsed_time)
  
  expect_is(parsed_time, "POSIXct")
  expect_true(hour(parsed_time) == 0)
})

test_that('toEndOfDay works', {
  time_str <- "2013-10-02T09:00:00.000-06:00"
  timezone <- "Etc/GMT+6"
  parsed_time <- flexibleTimeParse(time_str, timezone)
  parsed_time <- toEndOfDay(parsed_time)
  
  expect_is(parsed_time, "POSIXct")
  expect_true(hour(parsed_time) == 23)
  expect_true(minute(parsed_time) == 59)
})

test_that('toStartOfMonth works', {
  time_str <- "2013-10-02T21:00:00.000-06:00"
  timezone <- "Etc/GMT+6"
  parsed_time <- flexibleTimeParse(time_str, timezone)
  parsed_time <- toStartOfMonth(parsed_time)
  
  expect_is(parsed_time, "POSIXct")
  expect_true(day(parsed_time) == 1)
})

test_that('toEndOfMonth works', {
  time_str <- "2013-10-25T21:00:00.000-06:00"
  timezone <- "Etc/GMT+6"
  parsed_time <- flexibleTimeParse(time_str, timezone)
  parsed_time <- toEndOfMonth(parsed_time)
  
  expect_is(parsed_time, "POSIXct")
  expect_true(day(parsed_time) == 30)
})

test_that('toEndOfTime works', {
  time_str <- "9999-12-31T23:59:59.9999999Z"
  timezone <- "Etc/GMT+6"
  parsed_time <- flexibleTimeParse(time_str, timezone)
  parsed_time <- toEndOfTime(parsed_time)
  
  expect_is(parsed_time, "POSIXct")
  expect_true(year(parsed_time) == 2100)
})

test_that('isFirstDayOfMonth works', {
  time_str1 <- "2013-01-01T09:00:00-05:00"
  time_str2 <- "2013-01-02T09:00:00-05:00"
  timezone <- "Etc/GMT+5"
  parsed_time_1 <- repgen:::flexibleTimeParse(time_str1, timezone)
  parsed_time_2 <- repgen:::flexibleTimeParse(time_str2, timezone)

  expect_true(repgen:::isFirstDayOfMonth(parsed_time_1))
  expect_false(repgen:::isFirstDayOfMonth(parsed_time_2))
})

test_that('calculateTotalDays works', {
  timezone <- "Etc/GMT+5"
  startDate <- repgen:::flexibleTimeParse("2013-01-01T09:00:00-05:00", timezone)
  endDate1 <- repgen:::flexibleTimeParse("2013-01-02T09:00:00-05:00", timezone)
  endDate2 <- repgen:::flexibleTimeParse("2013-01-09T09:00:00-05:00", timezone)

  expect_equal(repgen:::calculateTotalDays(startDate, endDate1), 1)
  expect_equal(repgen:::calculateTotalDays(startDate, endDate2), 8)
})

test_that('boundDate works', {
  timezone <- "Etc/GMT+5"
  startDate <- repgen:::flexibleTimeParse("2013-01-01T09:00:00-05:00", timezone)
  endDate <- repgen:::flexibleTimeParse("2013-01-09T09:00:00-05:00", timezone)
  dateRange <- c(startDate, endDate)

  testDate1 <- repgen:::flexibleTimeParse("2013-01-01T09:00:00-05:00", timezone)
  testDate2 <- repgen:::flexibleTimeParse("2013-01-09T09:00:00-05:00", timezone)
  testDate3 <- repgen:::flexibleTimeParse("2012-12-31T09:00:00-05:00", timezone)
  testDate4 <- repgen:::flexibleTimeParse("2013-01-10T09:00:00-05:00", timezone)
  testDate5 <- repgen:::flexibleTimeParse("2012-12-20T09:00:00-05:00", timezone)
  testDate6 <- repgen:::flexibleTimeParse("2013-01-20T09:00:00-05:00", timezone)

  boundDate1 <- boundDate(testDate1, dateRange)
  boundDate2 <- boundDate(testDate2, dateRange)
  boundDate3 <- boundDate(testDate3, dateRange)
  boundDate4 <- boundDate(testDate4, dateRange)
  boundDate5 <- boundDate(testDate5, dateRange)
  boundDate6 <- boundDate(testDate6, dateRange)

  expect_equal(as.numeric(testDate1), as.numeric(boundDate1))
  expect_equal(as.numeric(testDate2), as.numeric(boundDate2))
  expect_equal(as.numeric(testDate3), as.numeric(boundDate3))
  expect_equal(as.numeric(testDate4), as.numeric(boundDate4))
  expect_equal(as.numeric(testDate3), as.numeric(boundDate5))
  expect_equal(as.numeric(testDate4), as.numeric(boundDate6))
})

test_that('formatUTCTimeLabel properly formats time as a text label', {
  timezone1 <- "Etc/GMT+5"
  timezone2 <- "UTC"
  testDate1 <- repgen:::flexibleTimeParse("2013-01-01T09:00:00-05:00", timezone1)
  testDate2 <- repgen:::flexibleTimeParse("2013-01-09T09:00:00-06:00", timezone1)
  testDate3 <- repgen:::flexibleTimeParse("2012-12-31T09:00:00Z", timezone1)
  testDate4 <- repgen:::flexibleTimeParse("2013-01-01T09:00:00-05:00", timezone2)
  testDate5 <- repgen:::flexibleTimeParse("2013-01-09T09:00:00-06:00", timezone2)
  testDate6 <- repgen:::flexibleTimeParse("2012-12-31T09:00:00Z", timezone2)
  testDate7 <- repgen:::flexibleTimeParse("9999-12-31T00:00:00Z", timezone1)
  testDate8 <- repgen:::flexibleTimeParse("9999-12-31T00:00:00Z", timezone2)
  
  testLabel1 <- repgen:::formatUTCTimeLabel(testDate1)
  testLabel2 <- repgen:::formatUTCTimeLabel(testDate2)
  testLabel3 <- repgen:::formatUTCTimeLabel(testDate3)
  testLabel4 <- repgen:::formatUTCTimeLabel(testDate4)
  testLabel5 <- repgen:::formatUTCTimeLabel(testDate5)
  testLabel6 <- repgen:::formatUTCTimeLabel(testDate6)
  testLabel7 <- repgen:::formatUTCTimeLabel(testDate7)
  testLabel8 <- repgen:::formatUTCTimeLabel(testDate8)
  
  expect_equal(testLabel1, " Jan 01, 2013 09:00:00 (UTC -05:00)")
  expect_equal(testLabel2, " Jan 09, 2013 10:00:00 (UTC -05:00)")
  expect_equal(testLabel3, " Dec 31, 2012 04:00:00 (UTC -05:00)")
  expect_equal(testLabel4, " Jan 01, 2013 14:00:00 (UTC +00:00)")
  expect_equal(testLabel5, " Jan 09, 2013 15:00:00 (UTC +00:00)")
  expect_equal(testLabel6, " Dec 31, 2012 09:00:00 (UTC +00:00)")
  expect_equal(testLabel7, " Dec 30, 9999 19:00:00 (UTC -05:00)")
  expect_equal(testLabel8, " Dec 31, 9999 00:00:00 (UTC +00:00)")
})
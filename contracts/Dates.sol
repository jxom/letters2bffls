//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './Utils.sol';

library dates {
    uint256 private constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint256 private constant SECONDS_PER_HOUR = 60 * 60;
    uint256 private constant SECONDS_PER_MINUTE = 60;
    int256 private constant OFFSET19700101 = 2440588;

    uint256 private constant DOW_MON = 1;
    uint256 private constant DOW_TUE = 2;
    uint256 private constant DOW_WED = 3;
    uint256 private constant DOW_THU = 4;
    uint256 private constant DOW_FRI = 5;
    uint256 private constant DOW_SAT = 6;
    uint256 private constant DOW_SUN = 7;

    function _daysToDate(uint256 _days)
        internal
        pure
        returns (
            uint256 year,
            uint256 month,
            uint256 day
        )
    {
        int256 __days = int256(_days);

        int256 L = __days + 68569 + OFFSET19700101;
        int256 N = (4 * L) / 146097;
        L = L - (146097 * N + 3) / 4;
        int256 _year = (4000 * (L + 1)) / 1461001;
        L = L - (1461 * _year) / 4 + 31;
        int256 _month = (80 * L) / 2447;
        int256 _day = L - (2447 * _month) / 80;
        L = _month / 11;
        _month = _month + 2 - 12 * L;
        _year = 100 * (N - 49) + _year + L;

        year = uint256(_year);
        month = uint256(_month);
        day = uint256(_day);
    }

    function getDayOfWeek(uint256 timestamp)
        internal
        pure
        returns (uint256 dayOfWeek)
    {
        uint256 _days = timestamp / SECONDS_PER_DAY;
        dayOfWeek = ((_days + 3) % 7) + 1;
    }

    function formatDayOfWeek(uint256 dayOfWeek)
        internal
        pure
        returns (string memory formattedDayOfWeek)
    {
        if (dayOfWeek == 1) return 'Monday';
        if (dayOfWeek == 2) return 'Tuesday';
        if (dayOfWeek == 3) return 'Wednesday';
        if (dayOfWeek == 4) return 'Thursday';
        if (dayOfWeek == 5) return 'Friday';
        if (dayOfWeek == 6) return 'Saturday';
        if (dayOfWeek == 7) return 'Sunday';
    }

    function getDay(uint256 timestamp) internal pure returns (uint256 day) {
        (, , day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }

    function formatDay(uint256 day)
        internal
        pure
        returns (string memory formattedDay)
    {
        string memory suffix = 'th';
        if (day == 1) suffix = 'st';
        if (day == 2) suffix = 'nd';
        if (day == 3) suffix = 'rd';
        return string.concat(utils.uint2str(day), suffix);
    }

    function getMonth(uint256 timestamp) internal pure returns (uint256 month) {
        (, month, ) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }

    function formatMonth(uint256 month)
        internal
        pure
        returns (string memory formattedMonth)
    {
        if (month == 1) formattedMonth = 'January';
        if (month == 2) formattedMonth = 'Febuary';
        if (month == 3) formattedMonth = 'March';
        if (month == 4) formattedMonth = 'April';
        if (month == 5) formattedMonth = 'May';
        if (month == 6) formattedMonth = 'June';
        if (month == 7) formattedMonth = 'July';
        if (month == 8) formattedMonth = 'August';
        if (month == 9) formattedMonth = 'September';
        if (month == 10) formattedMonth = 'October';
        if (month == 11) formattedMonth = 'November';
        if (month == 12) formattedMonth = 'December';
        return formattedMonth;
    }

    function getYear(uint timestamp) internal pure returns (uint year) {
        (year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }

    function getFormattedDate(uint256 timestamp)
        internal
        pure
        returns (string memory formattedDate)
    {
        uint256 dayOfWeek = getDayOfWeek(timestamp);
        uint256 day = getDay(timestamp);
        uint256 month = getMonth(timestamp);
        uint256 year = getYear(timestamp);

        string memory formattedDayOfWeek = formatDayOfWeek(dayOfWeek);
        string memory formattedDay = formatDay(day);
        string memory formattedMonth = formatMonth(month);
        string memory formattedYear = utils.uint2str(year);

        return string.concat(formattedDayOfWeek, ', ', formattedDay, ' ', formattedMonth, ' ', formattedYear);
    }
}

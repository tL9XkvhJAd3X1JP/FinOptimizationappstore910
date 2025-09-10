package com.fin.optimization.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by WAHAHA on 2018/5/22.
 */
public class StringUtils {


    /**
     * 字符串是否为空
     *
     * @param string
     * @return
     */
    public static boolean isEmpty(String string) {
        if (null == string || "null".equalsIgnoreCase(string)) {
            return true;
        }
        if (0 == string.trim().length() || 0 == string.replace(" ", "").length()) {
            return true;
        }

        return false;
    }

    /**
     * 判断字符串是否是整数
     */
    public static boolean isInteger(String value) {
        try {
            Integer.parseInt(value);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * 判断字符串是否是浮点数
     */
    public static boolean isDouble(String value) {
        try {
            Double.parseDouble(value);
            if (value.contains("."))
                return true;
            return false;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * 判断字符串是否是数字
     */
    public static boolean isNumber(String value) {
        return isInteger(value) || isDouble(value);
    }

    /**
     * 格式化日期 yyyy-MM-dd
     *
     * @param milliseconds 日期的毫秒数
     * @return
     */
    public static String getDate(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
//        simpleDateFormat.setTimeZone(TimeZone.getTimeZone("GMT+08:00"));
        return simpleDateFormat.format(date);
    }

    /**
     * 格式化日期 yyyy/MM/dd
     *
     * @param milliseconds 日期的毫秒数
     * @return
     */
    public static String getAnotherDate(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy/MM/dd HH:mm:ss
     *
     * @param milliseconds
     * @return
     */
    public static String getDetailDate(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy-MM-dd HH:mm
     *
     * @param milliseconds
     * @return
     */
    public static String getDetailDateNoM(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        return simpleDateFormat.format(date);
    }

    /**
     * HH:mm:ss
     *
     * @param milliseconds
     * @return
     */
    public static String getDetailDate1(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy-MM-dd HH:mm:ss
     *
     * @param milliseconds
     * @return
     */
    public static String getDetailViolationDate(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy-MM-dd HH:mm
     *
     * @param milliseconds
     * @return
     */
    public static String getDetailViolationDateM(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        return simpleDateFormat.format(date);
    }

    /**
     * HH:mm
     *
     * @param milliseconds
     * @return
     */
    public static String getDetailViolationTime(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy/MM/dd E
     *
     * @param milliseconds
     * @return
     */
    public static String getDetailWeekDate(long milliseconds) {
        Date date = new Date(milliseconds);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd E");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy/MM/dd HH:mm
     *
     * @return
     */
    public static String getCurrentDetailDate() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy/MM/dd HH:mm:ss
     *
     * @return
     */
    public static String getCurrentDetailDateSecond() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        return simpleDateFormat.format(date);
    }

    /**
     * E
     *
     * @return
     */
    public static String getCurrentDetailYear() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy/
     *
     * @return
     */
    public static String getCurrentWeek() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("E");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy/MM/dd HH:mm
     *
     * @return
     */
    public static String getCurrentMonthDayDate() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM/dd HH:mm");
        return simpleDateFormat.format(date);
    }


    /**
     * MM/dd
     *
     * @return
     */
    public static String getCurrentMonthDate() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM月dd日");
        return simpleDateFormat.format(date);
    }

    /**
     * MM/dd
     *
     * @return
     */
    public static String getYearMonthDate() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy年MM月dd日");
        return simpleDateFormat.format(date);
    }

    /**
     * yyyy-MM-dd
     *
     * @return
     */
    public static String getCurrentYearMonthDate() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDateFormat.format(date);
    }


    /**
     * yyyy-MM-dd HH:mm
     *
     * @param date
     * @return
     */
    public static long getMillisecondsBydateA(String date) {
        // 注意：SimpleDateFormat构造函数的样式与strDate的样式必须相符
        Date millDate = new Date();
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            // 必须捕获异常
            try {
                if (date != null && !date.equals(""))
                    millDate = simpleDateFormat.parse(date);
            } catch (java.text.ParseException e) {
                e.printStackTrace();
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        }

        return millDate.getTime();
    }

    /**
     * yyyy-MM-dd
     *
     * @param date
     * @return
     */
    public static long getMillisecondsByDateDay(String date) {
        // 注意：SimpleDateFormat构造函数的样式与strDate的样式必须相符
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        // 必须捕获异常
        Date millDate = new Date();
        try {
            if (date != null && !date.equals(""))
                millDate = simpleDateFormat.parse(date);
        } catch (java.text.ParseException e) {
            e.printStackTrace();
        }
        return millDate.getTime();
    }

    /**
     * yyyy-MM-dd
     *
     * @param date
     * @return
     */
    public static long getMillisecondsByDateDayA(String date) {
        // 注意：SimpleDateFormat构造函数的样式与strDate的样式必须相符
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd");
        // 必须捕获异常
        Date millDate = new Date();
        try {
            if (date != null && !date.equals(""))
                millDate = simpleDateFormat.parse(date);
        } catch (java.text.ParseException e) {
            e.printStackTrace();
        }
        return millDate.getTime();
    }
}

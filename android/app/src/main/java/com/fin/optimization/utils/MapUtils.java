package com.fin.optimization.utils;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;

import com.fin.optimization.R;
import com.fin.optimization.bean.LatLonPoint;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;


/**
 * 作者：WangJintao
 * 时间：2017/4/17
 * 邮箱：wangjintao1988@163.com
 */

public class MapUtils {

    private final static double a = 6378245.0;
    private final static double ee = 0.00669342162296594323;

    /**
     * https://lbs.qq.com/uri_v1/guide-mobile-navAndRoute.html
     *
     * @param context
     * @param lat
     * @param lon
     */
    public static void openTencentMap(Context context, String lat, String lon) {
        if (isAvilible(context, "com.tencent.map")) {
            Intent intent = new Intent("android.intent.action.VIEW");
            intent.addCategory("android.intent.category.DEFAULT");
            StringBuffer uriBuffer = new StringBuffer("qqmap://map/routeplan?type=drive&from=我的位置&fromcoord=").
                    append(0).append(",").append(0).append("&to=车的位置")
                    .append("&tocoord=").append(lat).append(",").append(lon);
            intent.setData(Uri.parse(uriBuffer.toString()));
            intent.setPackage("com.tencent.map");
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } else {
            ToastUtil.show(context, context.getString(R.string.not_install_this_app));
        }

    }

    /* 检查手机上是否安装了指定的软件
     * @param context
     * @param packageName：应用包名
     * @return
     */
    private static boolean isAvilible(Context context, String packageName) {
        //获取packagemanager
        final PackageManager packageManager = context.getPackageManager();
        //获取所有已安装程序的包信息
        List<PackageInfo> packageInfos = packageManager.getInstalledPackages(0);
        //用于存储所有已安装程序的包名
        List<String> packageNames = new ArrayList<String>();
        //从pinfo中将包名字逐一取出，压入pName list中
        if (packageInfos != null) {
            int size = packageInfos.size();
            for (int i = 0; i < size; i++) {
                String packName = packageInfos.get(i).packageName;
                packageNames.add(packName);
            }
        }
        //判断packageNames中是否有目标程序的包名，有TRUE，没有FALSE
        return packageNames.contains(packageName);
    }

    public static LatLonPoint gps2GCJ02Point(double latitude, double longitude) {
        LatLonPoint dev = calDev(latitude, longitude);
        double retLat = latitude + dev.getWgLat();
        double retLon = longitude + dev.getWgLon();
        return new LatLonPoint(retLat, retLon);
    }

    private static LatLonPoint calDev(double wgLat, double wgLon) {
        if (isOutOfChina(wgLat, wgLon)) {
            return new LatLonPoint(0, 0);
        }
        double dLat = calLat(wgLon - 105.0, wgLat - 35.0);
        double dLon = calLon(wgLon - 105.0, wgLat - 35.0);
        double radLat = wgLat / 180.0 * Math.PI;
        double magic = Math.sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = Math.sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * Math.PI);
        dLon = (dLon * 180.0) / (a / sqrtMagic * Math.cos(radLat) * Math.PI);
        return new LatLonPoint(dLat, dLon);
    }

    private static boolean isOutOfChina(double lat, double lon) {
        if (lon < 72.004 || lon > 137.8347)
            return true;
        if (lat < 0.8293 || lat > 55.8271)
            return true;
        return false;
    }

    private static double calLat(double x, double y) {
        double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2
                * Math.sqrt(Math.abs(x));
        ret += (20.0 * Math.sin(6.0 * x * Math.PI) + 20.0 * Math.sin(2.0 * x * Math.PI)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(y * Math.PI) + 40.0 * Math.sin(y / 3.0 * Math.PI)) * 2.0 / 3.0;
        ret += (160.0 * Math.sin(y / 12.0 * Math.PI) + 320 * Math.sin(y * Math.PI / 30.0)) * 2.0 / 3.0;
        return ret;
    }

    private static double calLon(double x, double y) {
        double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.sqrt(Math.abs(x));
        ret += (20.0 * Math.sin(6.0 * x * Math.PI) + 20.0 * Math.sin(2.0 * x * Math.PI)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(x * Math.PI) + 40.0 * Math.sin(x / 3.0 * Math.PI)) * 2.0 / 3.0;
        ret += (150.0 * Math.sin(x / 12.0 * Math.PI) + 300.0 * Math.sin(x / 30.0 * Math.PI)) * 2.0 / 3.0;
        return ret;
    }

    public static void openGaodeMap(Context context, double startLat, double startLon, double endLat, double endLon) {
        if (isAvilible(context, "com.autonavi.minimap")) {
            try {
                Intent var3 = new Intent("android.intent.action.VIEW");
                var3.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                var3.addCategory("android.intent.category.DEFAULT");
                var3.setData(Uri.parse(b(startLat, startLon, endLat, endLon)));
                var3.setPackage("com.autonavi.minimap");
//                AMapUtils.a var4 = new AMapUtils.a("oan", context);
//                var4.start();
                context.startActivity(var3);
            } catch (Exception e) {
                ToastUtil.show(context, context.getString(R.string.not_install_this_app));
                e.printStackTrace();
            }
        } else {
            ToastUtil.show(context, context.getString(R.string.not_install_this_app));
        }
    }

    /**
     * 跳转百度地图
     * http://lbsyun.baidu.com/index.php?title=uri/api/android
     */
    public static void openBaiduMap(Context context, double endLat, double endLon, String endAddress) {
        if (!isAvilible(context, "com.baidu.BaiduMap")) {
            ToastUtil.show(context, context.getString(R.string.not_install_this_app));
            return;
        }
        Intent intent = new Intent();
        intent.setData(Uri.parse("baidumap://map/direction?destination=latlng:"
                + endLat + ","
                + endLon + "|addr:" + endAddress + // 终点
                "&mode=driving" + // 导航路线方式
                "&src=" + context.getPackageName()));
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent); // 启动调用
    }

    /**
     * 打开高德地图
     * https://lbs.amap.com/api/amap-mobile/guide/android/navigation
     *
     * @param context
     * @param endLat
     * @param endLon
     * @param endAddress
     */
    public static void openGaodeMap(Context context, double endLat, double endLon, String endAddress) {
        if (isAvilible(context, "com.autonavi.minimap")) {
            StringBuffer stringBuffer = new StringBuffer("androidamap://navi?sourceApplication=").append("amap");
            stringBuffer.append("&lat=").append(endLat)
                    .append("&lon=").append(endLon).append("&poiname=" + endAddress)
                    .append("&dev=").append(0);
            Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(stringBuffer.toString()));
            intent.setPackage("com.autonavi.minimap");
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } else {
            ToastUtil.show(context, context.getString(R.string.not_install_this_app));
        }
    }

    private static String b(double startLat, double startLon, double endLat, double endLon) {
        String var3 = String.format(Locale.US, "androidamap://route?sourceApplication=%s&slat=%f&slon=%f&sname=%s&dlat=%f&dlon=%f&dname=%s&dev=0&t=%d", new Object[]{R.string.app_name, startLat, startLon,
                "我的位置", endLat, endLon, "车的位置", Integer.valueOf(4)});
        return var3;
    }

    public static double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

    /**
     * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 将 GCJ-02 坐标转换成 BD-09 坐标
     *
     * @param lat
     * @param lon
     */
    public static double[] gcj02_To_Bd09(double lat, double lon) {
        double x = lon, y = lat;
        double z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * x_pi);
        double theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * x_pi);
        double tempLon = z * Math.cos(theta) + 0.0065;
        double tempLat = z * Math.sin(theta) + 0.006;
        double[] gps = {tempLat, tempLon};
        return gps;
    }

    /**
     * * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 * * 将 BD-09 坐标转换成GCJ-02 坐标 * * @param
     * bd_lat * @param bd_lon * @return
     */
    public static double[] bd09_To_Gcj02(double lat, double lon) {
        double x = lon - 0.0065, y = lat - 0.006;
        double z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * x_pi);
        double theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * x_pi);
        double tempLon = z * Math.cos(theta);
        double tempLat = z * Math.sin(theta);
        double[] gps = {tempLat, tempLon};
        return gps;
    }
}

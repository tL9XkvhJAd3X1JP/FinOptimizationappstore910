package com.fin.optimization.bean;

/**
 * 作者：WangJintao
 * 时间：2017/4/17
 * 邮箱：wangjintao1988@163.com
 */

public class LatLonPoint {
    private double wgLat;
    private double wgLon;

    public LatLonPoint() {

    }

    public LatLonPoint(double wgLat, double wgLon) {
        this.wgLat = wgLat;
        this.wgLon = wgLon;
    }

    public double getWgLat() {
        return wgLat;
    }

    public void setWgLat(double wgLat) {
        this.wgLat = wgLat;
    }

    public double getWgLon() {
        return wgLon;
    }

    public void setWgLon(double wgLon) {
        this.wgLon = wgLon;
    }
}

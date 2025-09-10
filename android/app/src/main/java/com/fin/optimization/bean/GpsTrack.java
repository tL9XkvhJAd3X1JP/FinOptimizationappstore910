package com.fin.optimization.bean;

import java.util.List;

/**
 * Created by Ryan on 2019/2/14.
 */
public class GpsTrack extends BaseBean {


    /**
     * isSuccess : true
     * code : 10000
     * message : 查询成功
     * data : [{"gpsTime":1550248861000,"longitude":116.251468,"latitude":39.879286,"speed":0,"direction":0},{"gpsTime":1550251576000,"longitude":116.251079,"latitude":39.877879,"speed":2,"direction":294},{"gpsTime":1550254086000,"longitude":116.251206,"latitude":39.878672,"speed":1,"direction":0},{"gpsTime":1550256785000,"longitude":116.251877,"latitude":39.878392,"speed":0,"direction":226},{"gpsTime":1550259501000,"longitude":116.251478,"latitude":39.878242,"speed":0,"direction":0},{"gpsTime":1550262216000,"longitude":116.252032,"latitude":39.878196,"speed":1,"direction":0},{"gpsTime":1550264933000,"longitude":116.249825,"latitude":39.878292,"speed":0,"direction":105},{"gpsTime":1550267650000,"longitude":116.250778,"latitude":39.87817,"speed":0,"direction":0},{"gpsTime":1550270383000,"longitude":116.251824,"latitude":39.878422,"speed":0,"direction":0},{"gpsTime":1550273081000,"longitude":116.249138,"latitude":39.877557,"speed":0,"direction":0},{"gpsTime":1550275800000,"longitude":116.251698,"latitude":39.879406,"speed":0,"direction":0},{"gpsTime":1550278519000,"longitude":116.252531,"latitude":39.879132,"speed":0,"direction":0},{"gpsTime":1550281168000,"longitude":116.252328,"latitude":39.878554,"speed":0,"direction":0},{"gpsTime":1550283823000,"longitude":116.249327,"latitude":39.878273,"speed":0,"direction":0},{"gpsTime":1550286499000,"longitude":116.251954,"latitude":39.878353,"speed":0,"direction":0}]
     */

    private List<DataBean> data;

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class DataBean {
        /**
         * gpsTime : 1550248861000
         * longitude : 116.251468
         * latitude : 39.879286
         * speed : 0
         * direction : 0
         */

        private long gpsTime;
        private double longitude;
        private double latitude;
        private int speed;
        private int direction;

        public long getGpsTime() {
            return gpsTime;
        }

        public void setGpsTime(long gpsTime) {
            this.gpsTime = gpsTime;
        }

        public double getLongitude() {
            return longitude;
        }

        public void setLongitude(double longitude) {
            this.longitude = longitude;
        }

        public double getLatitude() {
            return latitude;
        }

        public void setLatitude(double latitude) {
            this.latitude = latitude;
        }

        public int getSpeed() {
            return speed;
        }

        public void setSpeed(int speed) {
            this.speed = speed;
        }

        public int getDirection() {
            return direction;
        }

        public void setDirection(int direction) {
            this.direction = direction;
        }
    }
}

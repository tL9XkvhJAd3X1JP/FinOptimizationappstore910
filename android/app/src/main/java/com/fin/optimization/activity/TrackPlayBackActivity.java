package com.fin.optimization.activity;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.text.format.Time;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.TimePicker;

import com.android.volley.VolleyError;
import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.map.Polyline;
import com.baidu.mapapi.map.PolylineOptions;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.overlayutil.OverlayManager;
import com.fin.optimization.R;
import com.fin.optimization.adapter.SpeedTypeAdapter;
import com.fin.optimization.bean.GpsTrack;
import com.fin.optimization.constant.Constants;
import com.fin.optimization.constant.ErrorCode;
import com.fin.optimization.network.NetWorkAccess;
import com.fin.optimization.utils.AppUtils;
import com.fin.optimization.utils.DateUtils;
import com.fin.optimization.utils.Logger;
import com.fin.optimization.utils.ToastUtil;
import com.fin.optimization.widget.WiseLinkDialog;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import library.slidinguppanel.SlidingUpPanelLayout;

/**
 * 作者：WangJintao
 * 时间：2017/3/28
 * 邮箱：wangjintao1988@163.com
 * 轨迹回放界面，Y08
 */

public class TrackPlayBackActivity extends BaseActivity implements BDLocationListener {

    private static final String TAG = TrackPlayBackActivity.class.getSimpleName();
    @BindView(R.id.bmapView)
    MapView mMapView;
    private BaiduMap mBaiduMap;
    //    private DatePickerDialog dataPick;
    private Calendar mDateStart;
    private Calendar mDateEnd;
    @BindView(R.id.tv_start_date)
    TextView startDateView;
    @BindView(R.id.tv_end_date)
    TextView endDateView;
    @BindView(R.id.tv_start_time)
    TextView startTimeView;
    @BindView(R.id.tv_end_time)
    TextView endTimeView;

    private int dateFlag = 0;
    private int timeFlag = 0;

    private Time time;

    private Polyline mPolyline;//路线
    private Marker mMoveMarker;//小车
    private int nowNum = 0;//小车移动到的点
    private List<LatLng> linePoints;//所有的点
    private Handler mHandler;

    // 通过设置间隔时间和距离可以控制速度和图标移动的距离
    private static int TIME_INTERVAL = 50;
    private static double DISTANCE = 0.00005;

    private boolean isMove = false;
    @BindView(R.id.tv_sn_code)
    TextView snCodeView;
    @BindView(R.id.mSlidingLayout)
    SlidingUpPanelLayout mSlidingLayout;

    private Map<String, String> map;

    private LocationClient mLocationClient = null;

    @BindView(R.id.tv_speed_choise)
    TextView speedTypeView;
    private boolean isLine = false;//是否有路线

    private final float DEFULT_ZOOM = 14.0f;
    private BitmapDescriptor carBg;
    private BitmapDescriptor bitmapEmpty;
    private BitmapDescriptor trackStartBg;
    private BitmapDescriptor trackEndBg;
    private Marker mStartMarker;
    private Marker mEndMarker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_track_play_back);
        setTitle("轨迹回放");
        mBaiduMap = mMapView.getMap();
        mBaiduMap.animateMapStatus(MapStatusUpdateFactory.zoomTo(15));
        mMapView.showZoomControls(false);
        mDateStart = Calendar.getInstance();
        mDateEnd = Calendar.getInstance();
        time = new Time();
        map = new HashMap<String, String>();
        linePoints = new ArrayList<>();
        initViews();
        mHandler = new Handler(Looper.getMainLooper());
//        initLocation();
//        startLocation();
    }


    @Override
    protected void onResume() {
        super.onResume();
        if (mMapView != null) {
            mMapView.onResume();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
//        stopLocation();
        if (mMapView != null) {
            mMapView.onPause();
        }

    }

    @Override
    protected void onDestroy() {
        progressDialogCanceled();
        mHandler.removeCallbacksAndMessages(null);
        isMove = false;
        super.onDestroy();
        if (carBg != null) {
            carBg.recycle();
        }
        if (bitmapEmpty != null) {
            bitmapEmpty.recycle();
        }

        if (trackStartBg != null) {
            trackStartBg.recycle();
        }

        if (trackEndBg != null) {
            trackEndBg.recycle();
        }

        if (mStartMarker != null) {
            mStartMarker.remove();
        }

        if (mEndMarker != null) {
            mEndMarker.remove();
        }

        if (mBaiduMap != null) {
            mBaiduMap.clear();
        }
        if (mMapView != null) {
            mMapView.onDestroy();
        }
    }

    @OnClick(R.id.rl_start_date)
    void clickStartDate() {
        dateFlag = 0;
        showDateDialog();
    }

    @OnClick(R.id.rl_end_date)
    void clickEndDate() {
        dateFlag = 1;
        showDateDialog();
    }

    private void showDateDialog() {
        if (mDateEnd == null) {
            mDateEnd = Calendar.getInstance();
        }

        if (mDateStart == null) {
            mDateStart = Calendar.getInstance();
        }

        Calendar mDate = (dateFlag == 0) ? mDateStart : mDateEnd;

        DatePickerDialog.OnDateSetListener dateSetListener = new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(android.widget.DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                if (AppUtils.isFastDoubleClick(view.getId())) {
                    return;
                }
                if (mDateEnd == null) {
                    mDateEnd = Calendar.getInstance();
                }

                if (mDateStart == null) {
                    mDateStart = Calendar.getInstance();
                }
                if (dateFlag == 0) {
                    mDateStart.set(year, monthOfYear, dayOfMonth);
                    startDateView.setText(year + "-" + (monthOfYear + 1) + "-" + dayOfMonth);
                } else if (dateFlag == 1) {
                    mDateEnd.set(year, monthOfYear, dayOfMonth);
                    endDateView.setText(year + "-" + (monthOfYear + 1) + "-" + dayOfMonth);
                }

            }
        };
        DatePickerDialog datePickerDialog;
        if (android.os.Build.VERSION.SDK_INT >= 21) {
            datePickerDialog = new DatePickerDialog(this, R.style.TrackPlayBackTheme, dateSetListener,
                    mDate.get(Calendar.YEAR), mDate.get(Calendar.MONTH), mDate.get(Calendar.DAY_OF_MONTH));
        } else {
            datePickerDialog = new DatePickerDialog(this, dateSetListener,
                    mDate.get(Calendar.YEAR), mDate.get(Calendar.MONTH), mDate.get(Calendar.DAY_OF_MONTH));
        }

        datePickerDialog.show();

    }

    private void showTimePicker() {
        time.setToNow();
        TimePickerDialog.OnTimeSetListener onTimeSetListener = new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                if (AppUtils.isFastDoubleClick(view.getId())) {
                    return;
                }
                StringBuffer timeBuffer = new StringBuffer();
                if (minute < 10 && hourOfDay < 10) {
                    timeBuffer.append("0").append(hourOfDay).append(":0").append(minute);
                } else if (minute < 10 && hourOfDay >= 10) {
                    timeBuffer.append(hourOfDay).append(":0").append(minute);
                } else if (minute >= 10 && hourOfDay < 10) {
                    timeBuffer.append("0").append(hourOfDay).append(":").append(minute);
                } else {
                    timeBuffer.append(hourOfDay).append(":").append(minute);
                }
                if (timeFlag == 0) {
                    startTimeView.setText(timeBuffer.toString());
                } else if (timeFlag == 1) {
                    endTimeView.setText(timeBuffer.toString());
                }
            }

        };
        TimePickerDialog dialog;
        if (android.os.Build.VERSION.SDK_INT >= 21) {
            dialog = new TimePickerDialog(TrackPlayBackActivity.this, R.style.TrackPlayBackTheme,
                    onTimeSetListener, time.hour, time.minute, true);
        } else {
            dialog = new TimePickerDialog(TrackPlayBackActivity.this,
                    onTimeSetListener, time.hour, time.minute, true);
        }
        dialog.show();

    }

    @OnClick(R.id.rl_start_time)
    void clickStartTime() {
        timeFlag = 0;
        showTimePicker();
    }

    @OnClick(R.id.rl_end_time)
    void clickEndTime() {
        timeFlag = 1;
        showTimePicker();
    }

    private void initViews() {
        time.setToNow();
        snCodeView.setText("轨迹回放设置");
        startDateView.setText(time.year + "-" + (time.month + 1) + "-" + time.monthDay);
        endDateView.setText(time.year + "-" + (time.month + 1) + "-" + time.monthDay);
        int hourOfDay = time.hour;
        int minute = time.minute;
        int second = time.second;
        StringBuffer timeBuffer = new StringBuffer();
        if (minute < 10 && hourOfDay < 10) {
            timeBuffer.append("0").append(hourOfDay).append(":0").append(minute);
        } else if (minute < 10 && hourOfDay >= 10) {
            timeBuffer.append(hourOfDay).append(":0").append(minute);
        } else if (minute >= 10 && hourOfDay < 10) {
            timeBuffer.append("0").append(hourOfDay).append(":").append(minute);
        } else {
            timeBuffer.append(hourOfDay).append(":").append(minute);
        }
//        if (second < 10) {
//            timeBuffer.append(":0").append(second);
//        } else {
//            timeBuffer.append(":").append(second);
//        }
        startTimeView.setText("00:00");
        endTimeView.setText(timeBuffer.toString());
    }

    /**
     * 在地图上画路线
     *
     * @param polylines
     */
    private void drawPolyLine(List<LatLng> polylines) {
        if (polylines != null) {
            int size = polylines.size();
            Logger.e("PolyLineSize", String.valueOf(size));
            if (carBg == null) {
                carBg = BitmapDescriptorFactory.fromResource(R.drawable.track_gps_car);
            }

            if (size >= 2) {
                if (mPolyline != null) {
                    mPolyline.remove();
                }
                if (mMoveMarker != null) {
                    mMoveMarker.remove();
                }

                if (mStartMarker != null) {
                    mStartMarker.remove();
                }

                if (mEndMarker != null) {
                    mEndMarker.remove();
                }

                PolylineOptions polylineOptions = new PolylineOptions().points(polylines).width(7).color(Color.RED);
                mPolyline = (Polyline) mBaiduMap.addOverlay(polylineOptions);
                OverlayOptions markerOptions;
                LatLng startP = polylines.get(0);
                LatLng endP = polylines.get(size - 1);
                markerOptions = new MarkerOptions().icon(carBg).position(polylines.get(0));
                mMoveMarker = (Marker) mBaiduMap.addOverlay(markerOptions);
                isLine = true;

                if (trackStartBg == null) {
                    trackStartBg = BitmapDescriptorFactory.fromResource(R.drawable.track_gps_start);
                }

                markerOptions = new MarkerOptions().icon(trackStartBg).position(startP);
                mStartMarker = (Marker) mBaiduMap.addOverlay(markerOptions);

                if (trackEndBg == null) {
                    trackEndBg = BitmapDescriptorFactory.fromResource(R.drawable.track_gps_end);
                }

                markerOptions = new MarkerOptions().icon(trackEndBg).position(endP);
                mEndMarker = (Marker) mBaiduMap.addOverlay(markerOptions);

                setInflexionPoint(polylines, size);

            } else if (size == 1) {
                if (mPolyline != null) {
                    mPolyline.remove();
                }
                if (mMoveMarker != null) {
                    mMoveMarker.remove();
                }

                if (mStartMarker != null) {
                    mStartMarker.remove();
                }

                if (mEndMarker != null) {
                    mEndMarker.remove();
                }

                OverlayOptions markerOptions = new MarkerOptions().flat(true).anchor(0.5f, 0.5f)
                        .icon(carBg).
                                position(polylines.get(0));
                mMoveMarker = (Marker) mBaiduMap.addOverlay(markerOptions);
                isLine = true;

                setMapCenterAndZoom(polylines.get(0));
            }

        }
    }

    private void setInflexionPoint(List<LatLng> polylines, int pointSize) {

        new Thread(new Runnable() {
            @Override
            public void run() {
                int mark = 1;
                if (pointSize < 100) {
                    mark = 1;
                } else if (pointSize < 1000) {
                    mark = 2;
                } else {
                    mark = pointSize / 5;
                }
                OverlayOptions option;
                List<OverlayOptions> overlayOptions = new ArrayList<>();
                if (bitmapEmpty == null) {
                    bitmapEmpty = BitmapDescriptorFactory.fromResource(R.drawable.empty);
                }
                for (int i = 0; i < pointSize; i++) {
                    if (i == 1) {
                        option = new MarkerOptions().position(polylines.get(i)).icon(bitmapEmpty);
                        overlayOptions.add(option);
                    } else if (i == pointSize - 1) {
                        option = new MarkerOptions().position(polylines.get(i)).icon(bitmapEmpty);
                        overlayOptions.add(option);
                    } else if (i % mark == 0) {
                        overlayOptions.add(new MarkerOptions().position(polylines.get(i)).icon(bitmapEmpty));
                    }
                }

                OverlayManager manager = new OverlayManager(mBaiduMap) {

                    @Override
                    public boolean onMarkerClick(Marker arg0) {
                        return false;
                    }

                    @Override
                    public List<OverlayOptions> getOverlayOptions() {
                        return overlayOptions;
                    }

                    @Override
                    public boolean onPolylineClick(Polyline arg0) {
                        return false;
                    }
                };

                manager.addToMap();
                manager.zoomToSpan();
            }
        }).start();
    }

    /**
     * 设置地图中心点和缩放级别
     */
    private void setMapCenterAndZoom(LatLng latLng) {
        if (latLng != null) {
            MapStatus.Builder builder = new MapStatus.Builder();
            builder.target(latLng);
            builder.zoom(DEFULT_ZOOM);
            mBaiduMap.setMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));
        }
    }


    /**
     * 根据两点算取图标转的角度
     */
    private double getAngle(LatLng fromPoint, LatLng toPoint) {
        double slope = getSlope(fromPoint, toPoint);
        if (slope == Double.MAX_VALUE) {
            if (toPoint.latitude > fromPoint.latitude) {
                return 0;
            } else {
                return 180;
            }
        }
        float deltAngle = 0;
        if ((toPoint.latitude - fromPoint.latitude) * slope < 0) {
            deltAngle = 180;
        }
        double radio = Math.atan(slope);
        double angle = 180 * (radio / Math.PI) + deltAngle - 90;
        return angle;
    }


    /**
     * 算斜率
     */
    private double getSlope(LatLng fromPoint, LatLng toPoint) {
        if (toPoint.longitude == fromPoint.longitude) {
            return Double.MAX_VALUE;
        }
        double slope = ((toPoint.latitude - fromPoint.latitude) / (toPoint.longitude - fromPoint.longitude));
        return slope;

    }


    private void move(final int startNum) {
        isMove = true;
        new Thread(new Runnable() {
            @Override
            public void run() {
                if (linePoints != null) {
                    int size = linePoints.size();
                    for (int i = startNum; (i < size - 1) && isMove; i++) {
                        nowNum = i + 1;
                        final LatLng startPoint = linePoints.get(i);
                        final LatLng endPoint = linePoints.get(i + 1);
                        if (mMoveMarker != null) {
                            mMoveMarker
                                    .setPosition(startPoint);
                        }
                        if (startPoint.latitude == endPoint.longitude && startPoint.longitude == endPoint.longitude) {
                            try {
                                Thread.sleep(TIME_INTERVAL);
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                            break;
                        }
                        double slope = getSlope(startPoint, endPoint);
                        // 是不是正向的标示
                        boolean isReverse = (startPoint.latitude > endPoint.latitude);
//
                        double intercept = getInterception(slope, startPoint);

                        double xMoveDistance = isReverse ? getXMoveDistance(slope) :
                                -1 * getXMoveDistance(slope);

                        for (double j = startPoint.latitude; !((j > endPoint.latitude) ^ isReverse);
                             j = j - xMoveDistance) {

                            if (!isMove) {
                                break;
                            }
                            LatLng latLng = null;
                            if (slope == Double.MAX_VALUE) {
                                latLng = new LatLng(j, startPoint.longitude);
                            } else {
                                latLng = new LatLng(j, (j - intercept) / slope);
                            }

                            final LatLng finalLatLng = latLng;
                            if (finalLatLng == null || finalLatLng.latitude == 0 || finalLatLng.longitude == 0) {
                                nowNum = nowNum + 1;
                                break;
                            }
                            System.out.println("------------pos:" + nowNum);
                            mHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    if (mMapView == null || mMoveMarker == null) {
                                        return;
                                    }
                                    try {
                                        if (mMoveMarker != null) {
                                            mMoveMarker.setPosition(finalLatLng);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            });
                            try {
                                Thread.sleep(TIME_INTERVAL);
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    isMove = false;
                }

            }
        }).start();

    }

    /**
     * 根据点和斜率算取截距
     */
    private double getInterception(double slope, LatLng point) {

        double interception = point.latitude - slope * point.longitude;
        return interception;
    }


    /**
     * 计算x方向每次移动的距离
     */
    private double getXMoveDistance(double slope) {
        if (slope == Double.MAX_VALUE) {
            return DISTANCE;
        }
        return Math.abs((DISTANCE * slope) / Math.sqrt(1 + slope * slope));
    }

    /**
     * 开始回放
     */
    @OnClick(R.id.rl_start_move)
    void startMove() {
        if (!isLine) {
            ToastUtil.show(getApplicationContext(), "请先查询轨迹路线");
            return;
        }
        mSlidingLayout.setPanelState(SlidingUpPanelLayout.PanelState.COLLAPSED);
        if (isMove) {
            ToastUtil.show(getApplicationContext(), "正在回放");
            return;
        }
        move(0);
    }

    //暂停
    @OnClick(R.id.tv_stop_move)
    void stopMove() {
        isMove = false;
    }

    //继续
    @OnClick(R.id.tv_continue_move)
    void continueMove() {
        if (isMove) {
            ToastUtil.show(getApplicationContext(), "正在回放");
            return;
        }
        move(nowNum);
    }

    @OnClick(R.id.tv_hide)
    void hideControlView() {
        mSlidingLayout.setPanelState(SlidingUpPanelLayout.PanelState.COLLAPSED);
    }

    void hideLineAndCar() {
        stopMove();
        isLine = false;
        if (mPolyline != null) {
            mPolyline.remove();
        }
        if (mMoveMarker != null) {
            mMoveMarker.remove();
        }
    }

    private void getLoc(String startTime, String endTime) {
        if (!isNetworkAvailable()) {
            return;
        }
        map.clear();
        map.put(Constants.GPStrack.STARTTIME, startTime);
        map.put(Constants.GPStrack.ENDTIME, endTime);
        map.put(Constants.GPStrack.IDC, getIntent().getStringExtra("object"));
//        map.put(Constants.GPStrack.BINDINGDATE, UserData.getInstance().getUser().getBindingDate());
        showProgressDialog();
        NetWorkAccess
                .getInstance()
                .byPost(Constants.GPStrack.GPS_TRACK_API, GpsTrack.class, TAG, map,
                        new NetWorkAccess.NetWorkAccessListener() {
                            @Override
                            public <T> void onAccessComplete(boolean success, T response, VolleyError error, String flag) {
                                closeProgressDialog();
                                if (success) {
                                    if (response instanceof GpsTrack) {
                                        GpsTrack gpsTrack = (GpsTrack) response;
                                        if (TextUtils.equals(ErrorCode.SUCCESS, gpsTrack.getCode())) {
                                            List<GpsTrack.DataBean> data = gpsTrack.getData();
                                            if (data != null && !data.isEmpty()) {
                                                linePoints.clear();
                                                int size = data.size();
                                                for (int i = 0; i < size; i++) {
                                                    GpsTrack.DataBean dataBean = data.get(i);
                                                    linePoints.add(new LatLng(dataBean.getLatitude(), dataBean.getLongitude()));
                                                }
                                                drawPolyLine(linePoints);
                                            } else {
                                                ToastUtil.show(getApplicationContext(), "无任何行驶记录!");
                                                hideLineAndCar();
                                            }

                                        } else {
                                            hideLineAndCar();
                                            ToastUtil.show(TrackPlayBackActivity.this, gpsTrack.getMessage());
                                        }
                                    }

                                }
                            }
                        });
    }


    @Override
    protected void progressDialogCanceled() {
        super.progressDialogCanceled();
        NetWorkAccess.getInstance().cancel(TAG);
    }

    @OnClick(R.id.tv_search)
    void search() {
        if (isMove) {
            ToastUtil.show(this, "正在回放");
            return;
        }
        String startTime = startDateView.getText().toString() + " " + startTimeView.getText().toString();
        String endTime = endDateView.getText().toString() + " " + endTimeView.getText().toString();
        try {
            long start = DateUtils.dateToStamp(startTime);
            long end = DateUtils.dateToStamp(endTime);
            if (start >= end) {
                ToastUtil.show(getApplicationContext(), "开始时间不能晚于结束时间");
                return;
            }
            long now = System.currentTimeMillis();
            if (end >= now) {
                ToastUtil.show(getApplicationContext(), "结束时间不能晚于当前时间");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        getLoc(startTime, endTime);

    }

//    private void initLocation() {
//        mLocationClient = new LocationClient(getApplicationContext());
//        mLocationClient.registerLocationListener(this);
//        LocationClientOption option = new LocationClientOption();
//        option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);//可选，默认高精度，设置定位模式，高精度，低功耗，仅设备
//        option.setCoorType("bd09ll");
//        option.setScanSpan(0);//可选，默认0，即仅定位一次，设置发起定位请求的间隔需要大于等于1000ms才是有效的
//        option.setOpenGps(true);//可选，默认false,设置是否使用gps
//        option.setIsNeedAddress(false);
//        option.setLocationNotify(false);//可选，默认false，设置是否当GPS有效时按照1S/1次频率输出GPS结果
//        mLocationClient.setLocOption(option);
//    }


    @Override
    public void onReceiveLocation(BDLocation bdLocation) {
        if (bdLocation != null) {
            MapStatus.Builder builder = new MapStatus.Builder();
            builder.target(new LatLng(bdLocation.getLatitude(), bdLocation.getLongitude()));
            builder.zoom(DEFULT_ZOOM);
            mBaiduMap.setMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));
        }

    }


//    private void startLocation() {
//        mBaiduMap.setMyLocationEnabled(true);
//        mLocationClient.registerLocationListener(this);
//        mLocationClient.start();
//    }
//
//    private void stopLocation() {
//        if (mLocationClient != null) {
//            mLocationClient.stop();
//        }
//        if (mBaiduMap != null) {
//            mBaiduMap.setMyLocationEnabled(false);
//        }
//        if (mLocationClient != null) {
//            mLocationClient.unRegisterLocationListener(this);
//        }
//    }

    @OnClick(R.id.rl_speed_choise)
    void choiseSpeed() {
        showChoiseSpeedDialog();
    }

    private void showChoiseSpeedDialog() {
        final List<String> speedTypes = new ArrayList<>();
        speedTypes.add(getString(R.string.speed_fast));
        speedTypes.add(getString(R.string.speed_middle));
        speedTypes.add(getString(R.string.speed_slow));
        final WiseLinkDialog historyDialog = new WiseLinkDialog(this);
        ListView listView = historyDialog.getListView();
        final SpeedTypeAdapter historyAdapter = new SpeedTypeAdapter(this, speedTypes);
        listView.setAdapter(historyAdapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                speedTypeView.setText(speedTypes.get(i));
                switch (i) {
                    case 0:
                        DISTANCE = 0.00008;
                        TIME_INTERVAL = 30;
                        break;
                    case 1:
                        DISTANCE = 0.00005;
                        TIME_INTERVAL = 50;
                        break;
                    case 2:
                        DISTANCE = 0.00002;
                        TIME_INTERVAL = 80;
                        break;
                }
                historyDialog.dismiss();
            }
        });
        historyDialog.show();
    }

}

package com.fin.optimization.rnmodle;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;

import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.district.DistrictResult;
import com.baidu.mapapi.search.district.DistrictSearch;
import com.baidu.mapapi.search.district.DistrictSearchOption;
import com.baidu.mapapi.search.district.OnGetDistricSearchResultListener;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.JSApplicationIllegalArgumentException;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.fin.optimization.AppManager;
import com.fin.optimization.MainApplication;
import com.fin.optimization.activity.MyReactActivity;
import com.fin.optimization.bean.ResourceBean;
import com.fin.optimization.bean.ResourceData;
import com.fin.optimization.constant.Constants;
import com.fin.optimization.data.UrlData;
import com.fin.optimization.utils.AppUtils;
import com.fin.optimization.utils.DeviceUtils;
import com.fin.optimization.utils.FileMD5Helper;
import com.fin.optimization.utils.MapUtils;
import com.fin.optimization.utils.MyPreferenceManager;
import com.fin.optimization.utils.ToastUtil;
import com.fin.optimization.widget.DownLoadDialog;
import com.fin.optimization.widget.WiseLinkDialog;
import com.google.gson.Gson;

import java.util.List;

import javax.annotation.Nonnull;

/**
 * Created by Ryan on 2019/3/28.
 */
public class AndroidUtils extends ReactContextBaseJavaModule {

    public AndroidUtils(@Nonnull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Nonnull
    @Override
    public String getName() {
        return Constants.ReactName.ANDROID_UTILS;
    }

    @ReactMethod
    public void finishActivity() {
        AppManager.getAppManager().finishActivity();
    }

    @ReactMethod
    public void startActivity(String name, String params) {
        try {
            Activity currentActivity = getCurrentActivity();
            if (null != currentActivity) {
                Class toActivity = Class.forName(name);
                Intent intent = new Intent(currentActivity, toActivity);
                intent.putExtra("object", params);
                currentActivity.startActivity(intent);
            }
        } catch (Exception e) {
            throw new JSApplicationIllegalArgumentException(
                    "不能打开Activity : " + e.getMessage());
        }
    }

    @ReactMethod
    public void startReactActivity(String name, String params) {
        try {
            Activity currentActivity = getCurrentActivity();
            if (null != currentActivity) {
                Intent intent = new Intent(currentActivity, MyReactActivity.class);
                Bundle bundle = new Bundle();
                bundle.putString("object", params);
                intent.putExtras(bundle);
                MainApplication.getApp().setReactModuleName(name);
                currentActivity.startActivity(intent);
            }
        } catch (Exception e) {
            throw new JSApplicationIllegalArgumentException(
                    "不能打开Activity : " + e.getMessage());
        }
    }

    @ReactMethod
    public void goToPlaceWith(String mapName, String carLatitude, String carLongitude, String carAddress) {

        try {
            double dCarLatitude = Double.parseDouble(carLatitude);
            double dCarLongitude = Double.parseDouble(carLongitude);
            if (TextUtils.equals(mapName, "百度地图")) {
                MapUtils.openBaiduMap(getReactApplicationContext(), dCarLatitude, dCarLongitude, carAddress);
            } else if (TextUtils.equals(mapName, "高德地图")) {
                double[] latLonPoint = MapUtils.bd09_To_Gcj02(dCarLatitude, dCarLongitude);
                MapUtils.openGaodeMap(getReactApplicationContext(), latLonPoint[0], latLonPoint[1], carAddress);
            } else if (TextUtils.equals(mapName, "腾讯地图")) {
                double[] latLonPoint2 = MapUtils.bd09_To_Gcj02(dCarLatitude, dCarLongitude);
                MapUtils.openTencentMap(getReactApplicationContext(), String.valueOf(latLonPoint2[0]), String.valueOf(latLonPoint2[1]));
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            ToastUtil.show(MainApplication.getApp(), "没有获取到位置，稍后再试！");
        } catch (Exception e) {
            e.printStackTrace();
            ToastUtil.show(MainApplication.getApp(), "路径规划失败，稍后再试！");
        }

    }

    /**
     * 获取地方边界点
     */
    @ReactMethod
    public void getAreaEdgePoints(String province, Callback success, Callback error) {
        DistrictSearch mDistrictSearch = DistrictSearch.newInstance();//初始化行政区检索
        mDistrictSearch.setOnDistrictSearchListener(new OnGetDistricSearchResultListener() {

            @Override
            public void onGetDistrictResult(DistrictResult districtResult) {
                if (null != districtResult && districtResult.error == SearchResult.ERRORNO.NO_ERROR) {
                    //获取边界坐标点，并展示
                    if (districtResult.getPolylines() == null || districtResult.getPolylines().isEmpty()) {
                        error.invoke("规划错误！");
                    } else {
                        List<List<LatLng>> polylines = districtResult.getPolylines();
                        success.invoke(new Gson().toJson(polylines));
                    }
                } else {
                    error.invoke("规划错误！");
                }
                mDistrictSearch.destroy();
            }
        });//设置回调监听

        DistrictSearchOption districtSearchOption = new DistrictSearchOption();
        districtSearchOption.cityName(province);//检索城市名称
        mDistrictSearch.searchDistrict(districtSearchOption);//请求行政区数据
    }


    @ReactMethod
    public void saveLoginState(boolean hasLogin) {
        new MyPreferenceManager().saveLoginState(hasLogin);
    }

    @ReactMethod
    public void getUrl(Callback callback) {
        callback.invoke(new Gson().toJson(UrlData.getInstance().getUrl()));
    }


    @ReactMethod
    public void updateAppWithUrl(String url) {
        if (getCurrentActivity() != null) {
            WiseLinkDialog wiseLinkDialog = new WiseLinkDialog(getCurrentActivity());
            wiseLinkDialog.setTitle("升级提示");
            wiseLinkDialog.setMessage("是否升级？");
            wiseLinkDialog.setCanDismissByKeyBack(false);
            wiseLinkDialog.setOkButton("升级", new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (getCurrentActivity() != null) {
                        getCurrentActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                ResourceBean.DataBean dataBean = new ResourceBean.DataBean();
                                dataBean.setClientDownUrl(url);
                                DownLoadDialog mDialog = new DownLoadDialog(getCurrentActivity(), dataBean);
                                mDialog.show();
                            }
                        });
                    }
                }
            });
            wiseLinkDialog.setCancleButton(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                }
            });
            wiseLinkDialog.setCanceledOnTouchOutside(false);
            wiseLinkDialog.show();

        }
    }

    @ReactMethod
    public void finishAllActivityExcludeLast() {
        AppManager.getAppManager().finishAllActivityExcludeLast();
    }

    @ReactMethod
    public void saveUrl(String data) {
        ResourceData resourceData = new Gson().fromJson(data, ResourceData.class);
        ResourceBean.DataBean dataEntity = new ResourceBean.DataBean();
        dataEntity.setBusinessInterfaceAddress(resourceData.getBusinessInterfaceAddress());
        dataEntity.setBusinessInterfaceAddress_ssl(resourceData.getBusinessInterfaceAddress_ssl());
        dataEntity.setFileInterfaceAddress(resourceData.getFileInterfaceAddress());
        UrlData.getInstance().saveUrl(dataEntity);
    }

    @ReactMethod
    public void getPhoneImei(Callback okCallback) {
        okCallback.invoke(DeviceUtils.getPhoneIMEI(getReactApplicationContext()));
    }

    @ReactMethod
    public void setRequestToken(String token) {
        new MyPreferenceManager().saveRequestToken(token);
    }

    @ReactMethod
    public void openPremissionSetting() {
        AppUtils.openApplicationSettings(getReactApplicationContext());
    }

    @ReactMethod
    public void finishAllActivity() {
        AppManager.getAppManager().finishAllActivity();
    }

    @ReactMethod
    public void test() {
//        HashMap<String, String> map = new HashMap<>();
//        map.put("platenumber", "的");
//        map.put("pageRows", "10");
//        map.put("username", "admin");
//        NetWorkAccess.getInstance().byPost("/interfaceController/getVehicleScreening", UserBean.class, "Test", map, new NetWorkAccess.NetWorkAccessListener() {
//            @Override
//            public <T> void onAccessComplete(boolean success, T response, VolleyError error, String flag) {
//
//            }
//        });
        System.out.println("---------------java:" + FileMD5Helper.md5("095699ceff0240919b61ed1f92a5ffe81558064074817pageRows10platenumber的usernameadmine10adc3949ba59abbe56e057f20f888e"));
    }

    @ReactMethod
    public void exitApp() {
        System.exit(0);
    }
}

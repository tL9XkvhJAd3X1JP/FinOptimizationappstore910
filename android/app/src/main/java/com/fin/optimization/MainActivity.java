package com.fin.optimization;

import android.os.Build;
import android.os.Bundle;

import com.fin.optimization.activity.BaseReactActivity;
import com.fin.optimization.constant.Constants;

import javax.annotation.Nullable;

public class MainActivity extends BaseReactActivity {
    private static final String TAG = MainActivity.class.getSimpleName();

//    private static final String TAG = MainActivity.class.getSimpleName();
//    @BindView(R.id.viewpager)
//    ViewPager viewpager;
//    @BindView(R.id.tv_monitor)
//    TextView tvMonitor;//监控
//    @BindView(R.id.tv_warning)
//    TextView tvWarning;//预警
//    @BindView(R.id.tv_mine)
//    TextView tvMine;//我的
//
//    private List<Fragment> list = new ArrayList<>();
//    private TabFragmentPagerAdapter adapter;
//    private MyPagerChangeListener myPagerChangeListener;
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_main);
//        initView();
//    }
//
//    private void initView() {
//        setTitle("预警");
//        setLeftImageView(R.drawable.checked);
//        setRightImageView(R.drawable.checked);
//        myPagerChangeListener = new MyPagerChangeListener();
//        viewpager.addOnPageChangeListener(myPagerChangeListener);
//        List<Fragment> fragments = getSupportFragmentManager().getFragments();
//        if (fragments == null || fragments.isEmpty()) {
//            list.add(new MonitorFragment());
//            list.add(new WarningFragment());
//        } else {
//            for (Fragment fragment : fragments) {
//                if (fragment instanceof BaseFragment) {
//                    list.add(fragment);
//                }
//            }
//        }
//        adapter = new TabFragmentPagerAdapter(getSupportFragmentManager(), list);
//        viewpager.setAdapter(adapter);
//        viewpager.setCurrentItem(1);
//        tvMonitor.setBackgroundColor(Color.TRANSPARENT);
//        tvWarning.setBackgroundColor(Color.RED);
//    }
//
//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        viewpager.removeOnPageChangeListener(myPagerChangeListener);
//        list.clear();
//    }
//
//    /**
//     * 设置一个ViewPager的侦听事件，当左右滑动ViewPager时菜单栏被选中状态跟着改变
//     */
//    public class MyPagerChangeListener implements ViewPager.OnPageChangeListener {
//
//        @Override
//        public void onPageScrollStateChanged(int arg0) {
//        }
//
//        @Override
//        public void onPageScrolled(int arg0, float arg1, int arg2) {
//        }
//
//        @Override
//        public void onPageSelected(int arg0) {
//            switch (arg0) {
//                case 0:
//                    tvMonitor.setBackgroundColor(Color.RED);
//                    tvWarning.setBackgroundColor(Color.TRANSPARENT);
//                    break;
//                case 1:
//                    tvMonitor.setBackgroundColor(Color.TRANSPARENT);
//                    tvWarning.setBackgroundColor(Color.RED);
//                    break;
//            }
//        }
//    }
//
//    @OnClick({R.id.tv_monitor, R.id.tv_warning, R.id.tv_mine, R.id.fl_left, R.id.fl_right})
//    void onViewClick(View view) {
//        switch (view.getId()) {
//            case R.id.tv_monitor:
//                viewpager.setCurrentItem(0);
//                tvMonitor.setBackgroundColor(Color.RED);
//                tvWarning.setBackgroundColor(Color.TRANSPARENT);
//                break;
//            case R.id.tv_warning:
//                viewpager.setCurrentItem(1);
//                tvMonitor.setBackgroundColor(Color.TRANSPARENT);
//                tvWarning.setBackgroundColor(Color.RED);
//                break;
//            case R.id.tv_mine:
////                startActivity(new Intent(getApplicationContext(), PersionCenterActivity.class));
////                startActivity(new Intent(getApplicationContext(), CarArchivesActivity.class));
////                startActivity(new Intent(getApplicationContext(), GpsSetActivity.class));
////                startActivity(new Intent(getApplicationContext(), WarnDealActivity.class));
//                break;
//            case R.id.fl_left:
//                break;
//            case R.id.fl_right:
//                break;
//        }
//    }
//
//    @Override
//    public void onClick(View v) {
//    }


    @Nullable
    @Override
    protected String getMainComponentName() {
        return Constants.ReactName.MAIN;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            SplashScreen.show(this, true);//显示Dialog
        }
        super.onCreate(savedInstanceState);
    }

}

package com.finoptimization.fragment;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.finoptimization.utils.Logger;

/**
 * Created by Ryan on 2019/3/25.
 */
public class BaseFragment extends Fragment {


//    private static final String TAG = BaseFragment.class.getSimpleName();
    private final String TAG = getClass().getSimpleName();

    /**
     * 设置Fragment可见或者不可见时会调用此方法。在该方法里面可以通过调用
     * getUserVisibleHint()获得Fragment的状态是可见还是不可见的，如果可见则进行懒加载操作。
     *
     * @param isVisibleToUser
     */
    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        Logger.e(TAG, "----------------------setUserVisibleHint:"+isVisibleToUser);
    }

    /**
     * 执行该方法时，Fragment与Activity已经完成绑定，该方法有一个
     * Activity类型的参数，代表绑定的Activity，这时候你可以执行诸如mActivity = activity的操作。
     *
     * @param context
     */
    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        Logger.e(TAG, "----------------------onAttach");
    }

    /**
     * 初始化Fragment。可通过参数savedInstanceState获取之前保存的值。
     *
     * @param savedInstanceState
     */
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Logger.e(TAG, "----------------------onCreate");
    }


    /**
     * 初始化Fragment的布局。加载布局和findViewById的操作通常在此函数内完成，但是不建议执行耗时的操作，比如读取数据库数据列表。
     *
     * @param inflater
     * @param container
     * @param savedInstanceState
     * @return
     */
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        Logger.e(TAG, "----------------------onCreateView");
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    /**
     * 执行该方法时，与Fragment绑定的Activity的onCreate方法已经执行完成并返回，在该方法内可以进行与
     * Activity交互的UI操作，所以在该方法之前Activity的onCreate方法并未执行完成，如果提前进行交互操作，会引发空指针异常。
     *
     * @param savedInstanceState
     */
    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        Logger.e(TAG, "----------------------onActivityCreated");
    }

    /**
     * 执行该方法时，Fragment由不可见变为可见状态。
     */
    @Override
    public void onStart() {
        super.onStart();
        Logger.e(TAG, "----------------------onStart");
    }

    /**
     * 执行该方法时，Fragment处于活动状态，用户可与之交互。
     */
    @Override
    public void onResume() {
        super.onResume();
        Logger.e(TAG, "----------------------onResume");
    }

    /**
     * 执行该方法时，Fragment处于暂停状态，但依然可见，用户不能与之交互。
     */
    @Override
    public void onPause() {
        super.onPause();
        Logger.e(TAG, "----------------------onPause");
    }

    /**
     * 保存当前Fragment的状态。该方法会自动保存Fragment的状态，比如EditText键入的文
     * 本，即使Fragment被回收又重新创建，一样能恢复EditText之前键入的文本。
     * 注：人为退出不会调用该方法。
     *
     * @param outState
     */
    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
        super.onSaveInstanceState(outState);
        Logger.e(TAG, "----------------------onSaveInstanceState");
    }

    /**
     * 执行该方法时，Fragment完全不可见。
     */
    @Override
    public void onStop() {
        super.onStop();
        Logger.e(TAG, "----------------------onStop");
    }

    /**
     * 销毁与Fragment有关的视图，但未与Activity解除绑定，依然可以通过onCreateView方法
     * 重新创建视图。通常在ViewPager+Fragment的方式下会调用此方法。
     */
    @Override
    public void onDestroyView() {
        super.onDestroyView();
        Logger.e(TAG, "----------------------onDestroyView");
    }

    /**
     * 销毁Fragment。通常按Back键退出或者Fragment被回收时调用此方法。
     */
    @Override
    public void onDestroy() {
        super.onDestroy();
        Logger.e(TAG, "----------------------onDestroy");
    }

    /**
     * 解除与Activity的绑定。在onDestroy方法之后调用。
     */
    @Override
    public void onDetach() {
        super.onDetach();
        Logger.e(TAG, "----------------------onDetach");
    }

    /**
     * 通知它的视图层次结构的所有保存状态都已恢复
     *
     * @param savedInstanceState
     */
    @Override
    public void onViewStateRestored(@Nullable Bundle savedInstanceState) {
        super.onViewStateRestored(savedInstanceState);
        Logger.e(TAG, "----------------------onViewStateRestored");
    }

}

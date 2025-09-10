package com.finoptimization.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.finoptimization.R;

/**
 * Created by Ryan on 2019/3/23.
 */
public class MonitorFragment extends BaseFragment {


    private static final String TAG = MonitorFragment.class.getSimpleName();
    private View view;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        if (view == null) {
            view = inflater.inflate(R.layout.fragment_monitor, null);
        }
        return view;
    }
}

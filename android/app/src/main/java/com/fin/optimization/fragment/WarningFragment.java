package com.fin.optimization.fragment;

import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.fin.optimization.R;
import com.fin.optimization.adapter.WarningRecyclerViewGridAdapter;

import java.util.ArrayList;

/**
 * Created by Ryan on 2019/3/23.
 */
public class WarningFragment extends BaseFragment {


    private static final String TAG = WarningFragment.class.getSimpleName();
    private View view;
    private RecyclerView mRecyclerView;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        if (view == null) {
            view = inflater.inflate(R.layout.fragment_warning, null);
            initView(view);
        }
        return view;
    }

    private void initView(View view) {
        mRecyclerView = (RecyclerView) view.findViewById(R.id.recyler_view);
        ArrayList<String> dates = new ArrayList<>();
        for (int x = 0; x < 85; x++) {
            dates.add("" + Math.random());
        }

        WarningRecyclerViewGridAdapter recyclerViewGridAdapter = new WarningRecyclerViewGridAdapter(getContext(), dates);
        mRecyclerView.setAdapter(recyclerViewGridAdapter);
        GridLayoutManager gridLayoutManager = new GridLayoutManager(getContext(), 2);
        gridLayoutManager.setReverseLayout(false);
        gridLayoutManager.setOrientation(GridLayoutManager.VERTICAL);
        mRecyclerView.setLayoutManager(gridLayoutManager);
    }
}

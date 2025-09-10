package com.fin.optimization.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.fin.optimization.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ryan on 2019/3/27.
 */
public class WarningRecyclerViewGridAdapter extends RecyclerView.Adapter<WarningRecyclerViewGridAdapter.GridViewHolder> {

    private Context mContext;
    private List<String> mDateBeen;

    public WarningRecyclerViewGridAdapter(Context context, ArrayList<String> dates) {
        mContext = context;
        mDateBeen = dates;
    }


    @NonNull
    @Override
    public WarningRecyclerViewGridAdapter.GridViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = View.inflate(mContext, R.layout.item_warning, null);
        GridViewHolder gridViewHolder = new GridViewHolder(view);
        return gridViewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull WarningRecyclerViewGridAdapter.GridViewHolder gridViewHolder, int position) {
        String dateBean = mDateBeen.get(position);
        gridViewHolder.setData(dateBean);
    }

    @Override
    public int getItemCount() {
        if (mDateBeen != null && !mDateBeen.isEmpty()) {
            return mDateBeen.size();
        }
        return 0;
    }


    public static class GridViewHolder extends RecyclerView.ViewHolder {

        private final TextView mTvName;

        public GridViewHolder(View itemView) {
            super(itemView);
            mTvName = (TextView) itemView.findViewById(R.id.tv);
        }

        public void setData(String data) {
            mTvName.setText(data);
        }
    }
}

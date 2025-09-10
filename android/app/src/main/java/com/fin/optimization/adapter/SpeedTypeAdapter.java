package com.fin.optimization.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.TextView;

import com.fin.optimization.R;

import java.util.List;

/**
 * 作者：WangJintao
 * 时间：2017/4/1
 * 邮箱：wangjintao1988@163.com
 */

public class SpeedTypeAdapter extends BaseAdapter {
    Context mContext;

    List<String> mAccount;

    LayoutInflater inflater;

    public SpeedTypeAdapter(Context context, List<String> mAccount) {
        mContext = context;
        this.mAccount = mAccount;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return mAccount == null ? 0 : mAccount.size();
    }

    @Override
    public Object getItem(int position) {
        return position;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View view, ViewGroup viewGroup) {
        ViewHolder holder = null;
        if (view == null) {
            holder = new ViewHolder();
            view = inflater.inflate(R.layout.item_speed, null);
//            if (position == 0) {
//                view.setBackgroundResource(R.drawable.selector_bg_login_history_top);
//            } else {
//                view.setBackgroundResource(R.drawable.selector_bg_login_history);
//            }
            holder.deleteBtn = (ImageButton) view.findViewById(R.id.detail_image);
            holder.accountTv = (TextView) view.findViewById(R.id.detail_content);
            view.setTag(holder);
        } else {
            holder = (ViewHolder) view.getTag();
        }
        holder.deleteBtn.setVisibility(View.GONE);
        final String nowAccount = mAccount.get(position);
        holder.accountTv.setText(nowAccount);
        return view;
    }

    class ViewHolder {
        ImageButton deleteBtn;

        TextView accountTv;
    }
}

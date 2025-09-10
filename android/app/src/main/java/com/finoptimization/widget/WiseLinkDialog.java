package com.finoptimization.widget;

import android.app.Dialog;
import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.text.Spanned;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;

import com.finoptimization.MainApplication;
import com.finoptimization.R;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * 作者： WangJintao
 * 时间： 2016/4/5.
 */
public class WiseLinkDialog extends Dialog {


    private Context mContext;
    @BindView(R.id.tv_msg)
    TextView contentView;
    @BindView(R.id.msg_scrollview)
    ScrollView mScrollView;
    @BindView(R.id.listView)
    ListView listView;
    @BindView(R.id.ll_rootview)
    LinearLayout rootView;

    @BindView(R.id.ll_cotentview)
    LinearLayout contentRootView;

    @BindView(R.id.ll_parentview)
    LinearLayout parentView;

    @BindView(R.id.progressBar)
    ProgressBar progressBar;

    boolean isNeedDismiss = false;

    boolean isCanDismissByKeyBack = true;

    @BindView(R.id.btn_close)
    ImageView closeButton;
    @BindView(R.id.tv_title)
    TextView titleView;
    @BindView(R.id.btn_sure)
    TextView okButton;
    @BindView(R.id.btn_sure1)
    TextView okButton1;

    public WiseLinkDialog(Context context) {
        super(context, R.style.WiseLink_Dialog);
        setContentView(R.layout.view_wiselink_dialog);
        ButterKnife.bind(this);
        mContext = context;
        WindowManager.LayoutParams attributes = getWindow().getAttributes();
        attributes.width = ViewGroup.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(attributes);

    }

    public void setNeedDismiss(boolean needDismiss) {
        isNeedDismiss = needDismiss;
    }


    /**
     * 设置dialog内容
     *
     * @param msg 内容
     */
    public void setMessage(String msg) {
        mScrollView.setVisibility(View.VISIBLE);
        contentView.setText(msg);
        contentView.setVisibility(View.VISIBLE);
        progressBar.setVisibility(View.GONE);
    }

    public void setMessageColor(int color) {
        contentView.setTextColor(ContextCompat.getColor(MainApplication.getApp(), color));
    }

    /**
     * 设置dialog内容
     *
     * @param res 内容资源
     */
    public void setMessage(int res) {
        setMessage(MainApplication.getApp().getString(res));
    }

    public void setMessage(Spanned spanned) {
        mScrollView.setVisibility(View.VISIBLE);
        contentView.setText(spanned);
        contentView.setVisibility(View.VISIBLE);
        progressBar.setVisibility(View.GONE);
    }

    /**
     * 获取dialog中的listview
     *
     * @return
     */
    public ListView getListView() {
        mScrollView.setVisibility(View.GONE);
        listView.setVisibility(View.VISIBLE);
        return listView;
    }

    /**
     * 设置内容布局
     *
     * @param layout
     */
    public void setView(int layout) {
        setView(getLayoutInflater().inflate(layout, null));
    }

    /**
     * 设置内容布局
     *
     * @param view
     */
    public void setView(View view) {
        mScrollView.setVisibility(View.VISIBLE);
        mScrollView.removeAllViews();
        mScrollView.addView(view);
    }

    /**
     * 设置整体布局
     *
     * @param layout
     */
    public void setRootView(int layout) {
        setRootView(getLayoutInflater().inflate(layout, null));
    }

    /**
     * 设置整体布局
     *
     * @param view
     */
    public void setRootView(View view) {
        rootView.removeAllViews();
        rootView.addView(view);
    }

    /**
     * 设置内容的布局
     *
     * @param view
     */
    public void setContentRootView(View view) {
        contentRootView.removeAllViews();
        contentRootView.addView(view);
    }

    public void setParentView(View view) {
        parentView.removeAllViews();
        parentView.addView(view);
    }

    /**
     * 设置位置
     *
     * @return
     */
    public LinearLayout getRootView() {
        return rootView;
    }

    /**
     * 自定义布局
     *
     * @return
     */
    public LinearLayout getContentRootView() {
        contentRootView.removeAllViews();
        return contentRootView;
    }

    /**
     * 显示的TextView
     *
     * @return
     */
    public TextView getContentView() {
        return contentView;
    }


    /**
     * 设置进度 用于下载软件
     *
     * @param progress
     */
    public void setProgress(int progress) {
        if (contentView.getVisibility() == View.VISIBLE) {
            contentView.setVisibility(View.GONE);
        }
        if (mScrollView.getVisibility() == View.GONE) {
            mScrollView.setVisibility(View.VISIBLE);
        }
        progressBar.setVisibility(View.VISIBLE);
        progressBar.setProgress(progress);
    }

    public void setWait(boolean enable) {
        progressBar.setVisibility(enable ? View.VISIBLE : View.GONE);
    }

    public void setCanDismissByKeyBack(boolean isCanDismissByKeyBack) {
        this.isCanDismissByKeyBack = isCanDismissByKeyBack;
    }

    public void setIsNeedDismiss(boolean isNeedDismiss) {
        this.isNeedDismiss = isNeedDismiss;
    }


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (!isCanDismissByKeyBack) {

                return true;
            }

        }
        if (keyCode == KeyEvent.KEYCODE_MENU) {
        }

        return super.onKeyDown(keyCode, event);
    }

    @OnClick(R.id.btn_close)
    void closeDialog() {
        dismiss();
    }


    public void setTitle(String title) {
        titleView.setText(title);
    }

    public void setTitle(int resid) {
        titleView.setText(mContext.getString(resid));
    }

    /**
     * 设置确定按钮
     *
     * @param text     按钮上的文字，传null显示默认文字确定
     * @param listener
     */
    public void setOkButton(String text, View.OnClickListener listener) {
        okButton.setVisibility(View.VISIBLE);
        if (text != null)
            okButton.setText(text);
        if (listener != null) {
            okButton.setOnClickListener(listener);
        }
    }

    public void setCancleButton(View.OnClickListener listener) {
        if (listener != null) {
            closeButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    listener.onClick(v);
                    dismiss();
                }
            });
        }
    }

    /**
     * listView 下面添加确定按钮
     *
     * @param text
     * @param listener
     */
    public void setOkButton1(String text, View.OnClickListener listener) {
        okButton1.setVisibility(View.VISIBLE);
        if (text != null)
            okButton1.setText(text);
        if (listener != null)
            okButton1.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    listener.onClick(v);
                    dismiss();
                }
            });
    }


}

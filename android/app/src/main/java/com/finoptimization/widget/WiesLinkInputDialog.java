package com.finoptimization.widget;

import android.content.Context;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.finoptimization.R;
import com.finoptimization.utils.AppUtils;
import com.finoptimization.utils.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 作者：WangJintao
 * 时间：2018/5/21
 * 邮箱：wangjintao1988@163.com
 */
public class WiesLinkInputDialog extends WiseLinkDialog implements TextWatcher, View.OnClickListener {

    private Context mContext;
    @BindView(R.id.ll_cotentview)
    LinearLayout contentRootView;
    private EditText wordsView;
    private TextView leftView;
    private TextView sureButton;
    private int nowCount = 0;
    private int maxCount = 20;//最大字符数
    private TextView view;

    public void setMaxCount(int maxCount) {
        this.maxCount = maxCount;
    }

    private WiesLinkInputDialog(Context context) {
        super(context);
        setContentView(R.layout.view_wiselink_dialog);
        ButterKnife.bind(this);
        mContext = context;
        WindowManager.LayoutParams attributes = getWindow().getAttributes();
        attributes.width = ViewGroup.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(attributes);
        View view = View.inflate(context, R.layout.view_input_dialog, null);
        contentRootView.removeAllViews();
        contentRootView.addView(view);
        wordsView = view.findViewById(R.id.et_words);
        leftView = view.findViewById(R.id.tv_text_left);
        sureButton = view.findViewById(R.id.btn_sure);
        wordsView.addTextChangedListener(this);
        leftView.setText(String.format("%1$s/%2$s", String.valueOf(nowCount), String.valueOf(maxCount)));
        sureButton.setOnClickListener(this);
    }

    public WiesLinkInputDialog(Context context, int maxCount, TextView view) {
        this(context);
        this.maxCount = maxCount;
        leftView.setText(String.format("%1$s/%2$s", String.valueOf(nowCount), String.valueOf(this.maxCount)));
        this.view = view;
        if (maxCount == -1 || maxCount > 5000) {
            leftView.setVisibility(View.GONE);
        } else {
            leftView.setVisibility(View.VISIBLE);
        }

    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {
    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
    }

    @Override
    public void afterTextChanged(Editable s) {
        nowCount = s == null ? 0 : s.length();
        if (nowCount > maxCount) {
            ToastUtil.show(mContext, "已达到最大字符数");
            s.delete(maxCount, nowCount);
            wordsView.setText(s);
        }
        leftView.setText(String.format("%1$s/%2$s", String.valueOf(nowCount), String.valueOf(maxCount)));

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_sure:
                AppUtils.hideSoft(mContext, view);
                view.setText(wordsView.getText().toString());
                dismiss();
                break;
        }
    }

    public void setDefaultText(String message) {
        wordsView.setText(message);
        wordsView.setSelection(TextUtils.isEmpty(message) ? 0 : message.length());
    }
}

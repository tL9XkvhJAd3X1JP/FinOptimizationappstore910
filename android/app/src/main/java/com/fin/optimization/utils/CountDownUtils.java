package com.fin.optimization.utils;

import android.os.Handler;
import android.widget.TextView;

/**
 * Created by Ryan on 2019/1/29.
 */
public class CountDownUtils {

    private TextView mTextView;
    private int DEFAULT_COUNT = 59;
    private int count;
    private String startCountMessage = "获取";
    private String countingMessage = "%1$s";
    private boolean controlDisabled = true;
    private static Handler mHandler = new Handler();
    private OnCountDownListener mOnCountDownListener;
    private Runnable mCountDownRunnable = new Runnable() {
        @Override
        public void run() {
            if (count > 0) {
                mTextView.setText(String.format(countingMessage, count < 10 ? "0" + String.valueOf(count) : String.valueOf(count)));
                count--;
                if (controlDisabled) {
                    mTextView.setClickable(false);
                }
                mHandler.postDelayed(mCountDownRunnable, 1000);
            } else {
                count = DEFAULT_COUNT;
                if (controlDisabled) {
                    mTextView.setClickable(true);
                }
                mTextView.setText(startCountMessage);
                if (mOnCountDownListener != null) {
                    mOnCountDownListener.onEnd();
                }
            }
        }
    };

    /**
     * 是否禁用点击
     *
     * @param b
     */
    public void setControlDisabled(boolean b) {
        this.controlDisabled = b;
    }

    public interface OnCountDownListener {
        void onEnd();
    }

    /**
     * 倒计时
     *
     * @param count
     */
    private void initCount(int count) {
        this.count = count;
    }

    public CountDownUtils(TextView mTextView) {
        initCount(DEFAULT_COUNT);
        this.mTextView = mTextView;
    }

    public void startCountDown() {
        mHandler.removeCallbacks(mCountDownRunnable);
        mHandler.post(mCountDownRunnable);
    }

    public void stopCountDown() {
        mHandler.removeCallbacks(mCountDownRunnable);
        count = DEFAULT_COUNT;
        if (controlDisabled) {
            mTextView.setClickable(true);
        }
        mTextView.setText(startCountMessage);
    }

    /**
     * 设置倒计时间
     *
     * @param count
     */
    public void setCount(int count) {
        DEFAULT_COUNT = count;
        initCount(count);
    }

    /**
     * 倒计时开始时的显示
     *
     * @param startCountMessage
     */
    public void setStartCountMessage(String startCountMessage) {
        this.startCountMessage = startCountMessage;
        if (this.mTextView != null) {
            this.mTextView.setText(startCountMessage);
        }
    }

    /**
     * 倒计时中的显示
     *
     * @param countingMessage format格式
     */
    public void setFormatCountingMessage(String countingMessage) {
        this.countingMessage = countingMessage;
    }

    public void setOnCountDownListener(OnCountDownListener mOnCountDownListener) {
        this.mOnCountDownListener = mOnCountDownListener;
    }
}

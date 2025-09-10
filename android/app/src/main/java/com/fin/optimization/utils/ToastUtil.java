/**
 * 
 */
package com.fin.optimization.utils;

import android.content.Context;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.fin.optimization.MainApplication;
import com.fin.optimization.R;

public class ToastUtil {

	public static Toast toast = null;

	public static long showToastTime;

	public static void show(Context context, String info) {
		context= MainApplication.getApp();
		if (isToastShowing() || TextUtils.isEmpty(info)) {
			return;
		}
		showToastTime = System.currentTimeMillis();
		if (toast == null) {
			toast = makeText(context, info, Toast.LENGTH_SHORT);
		} else {
			setText(info);
		}
		toast.show();
	}

	public static void show(Context context, int info) {
		show(context, context.getString(info));
	}

	private static Toast makeText(Context context, CharSequence text,
                                  int duration) {
		Toast result = new Toast(context);
		LayoutInflater inflate = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View v = inflate.inflate(R.layout.view_toast, null);
		TextView tv = (TextView) v.findViewById(R.id.tv_toast_msg);
		tv.setText(text);
		result.setView(v);
		result.setDuration(duration);
		result.setGravity(Gravity.CENTER, 0, 0);
		return result;
	}

	private static void setText(CharSequence s) {
		View v = toast.getView();
		if (v == null) {
			throw new RuntimeException(
					"This Toast was not created with Toast.makeText()");
		}
		TextView tv = (TextView) v.findViewById(R.id.tv_toast_msg);
		if (tv == null) {
			throw new RuntimeException(
					"This Toast was not created with Toast.makeText()");
		}
		tv.setText(s);
	}

	private static boolean isToastShowing() {
		return System.currentTimeMillis() - showToastTime <= 800;
	}
}

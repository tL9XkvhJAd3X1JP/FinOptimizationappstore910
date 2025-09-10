package com.fin.optimization.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

/**
 * @author Wangjintao
 * @date 2014-9-16 下午5:12:15 类说明
 */
public class WiselinkListView extends ListView {

	public WiselinkListView(Context context) {
		super(context);
	}

	public WiselinkListView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public WiselinkListView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2,
				MeasureSpec.AT_MOST);
		super.onMeasure(widthMeasureSpec, expandSpec);
	}

}

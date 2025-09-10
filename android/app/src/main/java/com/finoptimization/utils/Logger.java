package com.finoptimization.utils;


import com.finoptimization.MainApplication;

import java.io.File;
import java.io.FileWriter;

public class Logger
{
	public final static String LOGTAG = "OBDReader";

	public static final boolean DEBUG = true;

	// private static Lock lock = new ReentrantLock();
	private static Object obj = new Object();

	public static void v(String msg)
	{
		android.util.Log.v(LOGTAG, getComString(null, msg));
	}

	public static void v(String title, String msg)
	{
		android.util.Log.v(LOGTAG, getComString(title, msg));
	}

	public static void e(String msg)
	{
		String message = getComString(null, msg);
		if (DEBUG){
			android.util.Log.e(LOGTAG, message);
		}

		writeLogFile(message);

	}

	public static void e(String title, String msg)
	{
		String message = getComString(title, msg);
		if (DEBUG){
			android.util.Log.e(LOGTAG, message);
		}

		String str = "";
		if(title == null || title.length() == 0)
			str = msg;
		else if(msg == null || msg.length() == 0)
			str = title;
		else
			str = title + "|" + msg;


		writeLogFile(message);

	}

	public static String getComString(String title, String msg)
	{
		if (title == null)
		{
			return msg == null ? "" : msg;
		}
		return String.format("[%s]: %s", title, msg == null ? "" : msg);
	}

	public static void e(Throwable ex)//Exception ex)
	{

		e("", ex);

	}

	public static void e(String funName, Throwable ex)
	{
		if (ex == null)
			return;

		String message = getComString(funName + "-!ERROR!", getStackTrace(ex));
		android.util.Log.e(LOGTAG, message);
		writeLogFile(message);

	}

	public static void f(String msg)
	{
		String message = getComString(null, msg);
		android.util.Log.w(LOGTAG, message);
		//writeLogFile(message);
	}

	public static void f(String title, String msg)
	{
		String message = getComString(title, msg);
		android.util.Log.w(LOGTAG, message);
		//writeLogFile(message);
	}

	public static String getStackTrace(Throwable t)//Exception t)
    {
		return t.toString();
//		if(Constants.RTM_ENV)
//			return t.toString();
//		
//        StringWriter sw = new StringWriter();
//        PrintWriter pw = new PrintWriter(sw, true);
//        t.printStackTrace(pw);
//        pw.flush();
//        sw.flush();
//        return sw.toString();
    }

	private static void writeLogFile(String msg)
	{
		synchronized (obj)
		{
			try
			{
//				String fileName = "feedback.txt";
//				FileOutputStream trace = ctx.openFileOutput(fileName, Context.MODE_PRIVATE);
//				OutputStreamWriter writer = new OutputStreamWriter(trace);


//				String fileName = "/sdcard/wsm.log";
				File file = new File(MainApplication.getApp().getFilesDir(), "wsm.log");//new File(fileName);
				FileWriter fw = null;
				if(file.exists())
				{
				if (file.length() > 100000)
					fw = new FileWriter(file, false);
				else
					fw = new FileWriter(file, true);
				}
				else
					fw = new FileWriter(file, false);

				java.util.Date d=new java.util.Date();
				java.text.SimpleDateFormat s= new java.text.SimpleDateFormat("MM-dd HH:mm:ss");
				String dateStr = s.format(d);

				fw.write(String.format("[%s] %s", dateStr,msg));
				//fw.write(msg);//String.format("%s", msg));
				fw.write(13);
				fw.write(10);
				fw.flush();
				fw.close();
			} catch (Throwable ex)
			{
				int i = 0;
				//Helper.toastMessage(HiApp.getApp(), ex.getMessage());
			}
		}
	}
}

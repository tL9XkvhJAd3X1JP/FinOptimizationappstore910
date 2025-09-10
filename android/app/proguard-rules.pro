# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-keepattributes InnerClasses
-dontoptimize
-keep public class com.google.vending.licensing.ILicensingService
#反射 注解 异常
-keepattributes Signature
-keepattributes EnclosingMethod
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes SourceFile,LineNumberTable
-keep class * extends java.lang.annotation.Annotation { *; }


# For native methods, see http://proguard.sourceforge.net/manual/examples.html#native
-keepclasseswithmembernames class * {
    native <methods>;
}


-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}


#-keep class **.R$* {*;}


-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

-dontwarn android.support.**
-keep class android.support.v4.** {*;}

-keep class android.support.annotation.** {*;}
-keep class android.support.multidex.** {*;}
-keep class android.support.percent.** {*;}

-keep interface android.support.v4.app.** {*;}
-dontwarn android.support.v7.**
-keep class android.support.v7.** {*;}
-keep class android.support.v7.widget.** {*;}

-keep interface android.support.v7.app.** {*;}
-keep public class * extends android.support.v4.app.Fragment
#Butterknife  start
-keep class butterknife.** { *; }
-dontwarn butterknife.internal.**
-keep class **$$ViewInjector { *; }

-keepclasseswithmembernames class * {
    @butterknife.* <fields>;
}

-keepclasseswithmembernames class * {
    @butterknife.* <methods>;
}
#Butterknife  end

#apache  start
-keep class org.apache.commons.httpclient.** {*;}
-dontwarn org.apache.commons.httpclient.**
#apache  end

-keepclassmembers class ** {
    public void on*Event(...);
}


-keep class com.google.** {*;}
-dontwarn com.google.**
-keep public class com.idea.fifaalarmclock.app.R$*{
    public static final int *;
}

-dontwarn org.apache.commons.**

-keepclasseswithmembers class shzb.zhinaibo.base.** {

     <fields>;

     <methods>;

}

#gson start
-keep public class com.google.gson.**
-dontwarn com.google.gson.**
-keep class com.google.gson.** {*;}
-keep public class com.google.gson.**
-keep public class com.google.gson.** {public private protected *;}
-keep public class com.project.mocha_patient.login.SignResponseData { private *; }
-keep class sun.misc.Unsafe { *; }
-keep class com.idea.fifaalarmclock.entity.***
-keep class com.google.gson.stream.** { *; }
#gson end

#webkit start
-keep public class android.webkit.**
-dontwarn android.webkit.WebViewClient
-keep public class android.net.http.SslError{
     *;
}
-keep public class android.webkit.WebViewClient{
    *;
}
-keep public class android.webkit.WebChromeClient{
    *;
}
-keep public interface android.webkit.WebChromeClient$CustomViewCallback {
    *;
}
-keep public interface android.webkit.ValueCallback {
    *;
}
-keep class cn.evrental.app.ui.activity.OrderDetailActivity{
*;
}
-keep class cn.evrental.app.ui.activity.OrderDetailFragment{
*;
}

-keep class * implements android.webkit.WebChromeClient {
    *;
}

#webkit end

-keepclassmembers class * {
   public <init>(org.json.JSONObject);
}

-keepclassmembers class ** {
    public void onEvent*(**);
}
  -keepclassmembers class ** {
      public void onMainEvent*(**);
  }

    #不混淆资源类
    -keepclassmembers class **.R$* {
        public static <fields>;
    }
-keepattributes *JavascriptInterface*

-keepnames class * implements java.io.Serializable

-keepclassmembers class * implements java.io.Serializable {*;}

-assumenosideeffects class android.util.Log {
    public static *** e(...);
    public static *** w(...);
    public static *** wtf(...);
    public static *** d(...);
    public static *** v(...);
}

-keep public class org.apache.commons.logging.impl.**{*;}

-keepclassmembers class fqcn.of.javascript.interface.for.webview {
   public *;
}
-keep ,allowoptimization,allowobfuscation,allowshrinking public class     org.jf.dexlib2.dexbacked.** {
    *;
}
-keep class android.net.** { *; }
-dontwarn android.net.**
-keep class com.fin.optimization.bean.** { *; }
-keep class com.fin.optimization.rnmodle.** { *; }
-keep class com.fin.optimization.rnpackage.** { *; }
-keep class com.baidu.** {*;}
-keep class mapsdkvi.com.** {*;}
-keep class vi.com.**{*;}
-dontwarn com.baidu.**

#glide start
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

# for DexGuard only
#-keepresourcexmlelements manifest/application/meta-data@value=GlideModule
#glide end
-keep class com.fin.optimization.module.** { *; }

#litepal start
-keep class org.litepal.** {
    *;
}

-keep class * extends org.litepal.crud.DataSupport {
    *;
}

-keep class * extends org.litepal.crud.LitePalSupport {
    *;
}
#litepal end

#eventbus start
-keepattributes *Annotation*
-keepclassmembers class * {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }

# Only required if you use AsyncExecutor
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}
#eventbus stop


#okhttp
-dontwarn okhttp3.**
-keep class okhttp3.**{*;}

#okgo
-dontwarn com.lzy.**
-keep class com.lzy.**{*;}

#okio
-dontwarn okio.**
-keep class okio.**{*;}

#bugly
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}
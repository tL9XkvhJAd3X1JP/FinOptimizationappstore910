package com.fin.optimization.utils;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;

import com.bumptech.glide.load.DecodeFormat;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.RequestOptions;
import com.fin.optimization.module.GlideApp;

import java.io.File;

/**
 * Created by Ryan on 2019/1/27.
 */
public class GlideImgManager {

    public static void loadImage(Context context, int resourceId, ImageView imageView) {
        loadImage(context, resourceId, imageView, initDefaultRequestOptions(resourceId));
    }

    public static void loadImage(Context context, int resourceId, ImageView imageView, int placeholder) {
        loadImage(context, resourceId, imageView, initDefaultRequestOptions(placeholder));
    }

    public static void loadImage(Context context, String url, ImageView imageView, int placeholder) {
        loadImage(context, url, imageView, initDefaultRequestOptions(placeholder));
    }

    public static void loadImage(Context context, int resourceId, ImageView imageView, int w, int h) {
        RequestOptions requestOptions = initDefaultRequestOptions(resourceId);
        requestOptions.override(w, h);
        loadImage(context, resourceId, imageView, requestOptions);
    }

    private static RequestOptions initDefaultRequestOptions(int placeholder) {
        RequestOptions requestOptions = RequestOptions.formatOf(DecodeFormat.PREFER_RGB_565)
                .centerCrop()
                .placeholder(placeholder)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE);//缓存转换后的图片
        return requestOptions;
    }

    public static RequestOptions initFitCenterRequestOptions() {
        RequestOptions requestOptions = RequestOptions.formatOf(DecodeFormat.PREFER_RGB_565)
                .fitCenter()
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE);//缓存转换后的图片
        return requestOptions;
    }

    public static RequestOptions initUnCacheFitCenterRequestOptions() {
        RequestOptions requestOptions = RequestOptions.formatOf(DecodeFormat.PREFER_RGB_565)
                .fitCenter()
                .skipMemoryCache(true) // 不使用内存缓存
                .diskCacheStrategy(DiskCacheStrategy.NONE);//缓存转换后的图片
        return requestOptions;
    }

    public static RequestOptions initUnDiskCacheFitCenterRequestOptions() {
        RequestOptions requestOptions = RequestOptions.formatOf(DecodeFormat.PREFER_RGB_565)
                .fitCenter()
//                .skipMemoryCache(true) // 不使用内存缓存
                .diskCacheStrategy(DiskCacheStrategy.NONE);//缓存转换后的图片
        return requestOptions;
    }

    public static RequestOptions initFitCenterRequestOptions(int placeholder) {
        return initFitCenterRequestOptions().placeholder(placeholder);
    }

    public static RequestOptions initUnCacheFitCenterRequestOptions(int placeholder) {
        return initUnCacheFitCenterRequestOptions().placeholder(placeholder);
    }

    public static RequestOptions initUnDiskCacheFitCenterRequestOptions(int placeholder) {
        return initUnDiskCacheFitCenterRequestOptions().placeholder(placeholder);
    }

    public static void loadImage(Context context, int resourceId, ImageView imageView, RequestOptions requestOptions) {
        GlideApp.with(context).load(resourceId).apply(requestOptions).into(imageView);
    }

    public static void loadImage(Context context, String imageUrl, ImageView imageView, RequestOptions requestOptions) {
        GlideApp.with(context).load(imageUrl).apply(requestOptions).into(imageView);
    }

    public static void loadImage(Context context, File file, ImageView imageView, RequestOptions requestOptions) {
        GlideApp.with(context).load(file).apply(requestOptions).into(imageView);
    }

    public static void loadImage(Context context, Drawable drawable, ImageView imageView, RequestOptions requestOptions) {
        GlideApp.with(context).load(drawable).apply(requestOptions).into(imageView);
    }

    public static void clearCache(Activity activity) {
        GlideCacheUtil.getInstance().clearImageAllCache(activity);
    }

    public static void clearMemoryCache(Activity activity) {
        GlideCacheUtil.getInstance().clearImageMemoryCache(activity);
    }
}
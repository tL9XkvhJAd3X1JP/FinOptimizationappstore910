package com.finoptimization.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.os.Environment;

import com.finoptimization.constant.Constants;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.concurrent.Executors;

/**
 * 图片工具类，
 *
 * @author
 */
public class ImageUtils {

    public static File dir;


    /**
     * 情况在磁盘上的缓存
     */
    public static void clear() {
        if (dir.exists()) {
            File[] files = dir.listFiles();
            for (File file : files) {
                if (file.isFile()) {
                    file.delete();
                }
            }
        }
    }

    // 根据路径获得图片并压缩，返回bitmap用于显示
    public static Bitmap getSmallBitmap(String filePath) {
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(filePath, options);

        // Calculate inSampleSize
        options.inSampleSize = calculateInSampleSize(options, 480, 800);

        // Decode bitmap with inSampleSize set
        options.inJustDecodeBounds = false;

        Bitmap bitmap = BitmapFactory.decodeFile(filePath, options);

        return rotateBitmap(bitmap, readPictureDegree(filePath));
    }

    //计算图片的缩放值
    public static int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;

        if (height > reqHeight || width > reqWidth) {
            final int heightRatio = Math.round((float) height / (float) reqHeight);
            final int widthRatio = Math.round((float) width / (float) reqWidth);
            inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio;
        }
        return inSampleSize;
    }

    //Bitmap对象保存为图片文件
    public static File bitmap2File(Bitmap bitmap) {
        File file = new File(getPhotoPath() + File.separator + "temp2.jpg");//将要保存图片的路径
        try {
            BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(file));
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bos);
            bos.flush();
            bos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return file;
    }

    public static File bitmap2File(Bitmap bitmap, String name) {
        File file = new File(getPhotoPath() + File.separator + name);//将要保存图片的路径
        try {
            BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(file));
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bos);
            bos.flush();
            bos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return file;
    }

    public static final String TOO_HOST = Environment
            .getExternalStorageDirectory().getPath() + "/wiselink";

    public static final String PHOTO_HOST = TOO_HOST + File.separator + "photo";

    public static String getPhotoPath() {

        final File path = new File(PHOTO_HOST);
        if (!path.exists()) {
            path.mkdirs();
        }

        return PHOTO_HOST;
    }

    /**
     * 获取照片的角度
     *
     * @param path
     * @return
     */
    public static int readPictureDegree(String path) {
        int degree = 0;
        try {
            ExifInterface exifInterface = new ExifInterface(path);
            int orientation = exifInterface.getAttributeInt(
                    ExifInterface.TAG_ORIENTATION,
                    ExifInterface.ORIENTATION_NORMAL);
            switch (orientation) {
                case ExifInterface.ORIENTATION_ROTATE_90:
                    degree = 90;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    degree = 180;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_270:
                    degree = 270;
                    break;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return degree;
    }

    /**
     * 旋转照片
     *
     * @param bitmap
     * @param degress
     * @return
     */
    public static Bitmap rotateBitmap(Bitmap bitmap, int degress) {
//        if (bitmap != null) {
//            Matrix m = new Matrix();
//            m.postRotate(degress);
//            bitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(),
//                    bitmap.getHeight(), m, true);
//            return bitmap;
//        }
//        return bitmap;

        Bitmap returnBm = null;
        // 根据旋转角度，生成旋转矩阵
        Matrix matrix = new Matrix();
        matrix.postRotate(degress);
        try {
            // 将原始图片按照旋转矩阵进行旋转，并得到新的图片
            returnBm = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        } catch (OutOfMemoryError e) {
        }
        if (returnBm == null) {
            returnBm = bitmap;
        }
        if (bitmap != returnBm) {
            bitmap.recycle();
            bitmap = null;
        }
        return returnBm;


    }

    public static FileUploader upLoadImg(File img, FileUploader.FileUploadCallBack fileDownCallBack) {
        try {
            HashMap<String, String> binParams1 = new HashMap<String, String>();
            FileUploader uploader = new FileUploader(Constants.uploadImg(), img.getAbsolutePath(), binParams1, fileDownCallBack);
//            uploader.execute((Void) null);
            uploader.executeOnExecutor(Executors.newCachedThreadPool());
            return uploader;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String getTempPhotoPath() {

        return getPhotoPath() + File.separator + "temp.jpg";
    }

}
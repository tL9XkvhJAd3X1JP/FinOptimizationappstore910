//
//  BSImagePickerController.h
//  com.bagemanager.bgm
//
//  Created by 樊鹏帅 on 2016/12/1.
//  Copyright © 2016年 www.bagechuxing.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BSImagePickerFinishBlock)(UIImage *image, NSData *data);

@interface BSImagePickerController : UIImagePickerController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

+ (instancetype)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType finishHandle:(BSImagePickerFinishBlock)block;


@end

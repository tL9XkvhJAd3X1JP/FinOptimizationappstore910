//
//  BSImagePickerController.m
//  com.bagemanager.bgm
//
//  Created by 樊鹏帅 on 2016/12/1.
//  Copyright © 2016年 www.bagechuxing.cn. All rights reserved.
//

#import "BSImagePickerController.h"

@interface BSImagePickerController ()

@property (nonatomic,copy)BSImagePickerFinishBlock finishBlock;

@end

@implementation BSImagePickerController

+ (instancetype)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType finishHandle:(BSImagePickerFinishBlock)block
{
    BSImagePickerController *imagePicker = [[BSImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.finishBlock = block;
    imagePicker.allowsEditing = NO;
    
    return imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __block UIImage *image = self.allowsEditing?[info objectForKey:UIImagePickerControllerEditedImage]:[info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage *fixImage = [image fixOrientation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
//        NSData *imageData = [image imageCompressToScale];
        image = nil;
        UIImage *tumImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [picker dismissViewControllerAnimated:YES completion:^{
                
                if (self.finishBlock) {
                    self.finishBlock(tumImage,imageData);
                }
            }];
            
        });
        
    });
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    NSLog(@"didFinishPickingImage");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

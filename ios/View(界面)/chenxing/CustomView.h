//
//  CustomView.h
//  wsmCarOwner
//
//  Created by chenxing on 13-4-26.
//  Copyright (c) 2013年 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CustomView : UIControl<UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UIView *view1;
@property (nonatomic,strong) IBOutlet UIView *view2;
@property (nonatomic,strong) IBOutlet UIView *view3;
@property (nonatomic,strong) IBOutlet UIButton *button1;
@property (nonatomic,strong) IBOutlet UIButton *button2;
@property (nonatomic,strong) IBOutlet UIButton *button3;
@property (strong,nonatomic) NSObject *obj;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView2;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextField *textField2;
-(void)renderModifyPasswrodViewWithTitle:(NSString *)title okButtonTitle:(NSString *)okButtonTitle cancelBlock:(void(^)(void))cancelBlock okBlock:(void(^)(NSMutableDictionary*dic))okBlock;
@end

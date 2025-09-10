//
//  CustomView.m
//  wsmCarOwner
//
//  Created by chenxing on 13-4-26.
//  Copyright (c) 2013年 chenxing. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
-(void)dealloc
{
//    [_button1 release];
//    [_obj release];
//    [_label release];
//    [_label2 release];
//    [_imgView release];
//    [_button2 release];
//    [_imgView2 release];
//    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)renderModifyPasswrodViewWithTitle:(NSString *)title okButtonTitle:(NSString *)okButtonTitle cancelBlock:(void(^)(void))cancelBlock okBlock:(void(^)(NSMutableDictionary*dic))okBlock
{
    kWeakSelf(self);
    CGFloat spaceX = 15;
    CGFloat spaceY = 15;
    [self setFrameInSuperViewCenter:nil width:ScreenWidth height:ScreenHeight];
    self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.7];
    self.view1.backgroundColor = [UIColor whiteColor];
    [self.view1 setCornerRadius:11];
    self.view1.width = ScreenWidth - spaceX*4;
    UIImage *image = IMAGE_NAMED(@"关闭k8");
    [self.button2 setFrameInSuperViewRightTop:nil toRightSpace:0 toTopSpace:0 width:[self getPicScaleLen2:image.size.width] height:[self getPicScaleLen2:image.size.height]];
    [self.button2 setBackgroundImage:image forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:IMAGE_NAMED(@"关闭按下k8") forState:UIControlStateHighlighted];
    if (title == nil)
    {
        title = @"";
    }
    self.label.text = title;
    self.label.font = FFont_Default_Big;
    self.label.textColor = Color_Nomal_Font_Blue;
    [self.label setFrameInSuperViewLeftTop:nil toLeftSpace:spaceX toTopSpace:spaceY width:self.view1.width - self.button2.width - 3 height:-2];
    //    if (message == nil)
    //    {
    //        message = @"";
    //    }
    //
    //    self.label2.text = message;
    //    self.label2.font = FFont_Default;
    //    self.label2.textColor = [UIColor grayColor];
    //    self.label2.hidden = YES;
    //    [self.label2 setFrameLeftTopFromViewLeftBottom:self.label leftToLeftSpace:0 bottomToTopSpace:spaceY*2 width:self.view1.width - spaceX *2 height:-2];
    
    
    
    self.view2.layer.cornerRadius = 5;
    self.view2.layer.borderWidth = 1;
    self.view2.layer.borderColor = Color_border.CGColor;
    
    self.view3.layer.cornerRadius = 5;
    self.view3.layer.borderWidth = 1;
    self.view3.layer.borderColor = Color_border.CGColor;
    [self.view2 setFrameInSuperViewCenterTop:nil toTopSpace:self.label.bottom + 20 width:self.view1.width - spaceX *2 height:40];
    self.textField.frame = Rect(5, 0, self.view2.width-10, self.view2.height);
    [self.view3 setFrameLeftTopFromViewLeftBottom:self.view2 leftToLeftSpace:0 bottomToTopSpace:15 width:self.view2.width height:40];
    self.textField2.frame = Rect(5, 0, self.view3.width - 57, self.view3.height);
    //54 × 48
    
    self.textField.placeholder = @"旧密码";
    self.textField2.placeholder = @"新密码";
    self.textField2.secureTextEntry = YES;
    self.textField2.delegate = self;
    self.textField.delegate = self;
    [self.button3 setImage:[UIImage imageNamed:@"VIEWOFF"] forState:UIControlStateNormal];
    [self.button3 setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:10 width:27 height:24];
    [self.button3 addTapBlock:^(UIButton *btn) {
        if (!weakself.textField2.secureTextEntry)
        {
            weakself.textField2.secureTextEntry = YES;
            
            [weakself.button3 setImage:[UIImage imageNamed:@"VIEWOFF"] forState:UIControlStateNormal];
        }
        else
        {
            weakself.textField2.secureTextEntry = NO;
            
            [weakself.button3 setImage:[UIImage imageNamed:@"VIEW"] forState:UIControlStateNormal];
        }
    }];
    [self.button1 setFrameLeftTopFromViewLeftBottom:self.view3 leftToLeftSpace:0 bottomToTopSpace:spaceY*2 width:self.view1.width - spaceX *2 height:40];
    
    [self.button1 setCornerRadius:4];
    self.button1.backgroundColor = Color_Nomal_Bg;
    [self.button1 setTitle:okButtonTitle forState:UIControlStateNormal];
    
    self.view1.height = self.button1.bottom + spaceY;
    self.view1.center = self.center;
    
    //cancel
    [self.button2 addTapBlock:^(UIButton *btn) {
        
        [weakself removeFromSuperview];
        [kNotificationCenter removeObserver:weakself];
        if (cancelBlock != nil)
        {
            cancelBlock();
        }
        
        
    }];
    //ok
    [self.button1 addTapBlock:^(UIButton *btn) {
        [weakself removeFromSuperview];
        [kNotificationCenter removeObserver:weakself];
        if (okBlock != nil)
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:2];
            [tempDic setObjectFilterNull:weakself.textField.text forKey:@"password"];
            [tempDic setObjectFilterNull:weakself.textField2.text forKey:@"password2"];
            okBlock(tempDic);
        }
        
    }];
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(keyboardBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShown:(NSNotification*)notification
{
    
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    self.centerY = (ScreenHeight - keyboardSize.height)/2;
    
}


- (void)keyboardBeHidden:(NSNotification*)notification
{
    //do something
    
    self.centerY = ScreenHeight/2;
}
@end

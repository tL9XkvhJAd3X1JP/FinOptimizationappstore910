//
//  TwoLabelCell.h
//  BaseProject
//
//  Created by janker on 2019/1/25.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwoLabelCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *myTextField;


@property (nonatomic,strong) IBOutlet UISwitch *mySwitch;
@property (nonatomic,strong) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg2;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg3;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg4;
@property (strong, nonatomic) IBOutlet UIImageView *cell_bg_Img;
@property (nonatomic,strong) IBOutlet UILabel *firstLabel;
@property (nonatomic,strong) IBOutlet UILabel *secondLabel;
@property (nonatomic,strong) IBOutlet UILabel *thirdLabel;
@property (nonatomic,strong) IBOutlet UILabel *fourthLabel;

@property (nonatomic,strong) IBOutlet UILabel *fiveLabel;
@property (nonatomic,strong) IBOutlet UILabel *sixLabel;
@property (nonatomic,strong) IBOutlet UIButton *firstButton;
@property (nonatomic,strong) IBOutlet UIButton *secondButton;
@property (nonatomic,strong) IBOutlet UIButton *thirdButton;
@property (strong, nonatomic) IBOutlet UIButton *fourthButton;

@property (nonatomic,strong) IBOutlet UILabel *sevenLabel;
@property (nonatomic,strong) IBOutlet UILabel *eightLabel;
@property (strong, nonatomic) IBOutlet UIImageView *middleLineImage;
@property (strong, nonatomic) IBOutlet UIImageView *rightimg;

@property (strong, nonatomic) IBOutlet UIImageView *titleImageview;
@property (strong, nonatomic) IBOutlet UIImageView *bottomLineImg;
@property (strong, nonatomic) IBOutlet UIView *cellBackGroundView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg5;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg6;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg7;



@property (retain, nonatomic) IBOutlet UIView *view1;
@property (retain, nonatomic) IBOutlet UIView *view2;
@property (retain, nonatomic) IBOutlet UIView *view3;
@end

NS_ASSUME_NONNULL_END

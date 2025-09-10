//
//  RegisterViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/28.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "RegisterViewController.h"
#import <MJRefresh.h>
#import "BSImagePickerController.h"
#import "TSDateLocateView.h"
#import "NetWorkCenter.h"
//#import <YBImageBrowser/YBImageBrowser.h>
#import <SGImageBrowser.h>
//UIActionSheetDelegate
@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
//@property (nonatomic, strong)NSMutableDictionary *dicData;//
@property (nonatomic, strong)NSMutableArray *arrayData;//
@property (nonatomic, assign)int sexType;//1男 2女 使用人性别
@property (nonatomic, assign)int sexType2;//1男 2女 紧急联系人性别
@property (nonatomic, assign)int saveType;//3 200/年 4 100/年 5 50/年  0代表不选

@property (nonatomic, strong)NSString *validateCode;//
//0注册 1查看
@property (nonatomic, assign)int initType;

@property (nonatomic, strong) NSTimer *timerClock;
@property (nonatomic, assign) int timeNum;
@property (nonatomic, strong) UIButton *validateCodeButton;
@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) TwoLabelCell *phoneCell;

@property (nonatomic, strong) TwoLabelCell *validateCell;

@end

@implementation RegisterViewController
-(void)dealloc
{
    [viewDic removeAllObjects];
}
-(void)loadView
{
    self.navType = 1;
    _saveType = 0;//不勾
    _sexType = 2;
    _sexType2 = 2;
    self.leftNavBtnName = @"返回";
    [super loadView];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:[self className] bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)resetAllViewValues
{
    if (_initType == 1)
    {
        //审核通过
        if ([@"2" isEqualToString:[SingleDataManager instance].userInfoModel.state])
        {
            self.arrayData = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"请输入用户名",@"用户名*",
                                                               @"请输入手机号码",@"手机号码*",
                                                               @"",@"登记地址*",
                                                               @"",@"常驻地所属居/村委会*", nil],[NSMutableArray arrayWithObjects:@"请输入使用人姓名",@"使用人姓名*",
                                                                                         @"请选择使用人性别",@"使用人性别*",
                                                                                         @"请输入使用人身份证号",@"使用人身份证号*",
                                                                                         @"请输入紧急联系人姓名",@"紧急联系人姓名*",
                                                                                         @"请选择紧急联系人性别",@"紧急联系人性别*",
                                                                                         @"请输入紧急联系人电话",@"紧急联系人电话*",
                                                                                         @"请输入紧急联系人身份证号",@"紧急联系人身份证号", nil],[NSMutableArray arrayWithObjects:@"",@"使用人身份证正面照片" ,nil],[NSMutableArray arrayWithObjects:@"",@"使用人身份证反面照片", nil],[NSMutableArray arrayWithObjects:@"",@"使用人正面免冠照片", nil],[NSMutableArray arrayWithObjects: @"请输入电动车品牌",@"电动车品牌*",
                                                                                                                                                                                                                                                                                                       @"请输入电动车电机号",@"电动车电机号*",
                                                                                                                                                                                                                                                                                                       @"请输入电动车车架号",@"电动车车架号*",
                                                                                                                                                                                                                                                                                                       @"请输入电动车颜色",@"电动车颜色*",
                                                                                                                                                                                                                                                                                                       @"请选择电动车购买时间",@"电动车购买时间*",
                                                                                                                                                                                                                                                                                                       @"",@"驾驶人意外险", nil],[NSMutableArray arrayWithObjects:@"",@"电动车上牌后照片", nil],[NSMutableArray arrayWithObjects:@"",@"车辆使用证明", nil],[NSMutableArray arrayWithObjects: @"非必填",@"志愿者姓名",
                                                                                                                                                                                                                                                                                                                                                                                                                                        @"非必填",@"车牌号码",
                                                                                                                                                                                                                                                                                                                                                                                                                                        @"非必填",@"设备号",
                                                                                                                                                                                                                                                                                                                                                                                                                                        @"非必填",@"防盗定位账号", nil], nil];
        }
        else
        {
            self.arrayData = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"请输入用户名",@"用户名*",
                                                               @"请输入手机号码",@"手机号码*",
                                                                @"请输入短信验证码",@"手机短信验证码*",
                                                               @"",@"登记地址*",
                                                               @"",@"常驻地所属居/村委会*", nil],[NSMutableArray arrayWithObjects:@"请输入使用人姓名",@"使用人姓名*",
                                                                                         @"请选择使用人性别",@"使用人性别*",
                                                                                         @"请输入使用人身份证号",@"使用人身份证号*",
                                                                                         @"请输入紧急联系人姓名",@"紧急联系人姓名*",
                                                                                         @"请选择紧急联系人性别",@"紧急联系人性别*",
                                                                                         @"请输入紧急联系人电话",@"紧急联系人电话*",
                                                                                         @"请输入紧急联系人身份证号",@"紧急联系人身份证号", nil],[NSMutableArray arrayWithObjects:@"",@"使用人身份证正面照片" ,nil],[NSMutableArray arrayWithObjects:@"",@"使用人身份证反面照片", nil],[NSMutableArray arrayWithObjects:@"",@"使用人正面免冠照片", nil],[NSMutableArray arrayWithObjects: @"请输入电动车品牌",@"电动车品牌*",
                                                                                                                                                                                                                                                                                                       @"请输入电动车电机号",@"电动车电机号*",
                                                                                                                                                                                                                                                                                                       @"请输入电动车车架号",@"电动车车架号*",
                                                                                                                                                                                                                                                                                                       @"请输入电动车颜色",@"电动车颜色*",
                                                                                                                                                                                                                                                                                                       @"请选择电动车购买时间",@"电动车购买时间*",
                                                                                                                                                                                                                                                                                                       @"",@"驾驶人意外险", nil],[NSMutableArray arrayWithObjects:@"",@"电动车上牌后照片", nil],[NSMutableArray arrayWithObjects:@"",@"车辆使用证明", nil],[NSMutableArray arrayWithObjects: @"非必填",@"志愿者姓名",
                                                                                                                                                                                                                                                                                                                                                                                                                                        @"非必填",@"车牌号码",
                                                                                                                                                                                                                                                                                                                                                                                                                                        @"非必填",@"设备号",
                                                                                                                                                                                                                                                                                                                                                                                                                                        @"非必填",@"防盗定位账号", nil], nil];
        }
        
        UserInfoModel *mode = [SingleDataManager instance].userInfoModel;


        //登录用户名
        [viewDic setObjectFilterNull:mode.loginname forKey:@"用户名*"];
        //密码
        [viewDic setObjectFilterNull:mode.password forKey:@"密码(至少输入6位字符)*"];
        //手机号码
        [viewDic setObjectFilterNull:mode.mobilephone forKey:@"手机号码*"];
        //登记地址
//        [request.parm setObjectFilterNull:[viewDic objectForKey:@"登记地址*id"] forKey:@"companyid"];
        [viewDic setObjectFilterNull:mode.companyid forKey:@"登记地址*id"];
        [viewDic setObjectFilterNull:mode.companyName forKey:@"登记地址*"];
        //常驻地所属居/村委会
        [viewDic setObjectFilterNull:mode.groupid forKey:@"常驻地所属居/村委会*id"];
        [viewDic setObjectFilterNull:mode.groupName forKey:@"常驻地所属居/村委会*"];
        //使用人姓名
        [viewDic setObjectFilterNull:mode.customername forKey:@"使用人姓名*"];
        //使用人性别性别 男:1,女:2
        _sexType = [mode.sex intValue];
        //使用人身份证号
        [viewDic setObjectFilterNull:mode.idnumber forKey:@"使用人身份证号*"];
        //紧急联系人姓名
        [viewDic setObjectFilterNull:mode.linkmanname forKey:@"紧急联系人姓名*"];
        //紧急联系人性别 性别 男:1,女:2
        _sexType2 = [mode.linkmansex intValue];
        //紧急联系人电话
        [viewDic setObjectFilterNull:mode.linkmanphone forKey:@"紧急联系人电话*"];
        //紧急联系人身份证号
        [viewDic setObjectFilterNull:mode.linkmanidnumber forKey:@"紧急联系人身份证号"];
        //brand
        [viewDic setObjectFilterNull:mode.brand forKey:@"电动车品牌*"];
        //电动车电机号
        [viewDic setObjectFilterNull:mode.generatornumber forKey:@"电动车电机号*"];
        //vin电动车车架号
        [viewDic setObjectFilterNull:mode.vin forKey:@"电动车车架号*"];
        //电动车颜色
        [viewDic setObjectFilterNull:mode.color forKey:@"电动车颜色*"];
        //电动车购买时间 //yyyy-MM-dd
        
        [viewDic setObjectFilterNull:mode.buytime forKey:@"电动车购买时间*"];
        //验证码
        
//        [viewDic setObjectFilterNull:mode.vCode forKey:@"手机短信验证码*"];
//accidentinsurance;//驾驶人意外保险,1:50/年,2:100/年,3:200/年
       // saveType;//3 200/年 4 100/年 5 50/年
        if ([@"1" isEqualToString:mode.accidentinsurance])
        {
            _saveType = 5;
        }
        else if ([@"2" isEqualToString:mode.accidentinsurance])
        {
            _saveType = 4;
        }
        else if ([@"3" isEqualToString:mode.accidentinsurance])
        {
            _saveType = 3;
        }
        //非必填
        //使用人身份证正面照片
        [viewDic setObjectFilterNull:mode.frontidcard forKey:@"使用人身份证正面照片url"];
        //使用人身份证反面照片
        [viewDic setObjectFilterNull:mode.reverseidcard forKey:@"使用人身份证反面照片url"];
        //使用人正面免冠照片
        [viewDic setObjectFilterNull:mode.frontphoto forKey:@"使用人正面免冠照片url"];
        //电动车上牌后照片
        [viewDic setObjectFilterNull:mode.bikephoto forKey:@"电动车上牌后照片url"];
        //电动车 车辆使用证明
        [viewDic setObjectFilterNull:mode.userprove forKey:@"车辆使用证明url"];
        //志愿者姓名
        [viewDic setObjectFilterNull:mode.volunteer forKey:@"志愿者姓名"];
        //车牌号码
        [viewDic setObjectFilterNull:mode.paltenumber forKey:@"车牌号码"];
        //防盗定位终端设备IMEI码
        [viewDic setObjectFilterNull:mode.imei forKey:@"设备号"];
        //防盗定位账号
        [viewDic setObjectFilterNull:mode.againsttheft forKey:@"防盗定位账号"];
        
    }
}
- (void)viewDidLoad
{
    if ([self.viewDic objectForKey:@"initType"] != nil)
    {
        self.initType = [[self.viewDic objectForKey:@"initType"] intValue];
        [self.viewDic removeObjectForKey:@"initType"];
    }
   
    [super viewDidLoad];
    
    self.arrayData = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"请输入用户名",@"用户名*",
                                                       @"请输入密码",@"密码(至少输入6位字符)*",
                                                       @"请输入手机号码",@"手机号码*",
                                                       @"请输入短信验证码",@"手机短信验证码*",
                                                       @"",@"登记地址*",
                                                       @"",@"常驻地所属居/村委会*", nil],[NSMutableArray arrayWithObjects:@"请输入使用人姓名",@"使用人姓名*",
                                                                                 @"请选择使用人性别",@"使用人性别*",
                                                                                 @"请输入使用人身份证号",@"使用人身份证号*",
                                                                                 @"请输入紧急联系人姓名",@"紧急联系人姓名*",
                                                                                 @"请选择紧急联系人性别",@"紧急联系人性别*",
                                                                                 @"请输入紧急联系人电话",@"紧急联系人电话*",
                                                                                 @"请输入紧急联系人身份证号",@"紧急联系人身份证号", nil],[NSMutableArray arrayWithObjects:@"",@"使用人身份证正面照片" ,nil],[NSMutableArray arrayWithObjects:@"",@"使用人身份证反面照片", nil],[NSMutableArray arrayWithObjects:@"",@"使用人正面免冠照片", nil],[NSMutableArray arrayWithObjects: @"请输入电动车品牌",@"电动车品牌*",
                                                                                                                                                                                                                                                                                                                                                 @"请输入电动车电机号",@"电动车电机号*",
                                                                                                                                                                                                                                                                                                                                                 @"请输入电动车车架号",@"电动车车架号*",
                                                                                                                                                                                                                                                                                                                                                 @"请输入电动车颜色",@"电动车颜色*",
                                                                                                                                                                                                                                                                                                                                                 @"请选择电动车购买时间",@"电动车购买时间*",
                                                                                                                                                                                                                                                                                                                                                 @"",@"驾驶人意外险", nil],[NSMutableArray arrayWithObjects:@"",@"电动车上牌后照片", nil],[NSMutableArray arrayWithObjects:@"",@"车辆使用证明", nil],[NSMutableArray arrayWithObjects: @"非必填",@"志愿者姓名",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     @"非必填",@"车牌号码",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     @"非必填",@"设备号",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     @"非必填",@"防盗定位账号", nil], nil];
    [self resetAllViewValues];
    //跟据需求初始化一次相关的值
    if (_initType == 0)
    {
        [viewDic setObjectFilterNull:@"868120210" forKey:@"设备号"];
        [viewDic setObjectFilterNull:@"130" forKey:@"使用人身份证号*"];
    }
    if (_initType == 1 && ![@"2" isEqualToString:[SingleDataManager instance].userInfoModel.state])
    {
        if (![NomalUtil isValueableString:[viewDic objectForKey:@"设备号"]])
        {
            [viewDic setObjectFilterNull:@"868120210" forKey:@"设备号"];
        }
        if (![NomalUtil isValueableString:[viewDic objectForKey:@"使用人身份证号*"]])
        {
            [viewDic setObjectFilterNull:@"130" forKey:@"使用人身份证号*"];
        }
    }
    [self initAllViews];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}
-(void)initAllViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImg = (UIImageView *)[self.contentView getSubViewInstanceWith:[UIImageView class]];
    UIImage *img = IMAGE_NAMED(@"register背景");
    
    [bgImg setFrameInSuperViewCenterTop:nil toTopSpace:StatusBarHeight+10 width:ScreenWidth height:ScreenWidth *img.size.height/img.size.width];
    [bgImg setImage:img];
   
    UILabel *lable1 = (UILabel *)[self.view getSubViewInstanceWith:[UILabel class]];
    lable1.font = [UIFont systemFontOfSize:40];
    lable1.textColor = Color_Nomal_Font_Blue;
    lable1.text = @"注 册";
    lable1.textAlignment = NSTextAlignmentLeft;
    [lable1 setFrameInSuperViewLeftTop:nil toLeftSpace:30 toTopSpace:60+StatusBarHeight width:120 height:50];
    
    if (_initType == 1)
    {
        lable1.hidden = YES;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    CGFloat topH = 150 +StatusBarHeight;
//    CGFloat space = 15;
//    self.tableView.frame = Rect(space, topH, ScreenWidth - space*2, self.contentView.height - topH);
    self.tableView.frame = Rect(0, topH, ScreenWidth, self.contentView.height - topH);
    self.tableView.mj_footer = nil;
    self.tableView.mj_header = nil;
//    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyle)]
    
//    self.tableView.style = UITableViewStyleGrouped;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell2" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell3" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell4" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell4"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell5" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell5"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell6" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell6"];
    self.tableView.backgroundColor = Color_Clear;
//    self.phoneCell =
//    (TwoLabelCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell2"];
    self.phoneCell = (TwoLabelCell *)[[[NSBundle mainBundle] loadNibNamed:@"TwoLabelCell2"
                                                 owner:self
                                               options:nil]
                   objectAtIndex:0];
//    self.validateCell = (TwoLabelCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell5"];;
    self.validateCell = (TwoLabelCell *)[[[NSBundle mainBundle] loadNibNamed:@"TwoLabelCell5"
                                                                    owner:self
                                                                  options:nil]
                                      objectAtIndex:0];
    //没通过审核
    if (_initType == 0 || ![@"2" isEqualToString:[SingleDataManager instance].userInfoModel.state])
    {
        CGFloat space = 30;
        CGFloat buttonH = 40;
        UIView *footView = [[UIView alloc] initWithFrame:Rect(0, 0, ScreenWidth, space*2 + buttonH + SAFE_AREA_INSETS_BOTTOM)];
        footView.backgroundColor = [UIColor clearColor];
        UIButton *button = (UIButton *)[footView getSubViewInstanceWith:[UIButton class]];
        [button setTitle:@"提 交" forState:UIControlStateNormal];
        button.backgroundColor = Color_Nomal_Bg;
        button.titleLabel.font = FFont_Default;
        [button setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
        
        [button setFrameInSuperViewCenterTop:nil toTopSpace:space width:ScreenWidth - 30 height:buttonH];
        [button setCornerRadius:4];
        kWeakSelf(self);
        [button addTapBlock:^(UIButton *btn)
         {
             //weakself.
             [weakself finishPressed];
         }];
        //    self.tableView.tableFooterView = nil;
        self.tableView.tableFooterView = footView;
        //    self.tableView.backgroundColor = [UIColor whiteColor];
    }
    
    [self.tableView reloadData];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_arrayData objectAtIndex:section];
//    NSArray *keys = [dic allKeys];
    return [array count]/2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//   TwoLabelCell * cell = (TwoLabelCell *)[tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell2"];
//    ;
    return [self renderTableViewCellWithIndexPath:indexPath isHeight:YES].height;
//    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    reuseCell = (TwoLabelCell *)[tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellK85"];
//    TwoLabelCell *cell = (TwoLabelCell *)[tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell2"];
//    [self renderViewCell:cell indexPath:indexPath isHeight:NO];
    return [self renderTableViewCellWithIndexPath:indexPath isHeight:NO];
//    return reuseCell;
//    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *sectionArray = [_arrayData objectAtIndex:indexPath.section];
    
    NSInteger rowKeyIndex = (indexPath.row + 1)*2-1;
    
//    NSInteger rowValueIndex = indexPath.row*2;
    NSString *keyString = [sectionArray objectAtIndex:rowKeyIndex];
    //0:围栏报警 1:拆除报警 2轨迹列表  3派出所列表选择 4居委会列表
    if ([@"登记地址*" isEqualToString:keyString])
    {
        [viewDic setObjectFilterNull:[keyString stringByReplacingOccurrencesOfString:@"*" withString:@""] forKey:@"viewTitle"];
        [viewDic setObjectFilterNull:@"3" forKey:@"initType"];
        [self pushToViewWithClassName:@"ListViewController"];
    }
    else if ([@"常驻地所属居/村委会*" isEqualToString:keyString])
    {
        [viewDic setObjectFilterNull:[keyString stringByReplacingOccurrencesOfString:@"*" withString:@""] forKey:@"viewTitle"];
        [viewDic setObjectFilterNull:@"4" forKey:@"initType"];
        [self pushToViewWithClassName:@"ListViewController"];
    }
    else if([@"电动车购买时间*" isEqualToString:keyString])
    {
        TSDateLocateView *loa = [TSDateLocateView initWithTitle:@"电动车购买时间" delegate:self];
        loa.buttonIndex = 1;
        [loa showInView:self.view];
        if ([viewDic objectForKey:@"电动车购买时间*"] != nil)
        {
            [loa setFirstValuesWithStr:[viewDic objectForKey:@"电动车购买时间*"]];
        }
        
    }
   
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_arrayData count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:Rect(0, 0, ScreenWidth, 30)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    return 30;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //圆率
    CGFloat cornerRadius = 8.0;
    CGFloat space = 15;
    //大小
    CGRect bounds = Rect(cell.bounds.origin.x+space, cell.bounds.origin.y, cell.bounds.size.width-space*2, cell.bounds.size.height);
    //行数
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    

    //绘制曲线
    UIBezierPath *bezierPath = nil;

    if (indexPath.row == 0 && numberOfRows == 1) {
        //一个为一组时,四个角都为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else if (indexPath.row == 0) {
        //为组的第一行时,左上、右上角为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else if (indexPath.row == numberOfRows - 1) {
        //为组的最后一行,左下、右下角为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else {
        //中间的都为矩形
        bezierPath = [UIBezierPath bezierPathWithRect:bounds];
    }
    bezierPath.lineWidth = 1;
//    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
//    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
    //cell的背景色透明
    cell.backgroundColor = [UIColor clearColor];
    //清除掉上次的样式
    CAShapeLayer *temp = [cell.layer getMyAssociatedObjectForKey:@"layer"];
    if (temp != nil)
    {
        [temp removeFromSuperlayer];
        
    }
    //新建一个图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    [cell.layer setMyAssociatedObject:layer forKey:@"layer"];
    //图层边框路径
    layer.path = bezierPath.CGPath;
    //图层填充色,也就是cell的底色
    layer.fillColor = [UIColor whiteColor].CGColor;
    //图层边框线条颜色
    /*
     如果self.tableView.style = UITableViewStyleGrouped时,每一组的首尾都会有一根分割线,目前我还没找到去掉每组首尾分割线,保留cell分割线的办法。
     所以这里取巧,用带颜色的图层边框替代分割线。
     这里为了美观,最好设为和tableView的底色一致。
     设为透明,好像不起作用。
     */
    layer.strokeColor = [UIColor colorWithHexString:@"2A2A2A"].CGColor;
    
    //将图层添加到cell的图层中,并插到最底层
    [cell.layer insertSublayer:layer atIndex:0];

}


- (void)renderFirstLable:(TwoLabelCell *)cell keyString:(NSString *)keyString space:(CGFloat)space {
    cell.backgroundColor = Color_Clear;
    cell.cellBackGroundView.backgroundColor = Color_Clear;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat cellHeight = 44;
    CGFloat viewHeight = 44;
    
    //    cell.frame = Rect(15, 0, ScreenWidth - 15*2, cellHeight);
    cell.frame = Rect(0, 0, ScreenWidth, cellHeight);
    cell.cellBackGroundView.frame = Rect(15, 0, ScreenWidth - 15*2, viewHeight);
    
    cell.firstLabel.text = keyString;
    cell.firstLabel.font = FFont_Default_Small;
    cell.firstLabel.textColor = Color_Nomal_Font_Gray;
    //-2定高度自动计算宽
    [cell.firstLabel setFrameInSuperViewHeightCenterAndLeft:nil toLeftSpace:space width:-2 height:30];
    [NomalUtil messageAction:cell.firstLabel changeString:@"*" andAllColor:cell.firstLabel.textColor andMarkColor:[UIColor redColor] font:cell.firstLabel.font];
    if ([@"2" isEqualToString:[SingleDataManager instance].userInfoModel.state])
    {
        cell.userInteractionEnabled = NO;
    }
}

-(void)buttonPressed1:(UIButton *)button
{
    if (button.tag == 1 || button.tag == 2|| button.tag == 11|| button.tag == 12)
    {
        if (button.selected == NO)
        {
            button.selected = YES;
            //男
            if (button.tag == 1)
            {
                _sexType = 1;
            }
            //女
            else if (button.tag == 2)
            {
                
                _sexType = 2;
            }
            
            //男
            if (button.tag == 11)
            {
                _sexType2 = 1;
            }
            //女
            else if (button.tag == 12)
            {
                _sexType2 = 2;
            }
        }
        UIView *superView = [button superview];
        for (UIView *view in [superView subviews])
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                if (button != view && view.tag > 0)
                {
                    UIButton *temp = (UIButton *)view;
                    temp.selected =  NO;
                }
            }
        }
    }
    else
    {
        //200/年
        if (button.tag == 3)
        {
            //            _saveType = 3;
            if (_saveType != 3)
            {
                _saveType = 3;
            }
            else
            {
                _saveType = 0;
            }
        }
        //100/年
        else if (button.tag == 4)
        {
            //            _saveType = 4;
            if (_saveType != 4)
            {
                _saveType = 4;
            }
            else
            {
                _saveType = 0;
            }
        }
        //50/年
        else if (button.tag == 5)
        {
            //            _saveType = 5;
            if (_saveType != 5)
            {
                _saveType = 5;
            }
            else
            {
                _saveType = 0;
            }
        }
        UITableViewCell *cell = [self getTabbleViewCellFrom:button];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }


}
-(TwoLabelCell *)renderTableViewCellWithIndexPath:(NSIndexPath *)indexPath isHeight:(BOOL)isHeight

{
    TwoLabelCell *cell = nil;
    NSArray *sectionArray = [_arrayData objectAtIndex:indexPath.section];
    
    NSInteger rowKeyIndex = (indexPath.row + 1)*2-1;
    
    NSInteger rowValueIndex = indexPath.row*2;
    NSString *keyString = [sectionArray objectAtIndex:rowKeyIndex];
    NSString *valueString = [sectionArray objectAtIndex:rowValueIndex];
    CGFloat space = 10;
    //驾驶人意外险
    if ([@"紧急联系人性别*" isEqualToString:keyString] || [@"驾驶人意外险" isEqualToString:keyString]||[@"使用人性别*" isEqualToString:keyString])
    {
        cell = (TwoLabelCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell6"];
        [self renderFirstLable:cell keyString:keyString space:space];
        [cell.thirdButton setImage:nil forState:UIControlStateNormal];
        [cell.thirdButton setImage:nil forState:UIControlStateSelected];
        [cell.thirdButton setTitle:nil forState:UIControlStateNormal];
        [cell.firstButton setTitleColor:Color_Nomal_Font_Gray forState:UIControlStateNormal];
        cell.firstButton.backgroundColor = [UIColor clearColor];
        [cell.firstButton setImage:IMAGE_NAMED(@"未选中") forState:UIControlStateNormal];
        [cell.firstButton setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
        
        cell.firstButton.titleLabel.font = FFont_Default_Small;
        [cell.firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        
//        [cell.firstButton setSelected:YES];
        
        [cell.firstButton addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.secondButton setTitleColor:Color_Nomal_Font_Gray forState:UIControlStateNormal];
        cell.secondButton.backgroundColor = [UIColor clearColor];
        [cell.secondButton setImage:IMAGE_NAMED(@"未选中") forState:UIControlStateNormal];
        [cell.secondButton setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
        
        cell.secondButton.titleLabel.font = FFont_Default_Small;
        [cell.secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        
        
        [cell.secondButton addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        [cell.firstButton setSelected:NO];
        [cell.secondButton setSelected:NO];
        [cell.thirdButton setSelected:NO];
        if ([@"使用人性别*" isEqualToString:keyString])
        {
            [cell.firstButton setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:space width:50 height:30];
            [cell.secondButton setFrameRightTopFromViewLeftTop:cell.firstButton leftToRightSpace:0 topToTopSpace:0 width:50 height:30];
            [cell.firstButton setTitle:@"男" forState:UIControlStateNormal];
            [cell.secondButton setTitle:@"女" forState:UIControlStateNormal];
            cell.firstButton.tag = 1;
            cell.secondButton.tag = 2;
            if (_sexType == 2)
            {
                //女
                [cell.secondButton setSelected:YES];
            }
            else
            {
                //男
                [cell.firstButton setSelected:YES];
            }
        }
        else if ([@"紧急联系人性别*" isEqualToString:keyString])
        {
            [cell.firstButton setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:space width:50 height:30];
            [cell.secondButton setFrameRightTopFromViewLeftTop:cell.firstButton leftToRightSpace:0 topToTopSpace:0 width:50 height:30];
            [cell.firstButton setTitle:@"男" forState:UIControlStateNormal];
            [cell.secondButton setTitle:@"女" forState:UIControlStateNormal];
            cell.firstButton.tag = 11;
            cell.secondButton.tag = 12;
            if (_sexType2 == 2)
            {
                //女
                [cell.secondButton setSelected:YES];
            }
            else
            {
                //男
                [cell.firstButton setSelected:YES];
            }
        }
        else if([@"驾驶人意外险" isEqualToString:keyString])
        {
            [cell.firstButton setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:space*ScalNum_Width width:75*ScalNum_Width height:30];
            [cell.secondButton setFrameRightTopFromViewLeftTop:cell.firstButton leftToRightSpace:0 topToTopSpace:0 width:75*ScalNum_Width height:30];
             [cell.thirdButton setFrameRightTopFromViewLeftTop:cell.secondButton leftToRightSpace:0 topToTopSpace:0 width:70*ScalNum_Width height:30];
            [cell.thirdButton setTitleColor:Color_Nomal_Font_Gray forState:UIControlStateNormal];
            cell.thirdButton.backgroundColor = [UIColor clearColor];
            [cell.thirdButton setImage:IMAGE_NAMED(@"未选中") forState:UIControlStateNormal];
            [cell.thirdButton setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
            [cell.thirdButton setTitle:@"" forState:UIControlStateNormal];
            cell.thirdButton.titleLabel.font = FFont_Default_Small;
            [cell.thirdButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            
           
            [cell.thirdButton addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.firstButton.tag = 3;
            cell.secondButton.tag = 4;
            cell.thirdButton.tag = 5;
            //3 200/年 4 100/年 5 50/年
            [cell.firstButton setTitle:@"200/年" forState:UIControlStateNormal];
            [cell.secondButton setTitle:@"100/年" forState:UIControlStateNormal];
            [cell.thirdButton setTitle:@"50/年" forState:UIControlStateNormal];
            //3 200/年 4 100/年 5 50/年
            if (_saveType == 3)
            {
                [cell.firstButton setSelected:YES];
            }
            else if (_saveType == 4)
            {
                [cell.secondButton setSelected:YES];
            }
            else if (_saveType == 5)
            {
                [cell.thirdButton setSelected:YES];
            }
            
        }
      
        
    }
    else if ([@"手机短信验证码*" isEqualToString:keyString])
    {
//        cell = (TwoLabelCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell5"];
        cell = _validateCell;
        [self renderFirstLable:cell keyString:keyString space:space];
        if (_timeNum == 60 || _timeNum == 0)
        {
            [cell.firstButton setTitle:@"获取" forState:UIControlStateNormal];
        }
        
        self.validateCodeButton = cell.firstButton;
        [cell.firstButton setTitleColor:Color_Nomal_Font_White forState:UIControlStateNormal];
        cell.firstButton.backgroundColor = [UIColor blackColor];
        cell.firstButton.titleLabel.font = FFont_Default_Small_12;
        [cell.firstButton setCornerRadius:4];
        [cell.firstButton setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:space width:50 height:25];
        kWeakSelf(self);
        [cell.firstButton addTapBlock:^(UIButton *btn) {
            if (![NomalUtil isPhoneNum:weakself.phoneTextField.text])
            {
                [weakself showViewMessage:@"请输入正确的手机号"];
                return;
            }
            RequestAction *request = [[RequestAction alloc] init];
            
            request.delegate = weakself;
            
            [request addAccessory:weakself];
            request.tag = 2;
            
            //手机号(必填)
            [request.parm setObjectFilterNull:[weakself.viewDic objectForKey:@"手机号码*"] forKey:@"phone"];
//            [request.parm setObjectFilterNull:[weakself.viewDic objectForKey:@"用户名*"] forKey:@"loginname"];
            //1：注册；2忘记密码；4：绑定手机
            [request.parm setObjectFilterNull:@"1" forKey:@"type"];
            //是否发短信 1是；0否
            [request.parm setObjectFilterNull:@"1" forKey:@"isSend"];
            [request request_sendValidateCode];
            [weakself startTimeClock];
        }];
        cell.myTextField.font = FFont_Default_Small;
        cell.myTextField.textColor = Color_Nomal_Font_Gray;
        cell.myTextField.placeholder = valueString;
        cell.myTextField.delegate = self;
        cell.myTextField.text = [viewDic objectForKey:keyString];
        
        [cell.myTextField setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:cell.cellBackGroundView.width - cell.firstButton.left + space width:cell.cellBackGroundView.width - cell.firstLabel.right - cell.firstButton.width - space * 3 height:30];
        
        
        
    }
    else if ([@"登记地址*" isEqualToString:keyString] || [@"常驻地所属居/村委会*" isEqualToString:keyString])
    {
        cell = (TwoLabelCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell4"];
        [self renderFirstLable:cell keyString:keyString space:space];
        UIImage *img =[IMAGE_NAMED(@"右箭头") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.arrowImg.image = img;
        [cell.arrowImg setTintColor:Color_Nomal_Font_Gray];
        [cell.arrowImg setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:space width:[self.view getPicScaleLen2:img.size.width] height:[self.view getPicScaleLen2:img.size.height]];
        cell.secondLabel.font = FFont_Default_Small;
        cell.secondLabel.textColor = Color_Nomal_Font_Gray;
        [cell.secondLabel setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:cell.cellBackGroundView.width - cell.arrowImg.left + space width:cell.cellBackGroundView.width - cell.firstLabel.right - cell.arrowImg.width - space * 3 height:cell.cellBackGroundView.height];
        
      
        cell.secondLabel.numberOfLines = 0;//可以多行
        cell.secondLabel.text = [viewDic objectForKey:keyString];
        CGFloat height = [cell.secondLabel.text heightForFont:cell.secondLabel.font width:cell.secondLabel.width];
        if (height + space * 2> cell.cellBackGroundView.height)
        {
            
            cell.height = height + space * 2;
            cell.secondLabel.height = cell.height;
            cell.cellBackGroundView.height = cell.height;
            cell.arrowImg.centerY = cell.height/2;
            cell.firstLabel.centerY = cell.height/2;
        }
    }
    else if ([@"使用人身份证正面照片" isEqualToString:keyString] || [@"使用人身份证反面照片" isEqualToString:keyString] || [@"使用人正面免冠照片" isEqualToString:keyString] || [@"电动车上牌后照片" isEqualToString:keyString] || [@"车辆使用证明" isEqualToString:keyString])
    {
        cell = (TwoLabelCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell3"];
        [self renderFirstLable:cell keyString:keyString space:space];
        
        UIImage *img = IMAGE_NAMED(@"加号");
        UIImage *tempImg = [viewDic objectForKey:keyString];
        if (tempImg != nil)
        {
            img = tempImg;
        }
        kWeakSelf(self);
        NSString *imgUrl = [weakself.viewDic objectForKey:[NSString stringWithFormat:@"%@url",keyString]];
        if (imgUrl != nil && [imgUrl length] > 0)
        {
            cell.secondButton.hidden = NO;
            [cell.secondButton setFrameInSuperViewRightTop:nil toRightSpace:10 toTopSpace:cell.firstLabel.top width:40 height:cell.firstLabel.height];
            [cell.secondButton setTitle:@"修改" forState:UIControlStateNormal];
            cell.secondButton.titleLabel.font = cell.firstLabel.font;
            [cell.secondButton setTitleColor:Color_Nomal_Font_Blue forState:UIControlStateNormal];
            [cell.secondButton addTapBlock:^(UIButton *btn) {
                [weakself uploadImageWithCell:indexPath keyString:keyString];
            }];
        }
        else
        {
            cell.secondButton.hidden = YES;
        }
        //审核通过
        if (_initType == 1 && [@"2" isEqualToString:[SingleDataManager instance].userInfoModel.state])
        {
            cell.secondButton.hidden = YES;
            cell.userInteractionEnabled = YES;
            if (imgUrl != nil && [imgUrl length] > 0)
            {
                cell.firstButton.enabled = YES;
            }
            else
            {
                cell.firstButton.enabled = NO;
            }
        }
        [cell.firstButton addTapBlock:^(UIButton *btn)
        {

            if (imgUrl != nil && [imgUrl length] > 0)
            {
//                btn.enabled = NO;
                //防止连续点击
                btn.enabled = NO;
//                btn.qi_eventInterval = 2;
                [SGImageBrowser show:btn.imageView autoLoadImageUrl:imgUrl];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    btn.enabled = YES;
                });
            }
            else
            {
                [weakself uploadImageWithCell:indexPath keyString:keyString];
            }
//            btn.enabled = YES;
            //640-1136.png
//            UIImageView *imgView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"640-1136.png")];
//            [SGImageBrowser show:imgView];
//            [SGImageBrowser show:nil autoLoadImageUrl:@"http://118.26.142.213:8080/travelplatform/image/2019-01-30/LMFAE9APNTQ9ND6X9WX82L63AWBP4NMX.jpg"];
        }];
        
        [cell.firstButton setBackgroundImage:nil forState:UIControlStateNormal];
        [cell.firstButton setImage:nil forState:UIControlStateNormal];
        if (tempImg == nil)
        {
            NSString *imgUrl = [viewDic objectForKey:[NSString stringWithFormat:@"%@url",keyString]];
            if (_initType == 1 && imgUrl != nil && [imgUrl length] > 0)
            {
                [cell.firstButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
                [cell.firstButton setFrameLeftTopFromViewLeftBottom:cell.firstLabel leftToLeftSpace:0 bottomToTopSpace:space width:cell.cellBackGroundView.width - space*2 height:200];
                cell.firstButton.centerX = cell.cellBackGroundView.width/2;
//                [cell.firstButton setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholder:[NomalUtil imageWithColor:[UIColor lightGrayColor]]];
                [cell.firstButton sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholderImage:[NomalUtil imageWithColor:[UIColor lightGrayColor]]];
            }
            else
            {
                [cell.firstButton setFrameLeftTopFromViewLeftBottom:cell.firstLabel leftToLeftSpace:0 bottomToTopSpace:space width:[self.view getPicScaleLen2:img.size.width] height:[self.view getPicScaleLen2:img.size.height]];
                cell.firstButton.centerX = cell.cellBackGroundView.width/2;
                [cell.firstButton setBackgroundImage:img forState:UIControlStateNormal];
            }
           
        }
        else
        {
            //http://118.26.142.213:8080/travelplatform/image/2019-01-30/LMFAE9APNTQ9ND6X9WX82L63AWBP4NMX.jpg

            //UIViewContentModeScaleAspectFit
            //UIViewContentModeScaleAspectFill
            [cell.firstButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
            
            [cell.firstButton setFrameLeftTopFromViewLeftBottom:cell.firstLabel leftToLeftSpace:0 bottomToTopSpace:space width:cell.cellBackGroundView.width - space*2 height:200];
            cell.firstButton.centerX = cell.cellBackGroundView.width/2;
            [cell.firstButton setImage:tempImg forState:UIControlStateNormal];
//            [cell.firstButton setImageWithURL:[NSURL URLWithString:@"http://118.26.142.213:8080/travelplatform/image/2019-01-30/LMFAE9APNTQ9ND6X9WX82L63AWBP4NMX.jpg"] forState:UIControlStateNormal placeholder:[NomalUtil imageWithColor:[UIColor lightGrayColor]]];
        }
        
        
        
        cell.height = cell.firstButton.bottom + space + 5;
        cell.cellBackGroundView.height = cell.height;
    }
    else
    {
        if ([@"手机号码*" isEqualToString:keyString] && _phoneCell!= nil)
        {
            cell = _phoneCell;
            self.phoneTextField = cell.myTextField;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
           cell = (TwoLabelCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell2"];
        }
        
        [self renderFirstLable:cell keyString:keyString space:space];
        //    cell.myTextField.text = [values objectAtIndex:indexPath.row];
        cell.myTextField.font = FFont_Default_Small;
        cell.myTextField.textColor = Color_Nomal_Font_Gray;
        cell.myTextField.placeholder = valueString;
        cell.myTextField.delegate = self;
        cell.myTextField.text = [viewDic objectForKey:keyString];
        cell.myTextField.userInteractionEnabled = YES;
        if([@"电动车购买时间*" isEqualToString:keyString])
        {
            cell.myTextField.userInteractionEnabled = NO;
            
        }
        else if ([@"密码(至少输入6位字符)*" isEqualToString:keyString])
        {
            cell.myTextField.keyboardType = UIKeyboardTypeASCIICapable;
        }
        else if ([@"用户名*" isEqualToString:keyString])
        {
            cell.myTextField.keyboardType = UIKeyboardTypeASCIICapable;
        }
       
        [cell.myTextField setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:space width:cell.cellBackGroundView.width - cell.firstLabel.right - space*2 height:30];
        
    }
    
    


    return cell;
}
#pragma mark-uploadImage

-(void)uploadImage
{
    
}

- (void)uploadImageToServer:(NSData *)data image:(UIImage *)image indexPath:(NSIndexPath *)indexPath keyString:(NSString *)keyString weakself:(RegisterViewController *const __weak)weakself {
    NSDictionary *dict = @{@"Filedata":data};
    //                [UIUtilities showMessage:@"正在上传(0%)" subMessage:nil isWindow:YES];
    [self showNetWaiting];
    [NetWorkCenter uploadFileFromData:dict methodName:@"" apiString:[SingleDataManager instance].versionModel.fileInterfaceAddress progress:^(NSProgress * _Nonnull progress) {
        //                    NSInteger frcation = progress.fractionCompleted*100;
        //                    [UIUtilities showMessage:[NSString stringWithFormat:@"正在上传(%ld%%)",(long)frcation] subMessage:nil isWindow:YES];
        
    } success:^(id  _Nonnull responseObject) {
        
        [self closeNetWaiting];
        if (responseObject)
        {
            NSDictionary * tmpDtata = responseObject[@"data"];
            NSString *imgPath = [tmpDtata objectForKeyFilterNSNull:@"relativePath"];
            if (imgPath && imgPath.length > 0)
            {
                [weakself.viewDic setObjectFilterNull:image forKey:keyString];
                
                [weakself.viewDic setObjectFilterNull:data forKey:[NSString stringWithFormat:@"%@data",keyString]];
                [weakself.viewDic setObjectFilterNull:imgPath forKey:[NSString stringWithFormat:@"%@url",keyString]];
                [weakself.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [self showViewMessage:@"上传错误！"];
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        [self closeNetWaiting];
        [self showViewMessage:@"上传错误！"];
    }];
}

- (void)uploadImageWithCell:(NSIndexPath *)indexPath keyString:(NSString *)keyString
{
    //UIAlertControllerStyleActionSheet
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"手机相册中选择", nil];
//    [sheet showInView:self.view];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet] ;
    kWeakSelf(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            BSImagePickerController *imagePicker = [BSImagePickerController imagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera finishHandle:^(UIImage *image, NSData *data) {
                
                [self uploadImageToServer:data image:image indexPath:indexPath keyString:keyString weakself:weakself];

                
                //                [self getUploadHeader:data complation:nil];
            }];
            
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            
            //            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            self.imagePickerController.allowsEditing = NO;
            //            [self presentViewController:self.imagePickerController animated:YES completion:NULL];
        }else{
            NSLog(@"模拟器无相机...");
        }
        
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BSImagePickerController *imagePicker = [BSImagePickerController imagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary finishHandle:^(UIImage *image, NSData *data) {
             [self uploadImageToServer:data image:image indexPath:indexPath keyString:keyString weakself:weakself];
//            [weakself.viewDic setObjectFilterNull:image forKey:keyString];
//
//            [weakself.viewDic setObjectFilterNull:data forKey:[NSString stringWithFormat:@"%@data",keyString]];
//            [weakself.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
            //            [self updatePhotoImage:image];
            //            [self uploadPhotoImage:data];
            
            //            [self getUploadHeader:data complation:nil];
            
        }];
//        imagePicker.edgesForExtendedLayout = UIRectEdgeNone;
        imagePicker.navigationBar.translucent = NO;//导航条能显示出来
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
 
        
    }]];

    [self presentViewController:alert animated:YES completion:^{
        
        
        
    }] ;

}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.tableView endEditing:NO];
//}

//#pragma mark - UIActionSeetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//
//            BSImagePickerController *imagePicker = [BSImagePickerController imagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera finishHandle:^(UIImage *image, NSData *data) {
//
////                [self getUploadHeader:data complation:nil];
//            }];
//
//            imagePicker.allowsEditing = NO;
//            [self presentViewController:imagePicker animated:YES completion:nil];
//
//
//            //            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            //            self.imagePickerController.allowsEditing = NO;
//            //            [self presentViewController:self.imagePickerController animated:YES completion:NULL];
//        }else{
//            NSLog(@"模拟器无相机...");
//        }
//    }else if (buttonIndex == 1){
//
//        /*
//         self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//         self.imagePickerController.allowsEditing = NO;
//         [self presentViewController:self.imagePickerController animated:YES completion:NULL];*/
//
//
//        BSImagePickerController *imagePicker = [BSImagePickerController imagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary finishHandle:^(UIImage *image, NSData *data) {
//
//            //            [self updatePhotoImage:image];
//            //            [self uploadPhotoImage:data];
//
////            [self getUploadHeader:data complation:nil];
//
//        }];
//        [self presentViewController:imagePicker animated:YES completion:nil];
//
//
//    }
//    NSLog(@"%@",actionSheet.title);
//}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    UIImage *imageEdit = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage *fixImage = [imageEdit fixOrientation];
//    NSData *imageData = UIImageJPEGRepresentation(fixImage, 0.1f);
//    [picker dismissViewControllerAnimated:YES completion:^{
//        [self getUploadHeader:imageData complation:nil];
//    }];
    
}

#pragma mark -responseData
-(BOOL)isPassRequest
{
    
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"用户名*"]])
    {
        [self showViewMessage:@"请输入用户名"];
        return NO;
    }
    
    if (_initType == 0 && ![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"密码(至少输入6位字符)*"]])
    {
        [self showViewMessage:@"请输入密码"];
        return NO;
    }
    if (![NomalUtil isPhoneNum:[viewDic objectForKeyWithStringValue:@"手机号码*"]])
    {
        [self showViewMessage:@"请输入正确的手机号"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"手机短信验证码*"]] || ![[viewDic objectForKeyWithStringValue:@"手机短信验证码*"] isEqualToString:_validateCode])
    {
        [self showViewMessage:@"请输入正确验证码"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"登记地址*id"]])
    {
        [self showViewMessage:@"请选择登记地址"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"常驻地所属居/村委会*id"]])
    {
        [self showViewMessage:@"请选择常驻地所属居/村委会"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"使用人姓名*"]])
    {
        [self showViewMessage:@"请输入使用人姓名"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"使用人身份证号*"]])
    {
        [self showViewMessage:@"请输入使用人身份证号"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"紧急联系人姓名*"]])
    {
        [self showViewMessage:@"请输入紧急联系人姓名"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"紧急联系人电话*"]])
    {
        [self showViewMessage:@"请输入正确紧急联系人电话"];
        return NO;
    }
//    if (![NomalUtil isValueableString:[viewDic objectForKey:@"紧急联系人身份证号"]])
//    {
//        [self showViewMessage:@"请输入紧急联系人身份证号"];
//        return NO;
//    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"电动车品牌*"]])
    {
        [self showViewMessage:@"请输入电动车品牌"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"电动车电机号*"]])
    {
        [self showViewMessage:@"请输入电动车电机号"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"电动车车架号*"]])
    {
        [self showViewMessage:@"请输入电动车车架号"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"电动车颜色*"]])
    {
        [self showViewMessage:@"请输入电动车颜色"];
        return NO;
    }
    if (![NomalUtil isValueableString:[viewDic objectForKeyWithStringValue:@"电动车购买时间*"]])
    {
        [self showViewMessage:@"请选择电动车购买时间"];
        return NO;
    }

    return YES;
}
-(void)finishPressed
{
    if (![self isPassRequest])
    {
        return;
    }
//    UITextField *textField1 = [_item1 viewWithTag:2];
//    UITextField *textField2 = [_item2 viewWithTag:2];
//    if (![NomalUtil isValueableString:textField1.text])
//    {
//        [self showViewMessage:@"用户名不能为空!"];
//        return;
//    }
//    else if (![NomalUtil isValueableString:textField2.text])
//    {
//        [self showViewMessage:@"密码不能为空!"];
//        return;
//    }
    RequestAction *request = [[RequestAction alloc] init];
    
    //[request.baseUrl ];
    
    request.delegate = self;
    
    [request addAccessory:self];
    request.tag = 1;
    
    
    //登录用户名
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"用户名*"] forKey:@"loginname"];
    if (_initType == 0)
    {
        //密码
        [request.parm setObjectFilterNull:[[viewDic objectForKeyWithStringValue:@"密码(至少输入6位字符)*"] md5] forKey:@"password"];
    }

    //手机号码
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"手机号码*"] forKey:@"mobilephone"];
    //登记地址
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"登记地址*id"] forKey:@"companyid"];
    //常驻地所属居/村委会
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"常驻地所属居/村委会*id"] forKey:@"groupid"];
    //使用人姓名
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"使用人姓名*"] forKey:@"customername"];
    //使用人性别性别 男:1,女:2
    
    [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%d",_sexType] forKey:@"sex"];
    //使用人身份证号
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"使用人身份证号*"] forKey:@"idnumber"];
    //紧急联系人姓名
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"紧急联系人姓名*"] forKey:@"linkmanname"];
    //紧急联系人性别 性别 男:1,女:2
    [request.parm setObjectFilterNull:[NSString stringWithFormat:@"%d",_sexType2] forKey:@"linkmansex"];
    //紧急联系人电话
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"紧急联系人电话*"] forKey:@"linkmanphone"];
    //紧急联系人身份证号
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"紧急联系人身份证号"] forKey:@"linkmanidnumber"];
    //brand
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"电动车品牌*"] forKey:@"brand"];
    //电动车电机号
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"电动车电机号*"] forKey:@"generatornumber"];
    //vin电动车车架号
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"电动车车架号*"] forKey:@"vin"];
    //电动车颜色
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"电动车颜色*"] forKey:@"color"];
    //电动车购买时间 //yyyy-MM-dd
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"电动车购买时间*"] forKey:@"buytime"];
    //验证码
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"手机短信验证码*"] forKey:@"vCode"];
    
    //保险
    //accidentinsurance;//驾驶人意外保险,1:50/年,2:100/年,3:200/年
    // saveType;//3 200/年 4 100/年 5 50/年
    if (_saveType > 0)
    {
        NSString *accidentinsurance = @"1";
        if (_saveType == 5)
        {
            accidentinsurance = @"1";
        }
        else if (_saveType == 4)
        {
            accidentinsurance = @"2";
        }
        else if (_saveType == 3)
        {
            accidentinsurance = @"3";
        }
        [request.parm setObjectFilterNull:accidentinsurance forKey:@"accidentinsurance"];
    }

    
    //非必填
    //使用人身份证正面照片
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"使用人身份证正面照片url"] forKey:@"frontidcard"];
    //使用人身份证反面照片
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"使用人身份证反面照片url"] forKey:@"reverseidcard"];
    //使用人正面免冠照片
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"使用人正面免冠照片url"] forKey:@"frontphoto"];
    //电动车上牌后照片
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"电动车上牌后照片url"] forKey:@"bikephoto"];
    //电动车 车辆使用证明
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"车辆使用证明url"] forKey:@"userprove"];
    //志愿者姓名
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"志愿者姓名"] forKey:@"volunteer"];
    //车牌号码
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"车牌号码"] forKey:@"paltenumber"];
    //防盗定位终端设备IMEI码
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"设备号"] forKey:@"imei"];
    //防盗定位账号
    [request.parm setObjectFilterNull:[viewDic objectForKeyWithStringValue:@"防盗定位账号"] forKey:@"againsttheft"];
    //区别注册和更新，更新的时候传这两参数
    if ([SingleDataManager instance].userInfoModel != nil && _initType == 1)
    {
        [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.customerid forKey:@"customerid"];
        [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.productId forKey:@"productId"];
        
    }
    [request request_RegisteBike];
}
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    if (request.tag == 1)//注册
    {
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        //         NSLog(@"%@",response);
        if ([@"10000" isEqualToString:response.code])
        {
            UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
            [SingleDataManager instance].userInfoModel = mode;
            //            [[DataBaseUtil instance] updateClassWidthObj:mode searchKey:@"userId" searchValue:mode.userId];
            [[DataBaseUtil instance] deleteObjWithClass:NSClassFromString(@"UserInfoModel")];
            [[DataBaseUtil instance] addClassWidthObj:mode];
            NSLog(@"%@",mode);
            if (_initType == 0)
            {
                [self.viewDic removeAllObjects];
                [self pushToViewWithClassName:@"MainViewController"];
            }
            else
            {
                [self showViewMessage:@"修改成功!"];
            }
            
        }
        else
        {
            [self showViewMessage:response.message];
        }
        
    }
    
    else if (request.tag == 2)//验证码
    {
        //request.responseString
        Response *response =  [Response modelWithJSON:request.responseData];
        //         NSLog(@"%@",response);
        //验证码做本地较验
        self.validateCode = response.validateCode;
        [self showViewMessage:response.message];
        
    }
    
    
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    [super requestFailed:request];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    UITableViewCell *cell = [self getTabbleViewCellFrom:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    NSArray *sectionArray = [_arrayData objectAtIndex:indexPath.section];

    NSInteger rowKeyIndex = (indexPath.row + 1)*2-1;

    //    NSInteger rowValueIndex = indexPath.row*2;
    NSString *keyString = [sectionArray objectAtIndex:rowKeyIndex];
    //    NSString *valueString = [sectionArray objectAtIndex:rowValueIndex];
    //变化后的值
    NSString *textValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //密码要做下较验
    if ([@"密码(至少输入6位字符)*" isEqualToString:keyString])
    {
        if (![NomalUtil isValidateUserPwd:textValue])
        {
            [self showViewMessage:@"只允许输入数字，字母和下划线，且不超过30个字符!"];
            return NO;
        }
    }
    if ([NomalUtil isValueableString:textValue])
    {
        [viewDic setObjectFilterNull:textValue forKey:keyString];
    }
    else
    {
        [viewDic setObjectFilterNull:@"" forKey:keyString];
    }
   
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        TSDateLocateView *locateView = (TSDateLocateView *)actionSheet;
        NSString *month = (locateView.monthContent.length < 2)?[NSString stringWithFormat:@"0%@",locateView.monthContent]:locateView.monthContent;
        NSString *day = (locateView.dayContent.length < 2)?[NSString stringWithFormat:@"0%@",locateView.dayContent]:locateView.dayContent;
        NSString *tempDate = [NSString stringWithFormat:@"%@-%@-%@",locateView.yearContent,month,day];
        [viewDic setObjectFilterNull:tempDate forKey:@"电动车购买时间*"];
        [self.tableView reloadData];
    }
   
}
#pragma mark-时钟相关
-(void)startTimeClock
{
    // 创建定时器
    if (self.timerClock == nil)
    {
        self.timerClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    }
    
    _timeNum = 60;
    [self.timerClock fire];
}
-(void)stopTimeClock
{
    _validateCodeButton.userInteractionEnabled = YES;
    [_validateCodeButton setTitle:@"获取" forState:UIControlStateNormal];
    // 停止定时器
    [self.timerClock invalidate];
    self.timerClock = nil;
}
-(void)changeTime
{
    
    _timeNum --;
    if (_timeNum > 0)
    {
        _validateCodeButton.userInteractionEnabled = NO;
        [_validateCodeButton setTitle:[NSString stringWithFormat:@"%d",_timeNum] forState:UIControlStateNormal];
    }
    else
    {
        
        [self stopTimeClock];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self stopTimeClock];
    [super viewWillDisappear:animated];
}
@end

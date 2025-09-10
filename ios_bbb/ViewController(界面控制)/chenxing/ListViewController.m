//
//  ListViewController.m
//  BaseProject
//
//  Created by janker on 2019/1/25.
//  Copyright © 2019 ChenXing. All rights reserved.
//

#import "ListViewController.h"
#import "TwoLabelCell.h"
#import "AlarmEfenceModel.h"
#import "AlarmDismantleModel.h"
@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
//0:围栏报警 1:拆除报警 2轨迹列表  3派出所列表选择 4居委会列表
@property (nonatomic, assign)int initType;
@property (nonatomic, strong)NSMutableArray *arrayData;//总数据
@end

@implementation ListViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:[self className] bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    self.arrayData = [NSMutableArray arrayWithCapacity:10];
    self.removeFooterRequest = YES;
    if ([self.viewDic objectForKey:@"initType"] != nil)
    {
        self.initType = [[self.viewDic objectForKey:@"initType"] intValue];
        [self.viewDic removeObjectForKey:@"initType"];
    }
    self.leftNavBtnName = @"返回";
    self.title = [self.viewDic objectForKey:@"viewTitle"];
    [viewDic removeObjectForKey:@"viewTitle"];
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell"];
    [self.tableView reloadData];
    [self sendRequest];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -tableview delegate
-(void)headerRereshing
{
    NSLog(@"aaaa");
    [self sendRequest];
}
-(void)footerRereshing
{
    NSLog(@"bbbb");
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwoLabelCell *cell = (TwoLabelCell *)[tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell"];
    [self renderViewCell:cell indexPath:indexPath];
    return cell.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    reuseCell = (TwoLabelCell *)[tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellK85"];
    TwoLabelCell *cell = (TwoLabelCell *)[tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell"];
    [self renderViewCell:cell indexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //0:围栏报警 1:拆除报警 2轨迹列表  3派出所列表选择 4居委会列表
    if (_initType == 0 || _initType == 1)
    {
        if (_initType == 0)
        {
            AlarmEfenceModel* model = [_arrayData objectAtIndex:indexPath.row];
            [viewDic setObjectFilterNull:model.longitude forKey:@"longitude"];
            [viewDic setObjectFilterNull:model.latitude forKey:@"latitude"];
            [viewDic setObjectFilterNull:model.alarmType forKey:@"alarmType"];
            [viewDic setObjectFilterNull:model forKey:@"AlarmEferceModel"];
            //AlarmEferceModel
        }
        else if (_initType == 1)
        {
            AlarmDismantleModel* model = [_arrayData objectAtIndex:indexPath.row];
            [viewDic setObjectFilterNull:model.longitude forKey:@"longitude"];
            [viewDic setObjectFilterNull:model.latitude forKey:@"latitude"];
            [viewDic setObjectFilterNull:@"拆除" forKey:@"alarmType"];
        }
        
        [self.viewDic setObject:@"1" forKey:@"initType"];//报警位置
        [self pushToViewWithClassName:@"PositionViewController"];
    }
    else if (_initType == 2)
    {
        
        [self pushToViewWithClassName:@"PlayBackViewController"];
    }
    else if (_initType == 3 || _initType == 4)
    {
        NSDictionary *dic = [_arrayData objectAtIndex:indexPath.row];
        
        [viewDic setObjectFilterNull:[dic objectForKey:@"name"] forKey:[NSString stringWithFormat:@"%@*",self.title]];
        [viewDic setObjectFilterNull:[dic objectForKey:@"id"] forKey:[NSString stringWithFormat:@"%@*id",self.title]];
        if (_initType == 3)
        {
            [viewDic removeObjectForKey:@"常驻地所属居/村委会*id"];
            [viewDic removeObjectForKey:@"常驻地所属居/村委会*"];
        }
        [self leftNavBtnPressed:nil];
    }
   
}
-(TwoLabelCell *)renderViewCell:(TwoLabelCell *)cell indexPath:(NSIndexPath *)indexPath

{
    cell.backgroundColor = Color_Clear;
    cell.cellBackGroundView.backgroundColor = Color_Clear;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat cellHeight = 65;
    CGFloat viewHeight = 55;
    ////0:围栏报警 1:拆除报警 2轨迹列表
    if (_initType == 2)
    {
        cellHeight = 75;
        viewHeight = 65;
    }
    cell.frame = Rect(0, 0, ScreenWidth, cellHeight);
//    cell.contentView.frame = Rect(0, (cellHeight - viewHeight)/2, ScreenWidth, cellHeight);
    cell.cellBackGroundView.frame = Rect(15, (cellHeight - viewHeight)/2, ScreenWidth - 15*2, viewHeight);
    [cell.cellBackGroundView setCornerRadius:4];
    [cell.cellBackGroundView setBorder:Color_Nomal_Harf_White width:2];
    cell.cellBackGroundView.backgroundColor = Color_Nomal_Bg;
    //51*55
    ////0:围栏报警 1:拆除报警 2轨迹列表
    UIImage *image = nil;
    if (_initType == 1)
    {
        image = IMAGE_NAMED(@"拆除报警icon");
    }
    else if (_initType == 2)
    {
        image = IMAGE_NAMED(@"轨迹回放icon");
    }
    else
    {
        image = IMAGE_NAMED(@"围栏报警icon");
    }
    //image.size
    cell.arrowImg.image = image;
    [cell.arrowImg setFrameInSuperViewHeightCenterAndLeft:nil toLeftSpace:Space_Normal width:[self.view getPicScaleLen2:image.size.width] height:[self.view getPicScaleLen2:image.size.height]];
    [cell.firstLabel setFrameLeftTopFromViewRightTop:cell.arrowImg rightToLeftSpace:10 topToTop:0 width:300 height:30];
    cell.firstLabel.centerY = cell.cellBackGroundView.height/2;
    cell.firstLabel.font = FFont_Default;
    cell.firstLabel.textColor = Color_Nomal_Font_White;
    //2019年01月01日 08:30-09:40
    cell.firstLabel.text = @"";



    image = IMAGE_NAMED(@"右箭头");
    //image.size
    cell.arrowImg2.image = image;
    [cell.arrowImg2 setFrameInSuperViewHeightCenterAndRight:nil toRightSpace:Space_Normal width:[self.view getPicScaleLen2:image.size.width] height:[self.view getPicScaleLen2:image.size.height]];
    //AlarmDismantleModel
    
    ////0:围栏报警 1:拆除报警 2轨迹列表
    if (_initType == 0)
    {
        AlarmEfenceModel* model = [_arrayData objectAtIndex:indexPath.row];
        cell.firstLabel.text = model.alarmTime;
    }
    else if (_initType == 1)
    {
        AlarmDismantleModel* model = [_arrayData objectAtIndex:indexPath.row];
        cell.firstLabel.text = model.alarmTime;
    }
    else if (_initType == 2)
    {
        [cell.secondLabel setFrameLeftTopFromViewRightTop:cell.arrowImg rightToLeftSpace:10 topToTop:0 width:300 height:30];
        cell.secondLabel.centerY = cell.cellBackGroundView.height/2;
        cell.secondLabel.font = FFont_Default;
        cell.secondLabel.textColor = Color_Nomal_Font_White;
        cell.secondLabel.text = @"行驶里程：10公里";
        cell.firstLabel.top = 5;
        cell.secondLabel.bottom = cell.cellBackGroundView.height - 5;
    }
    else if (_initType == 3 || _initType == 4)
    {
        NSDictionary *dic = [_arrayData objectAtIndex:indexPath.row];
        cell.firstLabel.text = [dic objectForKey:@"name"];
        cell.arrowImg.hidden = YES;
        cell.firstLabel.numberOfLines = 0;
        [cell.firstLabel setFrameInSuperViewHeightCenterAndLeft:nil toLeftSpace:Space_Normal width:cell.cellBackGroundView.width - Space_Normal*2 -cell.arrowImg2.width height:-2];
        
        if (cell.firstLabel.height + 30 > cell.height)
        {
            cell.height = cell.firstLabel.height + 30;
            cell.cellBackGroundView.height = cell.height;
            cell.arrowImg2.centerY = cell.height/2;
            cell.firstLabel.centerY = cell.height/2;
        }
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//登录
-(void)sendRequest
{
    //0:围栏报警 1:拆除报警 2轨迹列表  3派出所列表选择 4居委会列表
    //request_getAlarmDismantle
    if (_initType == 0)
    {
        RequestAction *request = [[RequestAction alloc] init];
        
        request.delegate = self;
        
        [request addAccessory:self];
        
        request.tag = 0;
        //设备号
        [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.idc forKey:@"idc"];
        [request request_getAlarmEfence];
    }
    else if (_initType == 1)
    {
        RequestAction *request = [[RequestAction alloc] init];
        
        request.delegate = self;
        
        [request addAccessory:self];
        
        request.tag = 1;
        //设备号
        [request.parm setObjectFilterNull:[SingleDataManager instance].userInfoModel.idc forKey:@"idc"];
        [request request_getAlarmDismantle];
    }
    if (_initType == 3)
    {
        RequestAction *request = [[RequestAction alloc] init];
        
        request.delegate = self;
        
        [request addAccessory:self];
        
        request.tag = 3;

        [request request_getRegisterAddress];
    }
    else if (_initType == 4)
    {
        RequestAction *request = [[RequestAction alloc] init];
        
        request.delegate = self;
        
        [request addAccessory:self];
        
        request.tag = 4;
        //登记地址的主键id
        [request.parm setObjectFilterNull:[viewDic objectForKey:@"登记地址*id"] forKey:@"id"];
        [request request_getLiveOftenAddress];
    }

}
#pragma mark -responseData
-(void)requestFinished:(__kindof YTKBaseRequest *)request
{
    if (request.tag == 0 || request.tag == 1)
    {
        //request.responseString
        [_arrayData removeAllObjects];
        Response *response =  [Response modelWithJSON:request.responseData];
        //         NSLog(@"%@",response);
        if ([@"10000" isEqualToString:response.code])
        {
            NSArray * array = (NSArray *)response.data;
            for (NSDictionary *dic in array)
            {
                if (request.tag == 1)
                {
                    [_arrayData addObject:[AlarmDismantleModel modelWithJSON:dic]];
                }
                else if (request.tag == 0)
                {
                    [_arrayData addObject:[AlarmEfenceModel modelWithJSON:dic]];
                }
                
            }
            if (request.tag == 1)
            {
                
                AlarmDismantleModel *model = [_arrayData firstObject];
                [kUserDefaults setObject:model.alarmId forKey:[NSString stringWithFormat:@"%@dismantleID",[SingleDataManager instance].userInfoModel.idc]];
            }
            else if (request.tag == 0)
            {
                AlarmEfenceModel *model = [_arrayData firstObject];
                [kUserDefaults setObject:model.alarmId forKey:[NSString stringWithFormat:@"%@efenceID",[SingleDataManager instance].userInfoModel.idc]];
            }
            [kUserDefaults synchronize];
            if (_arrayData == nil || [_arrayData count] == 0)
            {
                [self showNoDataImage];
            }
            else
            {
                [self removeNoDataImage];
            }
            [self.tableView reloadData];
            //            self.arrayData = (NSArray *)response.data;
            //            UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
            
        }
        else
        {
            [self showViewMessage:response.message];
        }
        
    }
    else if (request.tag == 3 || request.tag == 4)
    {
        //request.responseString
        [_arrayData removeAllObjects];
        Response *response =  [Response modelWithJSON:request.responseData];
        //         NSLog(@"%@",response);
        if ([@"10000" isEqualToString:response.code])
        {
            NSArray * array = (NSArray *)response.data;
            for (NSDictionary *dic in array)
            {
                [_arrayData addObject:dic];
            }
            if (_arrayData == nil || [_arrayData count] == 0)
            {
                [self showNoDataImage];
            }
            else
            {
                [self removeNoDataImage];
            }
            [self.tableView reloadData];
//            self.arrayData = (NSArray *)response.data;
//            UserInfoModel *mode = [UserInfoModel modelWithJSON:response.data];
           
        }
        else
        {
            
            if (request.tag == 4 && [@"10002" isEqualToString:response.code])
            {
                [self showViewMessage:@"请先选择登记地址!"];
            }
            else
            {
                [self showViewMessage:response.message];
            }
            
        }
        
    }
    
    
}
-(void)requestFailed:(__kindof YTKBaseRequest *)request
{
    [super requestFailed:request];
}
@end

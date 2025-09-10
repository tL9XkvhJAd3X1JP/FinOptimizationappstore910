//
//  SelectControl.m
//  GeneralMerchandiseStore
//
//  Created by user on 14-5-15.
//  Copyright (c) 2014年 maqianli. All rights reserved.
//

#import "DropDownControl.h"

@interface DropDownControl()
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UIButton *btnSender;
@property(strong,nonatomic)NSMutableArray *list;
@property(assign,nonatomic)int dropDownId;
@property(assign,nonatomic)int selectedIndex;
@property(assign,nonatomic)float dropHeight;
@property(strong,nonatomic)UIFont *cellFont;
@property(assign,nonatomic)float cellHeight;
@end

@implementation DropDownControl

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

-(id)initDropDown:(UIButton *)button dataSourceArr:(NSArray *)dataSourceArr dropDownId:(int)dropDownId delegate:(id)delegate{
    self = [super init];
    if (self)
    {
        _dropDownId=dropDownId;
        _delegate=delegate;
        _btnSender=button;
        CGRect btn = button.frame;
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        self.list = [NSMutableArray arrayWithArray:dataSourceArr];
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _table.delegate = self;
        _table.dataSource = self;
       // _table.layer.cornerRadius = 5;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.layer.masksToBounds = YES;
        _table.layer.cornerRadius = 5.0;
        _table.layer.borderWidth = 1.0;
        _table.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [button.superview addSubview:self];
        [self addSubview:_table];
  }
    return self;
    
}

-(id)initDropDown:(UIButton *)button dataSourceArr:(NSArray *)  dataSourceArr cellFont:(UIFont *) cellFont dropHeight:(float) dropHeight dropDownId:(int)dropDownId delegate:(id)delegate
{
    self = [super init];
    if (self)
    {
        _dropDownId=dropDownId;
        _delegate=delegate;
        _btnSender=button;
        _dropHeight = dropHeight;
        _cellFont = cellFont;
        CGRect btn = button.frame;
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        self.list = [NSMutableArray arrayWithArray:dataSourceArr];
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _table.delegate = self;
        _table.dataSource = self;
        // _table.layer.cornerRadius = 5;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.layer.masksToBounds = YES;
        _table.layer.cornerRadius = 5.0;
        _table.layer.borderWidth = 1.0;
        _table.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [button.superview addSubview:self];
        [self addSubview:_table];
    }
    return self;
}


-(id)initDropDown:(UIButton *)button dataSourceArr:(NSArray *)dataSourceArr dropDownId:(int)dropDownId delegate:(id)delegate hasDelete:(BOOL)hasDelete
{
    
    id s= [self initDropDown:button dataSourceArr:dataSourceArr dropDownId:dropDownId delegate:delegate];
    
    if (hasDelete == YES)
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.width, 25)];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 40, 25)];
        tipLabel.text = @"请选择";
        tipLabel.textColor = [UIColor darkGrayColor] ;
        tipLabel.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:tipLabel];
        UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        delButton.tag = dropDownId;
        [delButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        delButton.frame = CGRectMake(button.frame.size.width - 40, 0, 40, 25);
        [delButton setTitle:@"清空" forState:UIControlStateNormal];
        [delButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [delButton addTarget:self action:@selector(deleteDataArr:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:delButton];
        self.table.tableHeaderView = headerView;
    }
    return s;
}

-(id)initDropDown:(UIButton *)button dataSourceArr:(NSArray *)  dataSourceArr cellFont:(UIFont *) cellFont cellHeight:(float) cellHeight dropHeight:(float) dropHeight dropDownId:(int)dropDownId delegate:(id)delegate
{
    
    self = [super init];
    if (self)
    {
        _dropDownId=dropDownId;
        _delegate=delegate;
        _btnSender=button;
        _cellHeight = cellHeight;
        _dropHeight = dropHeight;
        _cellFont = cellFont;
        CGRect btn = button.frame;
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        self.list = [NSMutableArray arrayWithArray:dataSourceArr];
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _table.delegate = self;
        _table.dataSource = self;
        // _table.layer.cornerRadius = 5;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.layer.masksToBounds = YES;
        _table.layer.cornerRadius = 5.0;
        _table.layer.borderWidth = 1.0;
        _table.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [button.superview addSubview:self];
        [self addSubview:_table];
    }
    return self;}



- (void)deleteDataArr:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清空吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = button.tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.list removeAllObjects];
        [_table reloadData];
        [_delegate deleteDataArr:alertView.tag];
    }
}
-(int)showOrHideDropDown:(int)selectedIndex
{
    _isShow = NO;
    if (_dropHeight == 0)
    {
        _dropHeight = 140;
    }
    if ([self.list count]>0)
    {
        _selectedIndex=selectedIndex;
        [_table reloadData];
        
        CGRect btn = _btnSender.frame;
        if (self.frame.size.height==0)
        {
            
            _isShow = YES;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, _dropHeight);
                _table.frame = CGRectMake(0, 0, btn.size.width, _dropHeight);
            } completion:^(BOOL finished) {
                ;
            }];
            return 1;
        }
        else
        {
            CGRect btn = _btnSender.frame;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
                _table.frame = CGRectMake(0, 0, btn.size.width, 0);
            } completion:^(BOOL finished) {
                ;
            }];
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

-(int)hideDropDown
{
    _isShow = NO;
    if (_btnSender!=nil) {
        CGRect btn = _btnSender.frame;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            _table.frame = CGRectMake(0, 0, btn.size.width, 0);
        } completion:^(BOOL finished) {
            ;
        }];
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_cellHeight == 0 )
    {
        return 20;
    }
    else
    {
        return _cellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    if (_cellFont)
    {
        cell.textLabel.font = _cellFont;
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text =[_list objectAtIndex:indexPath.row];
//    if (indexPath.row==_selectedIndex) {
//        cell.textLabel.textColor = [UIColor redColor];
//    }
//    else
//    {
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
    
    //cell.textLabel.textColor = [UIColor colorWithRed:62.0/255 green:149.0/255 blue:189.0/255 alpha:1.0];
    if(indexPath.row%2==0){
        cell.backgroundColor=[UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    }else{
        cell.backgroundColor=[UIColor colorWithRed:253.0/255 green:253.0/255 blue:253.0/255 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showOrHideDropDown:(int)indexPath.row];
    if ([_delegate respondsToSelector:@selector(selectedText:dropDownId:)])
    {
        [_delegate selectedText:[self.list objectAtIndex:indexPath.row] dropDownId:_dropDownId];
    }
    
    if ([_delegate respondsToSelector:@selector(selectedIndex:dropDownId:)])
    {
        [_delegate selectedIndex:indexPath.row dropDownId:_dropDownId];
    }
    
    if([_delegate respondsToSelector:@selector(selectedIndex:selectText:dropDownId:)])
    {
        [_delegate selectedIndex:indexPath.row selectText:[_list objectAtIndex:indexPath.row] dropDownId:_dropDownId];
    }
    
}


-(void)refreshDataSourceArr:(NSArray *)dataSourceArr
{
    self.list = [NSMutableArray arrayWithArray:dataSourceArr];
    
    [_table reloadData];
}
@end

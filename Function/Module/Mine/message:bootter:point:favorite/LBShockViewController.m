//
//  LBShockViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/28.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBShockViewController.h"
#import "UtilsMacro.h"
#import "UMessage.h"

static NSString *cid=@"cid";
@interface LBShockViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *_tableView;
@end

@implementation LBShockViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"声音震动";
    self.view.backgroundColor=[UIColor whiteColor];
    [self setTableView];
}
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nameArray=@[@"每日上新专题消息",@"每到一条订单消息",@"每到一条财富消息",@"新到一条苏格商学院消息",@"每到一条客户消息"];
    UISwitch *messageSwicth=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70,10, 60,60)];
    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
    }
    cell.textLabel.text=nameArray[row];
    [cell.contentView addSubview:messageSwicth];
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *remindLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    if (section==0) {
        remindLabel.text=@"震动";
        remindLabel.textColor=[UIColor grayColor];
        return remindLabel;
    }else if(section==1)
    {
        remindLabel.text=@"声音";
        remindLabel.textColor=[UIColor grayColor];
        return remindLabel;
    }
    return remindLabel;
}


@end

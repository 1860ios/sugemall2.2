//
//  LBAboutViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/29.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBAboutViewController.h"
#import "UtilsMacro.h"
#import "MobClick.h"
#import "LBFeedbackViewController.h"

static NSString *cid=@"cid";
@interface LBAboutViewController ()<UITableViewDelegate,UITableViewDataSource>{

}
@property (nonatomic,strong) UITableView *_tableView;

@end
@implementation LBAboutViewController
@synthesize _tableView;
- (void)viewDidLoad
{
    self.title = @"关于";
   self.view.backgroundColor = [UIColor whiteColor];
    [self setTableView];
    [self initHeadView];
}
#pragma mark 苏格图标
-(void)initHeadView
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    
    UIImageView *sugeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-37, 20, 85, 85)];
    sugeImageView.image=IMAGE(@"关于苏格_03");
    [headerView addSubview:sugeImageView];
    
    UILabel *banbenLabel=[[UILabel alloc]initWithFrame:CGRectMake(sugeImageView.frame.origin.x, sugeImageView.frame.origin.y+sugeImageView.frame.size.height, sugeImageView.frame.size.width+5, 30)];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    CFShow((__bridge CFTypeRef)(infoDic));
    banbenLabel.text=appVersion;
    banbenLabel.font=FONT(14);
    banbenLabel.textAlignment = NSTextAlignmentCenter;
    banbenLabel.textColor=[UIColor blackColor];
    [headerView addSubview:banbenLabel];

    _tableView.tableHeaderView=headerView;
}
#pragma mark setTableView

- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorInset=UIEdgeInsetsMake(0, -11, 0,11);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}
#pragma mark setTableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
    }
    cell.selectionStyle=UITableViewCellAccessoryNone;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text =@"版本更新";
            CFShow((__bridge CFTypeRef)(infoDic));
            cell.detailTextLabel.text = appVersion;
            break;
//        case 1:
//            cell.textLabel.text =@"功能介绍";
//            break;
        case 1:
            cell.textLabel.text =@"联系客服";
            break;
//        case 3:
//            cell.textLabel.text =@"给APP投票";
//            break;
        case 2:
            cell.textLabel.text =@"建议反馈";
            break;
        default:
            break;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBFeedbackViewController *Feedback=[[LBFeedbackViewController alloc]init];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006203777"];
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            break;
        case 2:
            [self.navigationController pushViewController:Feedback animated:YES];
            break;
        default:
            break;
    }

}
#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于"];
}

@end

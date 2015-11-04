//
//  LBSetViewController.m
//  SuGeMarket
//
//  设置
//  Created by 1860 on 15/8/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBSetViewController.h"
#import "SUGE_API.h"
#import <AFNetworking.h>
#import "NotificationMacro.h"
#import "LBUserInfo.h"
#import "MBProgressHUD.h"
#import "AppMacro.h"
#import "UtilsMacro.h"
#import "LBAboutViewController.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBShockViewController.h"
#import "UMessage.h"
#import <UIImageView+WebCache.h>
#import "CustomIOSAlertView.h"
static NSString *cid = @"cid";

@interface LBSetViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *kUrl;
    UIButton *LognOut;//注销
    CGFloat folderSize;
    NSString *cachePath;
    CustomIOSAlertView *customAlertView;
    NSString *clearCacheName;
}
@property (nonatomic,strong) UITableView *_tableView;
@end

@implementation LBSetViewController
@synthesize _tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTableView];
}
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    
    //    __tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1||section==4) {
        return 50;

    }else if (section==2)
    {
        return 10;
    }else if (section==3)
    {
        return 60;

    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nameArray=@[@"新消息通知",@"声音震动",@"通知显示消息详情",@"夜间防骚扰模式",@"清空缓存数据"];
    
    NSInteger section = indexPath.section;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text=nameArray[section];
    UIButton *openButton=[UIButton buttonWithType:0];
    UISwitch *messageSwicth=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70,10, 60,60)];
    UISwitch *nightSwicth=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70,10, 60,40)];
    

    float tmpSize = [[SDImageCache sharedImageCache]checkTmpSize];
    clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"(%.2fM)",tmpSize] : [NSString stringWithFormat:@"(%.2fK)",tmpSize * 1024];
    
    switch (section) {
        case 0:
            //新消息通知按钮
            openButton.frame=CGRectMake(SCREEN_WIDTH-80,5, 70,40);
            [openButton setTitle:@"已开启" forState:UIControlStateNormal];
            [openButton setTitle:@"未开启" forState:UIControlStateSelected];
            [openButton setTitleColor:[UIColor grayColor] forState:0];
            [openButton addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:openButton];
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            //通知显示详情
            [cell.contentView addSubview:messageSwicth];
            break;
        case 3:
            //夜间防骚扰模式
            [cell.contentView addSubview:nightSwicth];
            break;
        case 4:
            
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",clearCacheName];
            cell.textLabel.textColor=[UIColor redColor];
            break;
        default:
            break;
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *remindLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
    if (section==1) {
        remindLabel.text=@"开启后,可以接收到新消息的提醒.";
        remindLabel.textColor=[UIColor grayColor];
        return remindLabel;
    }else if (section==3)
    {
        UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 60)];
        noticeLabel.text=@"开启后,当收到微客服消息时,通知提示将显示发信人和内容摘要.";
        noticeLabel.textColor=[UIColor grayColor];
        noticeLabel.numberOfLines=2;
        return noticeLabel;
    }else if (section==4)
    {
        remindLabel.text=@"开启后,苏格将自动屏蔽23:00-08:00间的任何提示.";
        remindLabel.textColor=[UIColor grayColor];
        return remindLabel;
    }
    return remindLabel;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//        footerView.backgroundColor = [UIColor yellowColor];
        LognOut = [UIButton buttonWithType:UIButtonTypeCustom];
        LognOut.frame = CGRectMake(20, 20, SCREEN_WIDTH-40, 40);
        [LognOut setTitle:@"退出当前账号" forState:0];
        LognOut.titleLabel.font = [UIFont systemFontOfSize:20];
        //        LognOut.layer.cornerRadius = 5;
        //        LognOut.layer.borderWidth = 1.5;
        //        LognOut.layer.borderColor = [APP_COLOR CGColor];
        [LognOut setBackgroundColor:RGBCOLOR(246, 29, 74)];
        [LognOut setTitleColor:[UIColor whiteColor] forState:0];
        [LognOut addTarget:self action:@selector(lognOut) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:LognOut];
        return footerView;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 50;
    }
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self._tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    switch (section) {
        case 1:{
            LBShockViewController *shock=[[LBShockViewController alloc]init];
            [self.navigationController pushViewController:shock animated:YES];
        }
            break;
        case 0:{
                [self loadVersionDatas];
        }
            break;
        case 4:{
            [self initCustom];

        }
            break;
    }
}

-(void)initCustom
{
    NSString *str=[NSString stringWithFormat:@"缓存大小为%@,确定要清理缓存吗?",clearCacheName];
    
    customAlertView=[[CustomIOSAlertView alloc]init];
    [customAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"提示", @"取消", @"确定", nil]];
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,300, 130)];
    demoView.layer.cornerRadius=6;
    demoView.backgroundColor=[UIColor whiteColor];
    demoView.alpha=0.93;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, demoView.frame.size.width, 20)];
    title.font=FONT(17);
    title.textAlignment=NSTextAlignmentCenter;
    [demoView addSubview:title];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, title.frame.origin.y+title.frame.size.height+10, demoView.frame.size.width, 20)];
    title1.textColor=[UIColor blackColor];
    title1.font=FONT(15);
    title1.textAlignment=NSTextAlignmentCenter;
    [demoView addSubview:title1];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, title1.frame.origin.y+title1.frame.size.height+20, demoView.frame.size.width, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.90 alpha:0.93];
    [demoView addSubview:lineView];
    
    UIButton *leftbutton=[UIButton buttonWithType:0];
    leftbutton.frame=CGRectMake(0,lineView.frame.origin.y+5, 150-1,40);
    [leftbutton setTitleColor:RGBCOLOR(0, 160, 233) forState:0];
    [leftbutton setTitle:@"取消" forState:0];
    leftbutton.backgroundColor=[UIColor whiteColor];
    [leftbutton addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
    [demoView addSubview:leftbutton];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(leftbutton.frame.origin.x+leftbutton.frame.size.width,lineView.frame.origin.y, 1, 45)];
    lineView1.backgroundColor=[UIColor colorWithWhite:0.90 alpha:0.93];
    [demoView addSubview:lineView1];
    
    UIButton *rightbutton=[UIButton buttonWithType:0];
    rightbutton.frame=CGRectMake(lineView1.frame.origin.x+1,leftbutton.frame.origin.y, 150-1,40);
    [rightbutton setTitleColor:RGBCOLOR(0, 160, 233) forState:0];
    [rightbutton setTitle:@"确定" forState:0];
    rightbutton.backgroundColor=[UIColor whiteColor];
    [rightbutton addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    [demoView addSubview:rightbutton];
    
    [customAlertView setContainerView:demoView];//把demoView添加到自定义的alertView中
    title.text = @"提示";
    title1.text =str;
    [customAlertView show];
}
-(void)clickLeft
{
    [customAlertView removeFromSuperview];
}
-(void)clickRight
{
    [[SDImageCache sharedImageCache] clearDisk];
    [_tableView reloadData];
    [customAlertView removeFromSuperview];
    //NSUserDefaults
}
//注销登录
#pragma mark  注销方法
- (void)lognOut
{
    NSString *username = [LBUserInfo sharedUserSingleton].userinfo_username;
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    if (username&&key) {
        [SVProgressHUD showWithStatus:@"正在注销" maskType:SVProgressHUDMaskTypeClear];
        
        AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter = @{@"username":username,@"key":key,@"client":@"ios"};
        maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        
        [maneger POST:SUGE_LOGOUT parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            
            NSLog(@"responObject:%@",responObject);
            NSString *str1 = responObject[@"datas"];
            NSLog(@"%@",str1);
            
           
            [NOTIFICATION_CENTER postNotificationName:SUGE_NOT_LOGNOUT1 object:nil];

            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"注销成功" subtitle:@"谢谢您的使用~" type:TSMessageNotificationTypeSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
            NSLog(@"注销失败:%@",error);
        }];
        
    }else{
        [TSMessage showNotificationWithTitle:@"您还没登陆呢" subtitle:@"请登陆后使用~" type:TSMessageNotificationTypeWarning];
    }
    
}
#pragma mark  新消息开启
-(void)clickClose:(UIButton *)btn
{
    if (btn.selected==NO) {
        NSLog(@"未开启");
        [UMessage unregisterForRemoteNotifications];
        btn.selected=YES;
    }else{
        NSLog(@"已开启");
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone];
        btn.selected=NO;
    }
}
+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
//检查更新版本
- (void)loadVersionDatas
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    [manager GET:SUGE_VERSION parameters:nil success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"版本更新:%@",responObject);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSString *kVersion = responObject[@"datas"][@"version"];
        kUrl = responObject[@"datas"][@"url"];
        if ([kVersion isEqualToString:appVersion]) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最新版本!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
        }else{
            UIAlertView *alertView= [[UIAlertView alloc]initWithTitle:@"提示" message:@"有新的版本更新，是否前往更新?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10001;
            [alertView show];
        }
    }failure:^(AFHTTPRequestOperation *op,NSError *error){
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10001) {
        if (buttonIndex==1) {
            //            NSURL *url = [NSURL URLWithString:kUrl];
            NSString *kurl = @"http://sugemall.com/app/?package/sugemall.ipa";
            NSURL *url = [NSURL URLWithString:kurl];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end

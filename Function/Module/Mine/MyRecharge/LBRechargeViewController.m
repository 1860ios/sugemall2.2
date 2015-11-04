//
//  LBRechargeViewController.m
//  SuGeMarket
//  充值
//  Created by 1860 on 15/10/9.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBRechargeViewController.h"
#import "UtilsMacro.h"
#import "LBBuyStep2ViewController.h"
#import <AFNetworking.h>
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import "SVProgressHUD.h"
#import "TSMessage.h"
@interface LBRechargeViewController ()
{
    NSString *pdr_amount;
 
}
@end

@implementation LBRechargeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"充值";
    [self initRecharge];
}
#pragma mark ==============数据==============
-(void)loadDatas
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"key":key,@"pdr_amount":pdr_amount};
    [manager POST:SUGE_ADDRECHARGE parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"responObject:%@",responObject);
        LBBuyStep2ViewController *buy=[[LBBuyStep2ViewController alloc]init];
        buy.pdr_amount=pdr_amount;
        buy.recId=responObject[@"datas"][@"pay_sn"];
        buy.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:buy animated:YES];
        //miss提示
        [SVProgressHUD dismiss];

    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"error:%@",error);
    }];

}
#pragma mark ==============充值==============
-(void)initRecharge
{
    UILabel *rechargeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 63+20, 100, 40)];
    rechargeLabel.text=@"充值金额";
    rechargeLabel.font=FONT(18);
    [self.view addSubview:rechargeLabel];
    
    UIButton *goldButton=[UIButton buttonWithType:UIButtonTypeCustom];
    goldButton.frame=CGRectMake(rechargeLabel.frame.origin.x, rechargeLabel.frame.origin.y+rechargeLabel.frame.size.height+20, SCREEN_WIDTH-40, 50);
    [goldButton setTitle:@"充值1000元升级为黄金会员" forState:0];
    goldButton.backgroundColor=RGBCOLOR(255, 163, 101);
    [goldButton addTarget:self action:@selector(pushBuy:) forControlEvents:UIControlEventTouchUpInside];
    goldButton.layer.cornerRadius = 10.0;
    goldButton.tag=100;
    [self.view addSubview:goldButton];
    
    UIButton *platinumButton=[UIButton buttonWithType:UIButtonTypeCustom];
    platinumButton.frame=CGRectMake(goldButton.frame.origin.x, goldButton.frame.origin.y+goldButton.frame.size.height+20, goldButton.frame.size.width, goldButton.frame.size.height);
    [platinumButton setTitle:@"充值2000元升级为铂金会员" forState:0];
    platinumButton.backgroundColor=RGBCOLOR(253, 97, 137);
    [platinumButton addTarget:self action:@selector(pushBuy:) forControlEvents:UIControlEventTouchUpInside];
    platinumButton.layer.cornerRadius = 10.0;
    platinumButton.tag=101;
    [self.view addSubview:platinumButton];
    
    UIButton *diamondButton=[UIButton buttonWithType:UIButtonTypeCustom];
    diamondButton.frame=CGRectMake(platinumButton.frame.origin.x, platinumButton.frame.origin.y+platinumButton.frame.size.height+20, platinumButton.frame.size.width, platinumButton.frame.size.height);
    [diamondButton setTitle:@"充值3000元升级为钻石会员" forState:0];
    diamondButton.backgroundColor=RGBCOLOR(166,126, 248);
    [diamondButton addTarget:self action:@selector(pushBuy:) forControlEvents:UIControlEventTouchUpInside];
    diamondButton.layer.cornerRadius = 10.0;
    diamondButton.tag=102;
    [self.view addSubview:diamondButton];
}

-(void)pushBuy:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
            pdr_amount=@"1000";
            break;
        case 101:
            pdr_amount=@"2000";
            break;
        case 102:
            pdr_amount=@"3000";
            break;
        default:
        break;
    }
    [self loadDatas];
}

@end

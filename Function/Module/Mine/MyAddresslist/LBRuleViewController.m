//
//  LBRuleViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/11/4.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBRuleViewController.h"
#import "SUGE_API.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import "LBUserInfo.h"
#import <TSMessage.h>
#import "UtilsMacro.h"
@interface LBRuleViewController ()

@end

@implementation LBRuleViewController

- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"合伙人规则";
    [super viewDidLoad];
    [self loadRuleDatas];
}
#pragma mark 获取数据
-(void)loadRuleDatas
{
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT )];
    [self.view addSubview:webView];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    NSString *a=@"合伙人规则";
    NSDictionary *parameter=@{@"article_title":a};
    
    [manager POST:SUGE_PARTNERRULE parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"合伙人规则%@",responseObject);
        NSURLRequest *quest=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:responseObject[@"datas"]]];
        [webView loadRequest:quest];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"Error:%@", error);
    }];
    [SVProgressHUD dismiss];
}
@end

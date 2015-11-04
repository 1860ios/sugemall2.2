//
//  SuGeMarket
//
//  Created by 1860 on 15/10/27.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBSetPasswordViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "LBValidateIdViewController.h"
#import "ZCTradeView.h"
#import "ZCTradeInputView.h"
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
#import <AFNetworking.h>
#import "TSMessage.h"
@interface LBSetPasswordViewController ()
{
    ZCTradeView *pswVC;
    ZCTradeInputView *ctrade;
    NSString *psw;
}
@end

@implementation LBSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置密码";
    pswVC = [[ZCTradeView alloc] init];
    self.view.backgroundColor =[UIColor colorWithWhite:0.97 alpha:0.93];
    [self initPasswordView];
}
-(void)initPasswordView
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushNext)];
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushNext1)];

    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 20+63,SCREEN_WIDTH-20, 80)];
    label1.text=@"重置密码";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.userInteractionEnabled=YES;
    label1.backgroundColor=[UIColor whiteColor];
    [label1 addGestureRecognizer:tap];
    [self.view addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(10,label1.frame.origin.y+label1.frame.size.height+15,SCREEN_WIDTH-20, 80)];
    label2.text=@"找回密码";
    label2.userInteractionEnabled=YES;
    label2.textAlignment=NSTextAlignmentCenter;
    label2.backgroundColor=[UIColor whiteColor];
    [label2 addGestureRecognizer:tap1];
    [self.view addSubview:label2];
}
-(void)pushNext
{
    psw  = nil;
    [pswVC show];
    __weak typeof(self) weakSelf = self;
    
    pswVC.finish = ^(NSString *passWord){
        psw = passWord;
        [weakSelf loadPassword];
    };
}
-(void)pushNext1
{
    LBValidateIdViewController *validateId=[[LBValidateIdViewController alloc]init];
    validateId.numString=_phone;
    [self.navigationController pushViewController:validateId animated:YES];
}
-(void)loadPassword
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_PD_CASH_ADD parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"提现:%@",responObject);

            [TSMessage showNotificationWithTitle:@"密码错误!请重新输入." type:TSMessageNotificationTypeWarning];
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
    }];
    //dimiss HUD
    [SVProgressHUD dismiss];
}
#pragma mark  验证支付密码
-(void)checkPsw
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    NSDictionary *parameter=@{@"key":key,@"password":psw};
    [manager POST:SUGE_CHECK_PASSWORD parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"datas"] isKindOfClass:[NSString class]]) {
            NSLog(@"是否正确%@",responseObject);
            [self loadPassword];
        }else{
            NSString *error = responseObject[@"datas"][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end

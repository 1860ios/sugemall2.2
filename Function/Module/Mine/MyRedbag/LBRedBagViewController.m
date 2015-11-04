//
//  LBRedBagViewController.m
//  SuGeMarket
//
//  Created by Apple on 15/10/19.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBRedBagViewController.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>
#import "SUGE_API.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import "LBUserInfo.h"
static NSString *cid=@"cid";
@interface LBRedBagViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *money;
    UILabel *numLabel;
    NSMutableArray *listMutableArray;
}
@property(nonatomic,strong)UITableView *_tableView;
@end
@implementation LBRedBagViewController
@synthesize _tableView;
-(void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [super viewDidLoad];
    [self initTableView];
    [self initHeadView];
    [self redBagDatas];
}
-(void)redBagDatas
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter;
    parameter = @{@"key":key};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_MYREDBAG parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        listMutableArray=responseObject[@"datas"][@"bonus_list"];
        if (responseObject[@"datas"][@"bonus_sum"]==NULL) {
            responseObject[@"datas"][@"bonus_sum"]=@"0";
        }else{
            numLabel.text=[NSString stringWithFormat:@"%@元",responseObject[@"datas"][@"bonus_sum"]];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [SVProgressHUD dismiss];
}
#pragma mark 上方
-(void)initHeadView
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    UIImageView *renzhengImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-37, 20, 70, 70)];
    renzhengImageView.contentMode = UIViewContentModeScaleAspectFit;
    renzhengImageView.layer.cornerRadius = 35;
    renzhengImageView.layer.masksToBounds  = YES;
    [renzhengImageView sd_setImageWithURL:[NSURL URLWithString:_iconString] placeholderImage:IMAGE(@"user_no_image.png")];
    [headerView addSubview:renzhengImageView];
    
    UILabel *banbenLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, renzhengImageView.frame.origin.y+renzhengImageView.frame.size.height, SCREEN_WIDTH, 20)];
    banbenLabel.text=[NSString stringWithFormat:@"%@共收到",_name];
    banbenLabel.font=FONT(14);
    banbenLabel.textColor=[UIColor lightGrayColor];
    banbenLabel.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:banbenLabel];
    _tableView.tableHeaderView=headerView;

    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(banbenLabel.frame.origin.x, banbenLabel.frame.origin.y+banbenLabel.frame.size.height, banbenLabel.frame.size.width, 40)];
    numLabel.font=FONT(30);
    numLabel.textAlignment=NSTextAlignmentCenter;
    numLabel.textColor=[UIColor redColor];
    [headerView addSubview:numLabel];
    _tableView.tableHeaderView=headerView;

}
#pragma mark initTableView
-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorInset=UIEdgeInsetsMake(0, -11, 0,11);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}
#pragma mark initTableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
    }
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    nameLabel.text=[NSString stringWithFormat:@"%@",listMutableArray[indexPath.row][@"member_name"]];
    nameLabel.font=FONT(13);
    nameLabel.textColor=[UIColor blackColor];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-100,nameLabel.frame.origin.y, 100, 20)];
    moneyLabel.text=[NSString stringWithFormat:@"%@元",listMutableArray[indexPath.row][@"member_amount"]];
    moneyLabel.font=FONT(13);
    moneyLabel.textAlignment=NSTextAlignmentRight;
    moneyLabel.textColor=[UIColor blackColor];
    [cell.contentView addSubview:moneyLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x,nameLabel.frame.origin.y+nameLabel.frame.size.height, SCREEN_WIDTH, 20)];
    NSString *time=listMutableArray[indexPath.row][@"add_time"];
    NSDate *date=[[NSDate alloc]initWithTimeIntervalSince1970:[time intValue]/1000.0];
    
    timeLabel.text=[NSString stringWithFormat:@"%@",date];
    timeLabel.font=FONT(12);
    timeLabel.textColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:timeLabel];

    return cell;
}
@end

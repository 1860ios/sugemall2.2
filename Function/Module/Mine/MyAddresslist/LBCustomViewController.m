//
//  LBCustomViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/25.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBCustomViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "TSMessage.h"
#import <MJRefresh.h>
#import "LBPartnerViewController.h"
static NSString *cid=@"cid";
@interface LBCustomViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSDictionary *dictionary;
    NSDictionary *dictionary1;
    
    NSMutableArray *customArray;
    NSMutableArray *DatasArray;
    int _curpage;
}
@property (nonatomic,strong)UITableView *_tableView;

@end

@implementation LBCustomViewController
@synthesize _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _curpage = 1;
    [self initTableView];
    self.title=@"我的客户";
    DatasArray = [NSMutableArray array];
    customArray = [NSMutableArray array];
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self loadCustomDatas:@"1"];
    [self setUpFooterRefresh];
}
- (void)setUpFooterRefresh
{
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    self._tableView.header.updatedTimeHidden = YES;
    // 设置文字
    [self._tableView.footer setTitle:@"加载更多客户..." forState:MJRefreshFooterStateIdle];
    [self._tableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self._tableView.footer setTitle:@"到头了..." forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    self._tableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    self._tableView.header.textColor = APP_COLOR;
}
- (void)loadNewData
{
    _curpage++;
    NSString *curnum = [NSString stringWithFormat:@"%d",_curpage];
    [self loadCustomDatas:curnum];
}
-(void)loadCustomDatas:(NSString *)curpage
{

    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    NSDictionary *parameter=@{@"key":key,@"pagesize":@"8",@"curpage":curpage};
 
    [manager POST:SUGE_CUSTOMLIST parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"客户%@",responseObject);
        [_tableView.footer endRefreshing];
        dictionary1=responseObject[@"datas"];
        customArray=dictionary1[@"custom_list"];
        if (customArray.count == 0) {
            [_tableView.footer noticeNoMoreData];
        }else{
        [DatasArray addObjectsFromArray:customArray];
        [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"Error:%@", error);
    }];
}
-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor redColor];
    _tableView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    _tableView.tableHeaderView = [UIView new];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=nil;
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    if (indexPath.section==1) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    
    //用户头像
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    userIcon.userInteractionEnabled = YES;
    userIcon.contentMode = UIViewContentModeScaleAspectFit;
    userIcon.layer.cornerRadius = 25;
    userIcon.layer.masksToBounds  = YES;
    [cell.contentView addSubview:userIcon];
    
    UILabel *cardLabel=[[UILabel alloc]initWithFrame:CGRectMake(userIcon.frame.origin.x+userIcon.frame.size.width+10, userIcon.frame.origin.y, 200, 20)];
    cardLabel.textAlignment=NSTextAlignmentLeft;
    cardLabel.textColor=[UIColor blackColor];
    cardLabel.font=FONT(15);
    [cell.contentView addSubview:cardLabel];
    
    UILabel *contributeLabel=[[UILabel alloc]initWithFrame:CGRectMake(cardLabel.frame.origin.x, cardLabel.frame.origin.y+cardLabel.frame.size.height, 200, 20)];
    contributeLabel.textAlignment=NSTextAlignmentLeft;
    contributeLabel.textColor=[UIColor lightGrayColor];
    contributeLabel.font=FONT(13);
    [cell.contentView addSubview:contributeLabel];
    
    UILabel *teamLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-200, contributeLabel.frame.origin.y, 200, 20)];
    teamLabel.textAlignment=NSTextAlignmentRight;
    teamLabel.textColor=[UIColor lightGrayColor];
    teamLabel.font=FONT(13);
    [cell.contentView addSubview:teamLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(contributeLabel.frame.origin.x, contributeLabel.frame.origin.y+contributeLabel.frame.size.height+10, SCREEN_WIDTH-userIcon.frame.size.width, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [cell.contentView addSubview:lineView];
    
    [userIcon sd_setImageWithURL:[NSURL URLWithString:DatasArray[indexPath.row][@"member_avatar"]] placeholderImage:IMAGE(@"myrefrere_Icon")];
    cardLabel.text=DatasArray[indexPath.row][@"member_name"];
    contributeLabel.text=[NSString stringWithFormat:@"贡献值:%@元",DatasArray[indexPath.row][@"contribution"]];
    teamLabel.text=[NSString stringWithFormat:@"团队值:%@人",DatasArray[indexPath.row][@"count_teams"]];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DatasArray.count;
}



@end

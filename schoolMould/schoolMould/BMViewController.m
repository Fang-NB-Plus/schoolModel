//
//  BMViewController.m
//  liangqing
//
//  Created by Macbook 13.3 on 2017/1/24.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "BMViewController.h"
#import "SDCycleScrollView.h"
#import "configHead.h"
#import "smallCell.h"
#import "WebViewComponent.h"
#import "AFHTTP.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

#define LTV   @"http://www.liangtv.cn"
#define LLURL @"https://uac.10010.com/oauth2/new_auth?display=wap&page_type=05&app_code=ECS-YH-WAP&redirect_uri=http://wap.10010.com/t/loginCallBack.htm&state=http://wap.10010.com/t/myunicom.htm&channel_code=11300000"
#define RURL  @"http://zhlq.nnwsl.com/index.php?s=/App/Act/get_app"
#define TURL  @"http://zhlq.nnwsl.com/index.php?s=/App/Act/banner"
@interface BMViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    CGFloat _cellh;
    SDCycleScrollView *_topView;
}
@property (nonatomic,strong) UITableView *bgtableView;
@property (nonatomic,strong) NSMutableArray *sourceArr;
@property (nonatomic,strong) NSMutableArray *topArr;
@end

@implementation BMViewController

-(NSMutableArray *)sourceArr{

    if (!_sourceArr) {
        _sourceArr = [NSMutableArray new];
    }
    return _sourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2, 40)];
//    lable.text = @"生活应用";
//    lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
//    lable.textColor = [UIColor whiteColor];
//    lable.backgroundColor = [UIColor clearColor];
//    lable.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = lable;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self installUI];
    [self requstData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x049b2f5);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:19],NSFontAttributeName,nil];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    NSString *path    = [[NSBundle mainBundle]pathForResource:@"keyWord" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    self.navigationItem.title = dic[@"secondName"];

}
- (void)installUI{

    self.bgtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT-40)];
    
    SDCycleScrollView *topView = [SDCycleScrollView new];
    topView.frame  = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.8);
    topView.autoScroll = YES;
    topView.delegate   = self;
    
    _topView = topView;
    self.bgtableView.tableHeaderView = topView;
    
    _sourceArr = [@[@{@"title":@"生活娱乐",
                      @"arr":@[@{@"image":@"logo_weixin",@"title":@"微信"},
                               @{@"image":@"logo_liang_tv",@"title":@"靓TV"},
                               @{@"image":@"logo_unicome",@"title":@"联通营业厅"},
                               @{@"image":@"icon_query",@"title":@"流量查询"},
                               @{@"image":@"dx",@"title":@"移动营业厅"},
                               @{@"image":@"yd",@"title":@"电信营业厅"}
                              
                              ]},
                    @{@"title":@"天气预报",
                      @"arr":@[@{@"image":@"icon_tianqi",@"title":@"良庆天气"}
                                ]}
                    ] mutableCopy];
    _bgtableView.dataSource = self;
    _bgtableView.delegate   = self;
    _bgtableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requstData];
    }];
    
    [self.view addSubview:_bgtableView];
    

}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions|kNilOptions error:nil];
    NSString *responseData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
   
    
    return responseData;
    
}
-(void)requstData{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@9,@"appid",@{@"devicetoken":uuid,@"did":@1,@"uid":@"",@"version":@"1.0.0"},@"data",@"",@"token", nil];
    NSString *toparams = [self dictionaryToJson:param];
    

    NSLog(@"%@",toparams);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"正在加载...";
    [AFHTTP post:RURL andParams:@{@"key":toparams} ifSuccess:^(id response) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_bgtableView.mj_header endRefreshing];
        NSDictionary *dic = (NSDictionary *)response;
        if ([dic[@"status"] integerValue]==0) {
            _sourceArr = dic[@"data"];
            
            [_bgtableView reloadData];
        }
        
        
    } orFailure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_bgtableView.mj_header endRefreshing];
    }];
    [AFHTTP post:TURL andParams:@{@"key":toparams} ifSuccess:^(id response) {
        if ([response[@"status"] integerValue]==0) {
            NSMutableArray *myArr = [NSMutableArray new];
            NSMutableArray *picArr= [NSMutableArray new];
            for (NSDictionary *dic in response[@"data"]) {
                [myArr addObject:dic];
                [picArr addObject:dic[@"imgurl"]];
            }
            _topArr = myArr;
            _topView.imageURLStringsGroup = picArr;
        }
        
        
    } orFailure:^(NSError *error) {
        
    }];
    
    
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    WebViewComponent *web = [WebViewComponent new];
    web.url = _topArr[index][@"jumpurl"];
    [self.navigationController pushViewController:web animated:YES];
}

-(void)actionWithName:(NSDictionary *)params{
    
    if ([params[@"url"] isEqualToString:@""]) {
        
        UIApplication *app = [UIApplication sharedApplication];
        
        NSURL *url = [NSURL URLWithString:@"weixin://weixin.qq.com"];
        if (![app canOpenURL:url]) {
            
            
            [app openURL:url];
        }
    }else{
    
        WebViewComponent *web = [WebViewComponent new];
        web.url = params[@"url"];
        [self.navigationController pushViewController:web animated:YES];
    
    }
}
- (CGFloat)fontsize{
    CGFloat a;
    if (isiPhone6or6s) {
        return 17;
    }
    if (isiPhone5or5sor5c) {
        return 16;
    }
    if (isiPhone6plusor6splus) {
        return 18;
    }
    
    return a;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableViewDelegete
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
    UILabel *lable   = [[UILabel alloc] initWithFrame:baseView.bounds];
    lable.text = [NSString stringWithFormat:@"  %@",self.sourceArr[section][@"title"]];
    lable.font = [UIFont systemFontOfSize:[self fontsize]];
    lable.textColor = [UIColor blackColor];
    
    return lable;
}*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return _cellh;
}


#pragma mark - UITableViewDataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _sourceArr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    smallCell *cell = [smallCell cellWithIndexPath:indexPath Dic:_sourceArr[indexPath.row] UITableView:tableView returnblock:^(CGFloat height) {
        _cellh = height;
    } andbtnBlock:^(NSDictionary *params) {
        [self actionWithName:params];
    }];
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

@end

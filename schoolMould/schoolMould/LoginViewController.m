//
//  LoginViewController.m
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/7.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "LoginViewController.h"
#import "configHead.h"
#import <CommonCrypto/CommonDigest.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "WSLBaseNetworking.h"
#import "userManager.h"
#import "AFHTTP.h"



@interface LoginViewController (){

    userModel *_myUser;

}
@property (nonatomic,strong)UITextField *userTF;    //用户名
@property (nonatomic,strong)UITextField *passwordTF;//密码
@property (nonatomic,strong)UIImageView *showImage; //大图
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self UIStatus];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x049b2f5);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:19],NSFontAttributeName,nil];
    //从bundle中取出plist
    NSString *path    = [[NSBundle mainBundle]pathForResource:@"keyWord" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    self.navigationItem.title = dic[@"schoolName"];
    
    _myUser          = [[userManager shareManager] userModel];
    _userTF.text     = _myUser.username;
    _passwordTF.text = _myUser.password;
}

- (void)UIStatus{
    //三个主要显示控件
    _userTF     = [[UITextField alloc] init];
    _passwordTF = [[UITextField alloc] init];
    _showImage  = [[UIImageView alloc] init];
    
    _showImage.image = [UIImage imageNamed:@"toppage.jpg"];
    
    _userTF.leftViewMode         = UITextFieldViewModeAlways;
    _passwordTF.leftViewMode     = UITextFieldViewModeAlways;
    _passwordTF.secureTextEntry  = YES;
    _userTF.keyboardType         = UIKeyboardTypeNumberPad;
    
    _userTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username_pro"]];
    _passwordTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_pro"]];
    
    //三个主要控制按钮
    UIButton *loginBtn = [UIButton new];
    UIButton *registBtn= [UIButton new];
    UIButton *backBtn  = [UIButton new];
    
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:UIColorFromRGB(0x049b2f5)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius  = 5;
    
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [backBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //三根线
    UIView *topLine         = [UIView new];
    UIView *midLine         = [UIView new];
    UIView *botLine         = [UIView new];
    
    topLine.backgroundColor = [UIColor grayColor];
    midLine.backgroundColor = [UIColor grayColor];
    botLine.backgroundColor = [UIColor grayColor];
    
    [self.view sd_addSubviews:@[_userTF,_passwordTF,_showImage,loginBtn,registBtn,backBtn,topLine,midLine,botLine]];
    
    _showImage.sd_layout
    .topSpaceToView(self.view,64)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(SCREENWIDTH*0.71);
    
    _userTF.sd_layout
    .topSpaceToView(_showImage,10)
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .heightIs(50);
    
    topLine.sd_layout
    .bottomSpaceToView(_userTF,-1)
    .leftEqualToView(_userTF)
    .rightEqualToView(_userTF)
    .heightIs(1);
    
    midLine.sd_layout
    .topSpaceToView(_userTF,2)
    .leftEqualToView(_userTF)
    .rightEqualToView(_userTF)
    .heightIs(1);
    
    _passwordTF.sd_layout
    .topSpaceToView(_userTF,5)
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .heightIs(50);
    
    botLine.sd_layout
    .topSpaceToView(_passwordTF,1)
    .leftEqualToView(_passwordTF)
    .rightEqualToView(_passwordTF)
    .heightIs(1);
    
    loginBtn.sd_layout
    .topSpaceToView(_passwordTF,20)
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .heightIs(50);
    
    registBtn.sd_layout
    .rightEqualToView(loginBtn)
    .widthIs(50)
    .heightIs(15)
    .topSpaceToView(loginBtn,15);
    
    backBtn.sd_layout
    .topSpaceToView(loginBtn,15)
    .leftSpaceToView(self.view,5)
    .heightIs(15)
    .widthIs(80);
    
}

- (void)login{
    NSMutableDictionary *dic = GETPLIST(@"keyWord");
    
    NSDictionary *params = @{@"username":_userTF.text,@"password":[self md5:_passwordTF.text]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"正在登陆...";
    [[WSLBaseNetworking shareManager] requstJSdatawithurl:dic[@"logurl"] method:Post paragram:params autoShowError:YES andCompleteBlock:^(id data, NSError *error, BOOL isConneted) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!isConneted) {
            return;
        }
        
        if (data) {
            _myUser           = [userModel new];
            _myUser.username  = _userTF.text;
            _myUser.password  = _passwordTF.text;
            _myUser.session_id= data[@"data"][@"session_id"];
            
            NSLog(@"登陆sessionid==%@",_myUser.session_id);
            [[userManager shareManager] setModel:_myUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
            
        }
        
        
        
    }];

}
-(NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

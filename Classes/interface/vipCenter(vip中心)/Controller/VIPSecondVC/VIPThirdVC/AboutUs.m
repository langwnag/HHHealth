//
//  AboutUs.m
//  客邦
//
//  Created by SZR on 16/4/7.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "AboutUs.h"

//#define DataArr @[@"版本更新",@"功能介绍",@"帮助"]
#define DataArr @[@"关于版本"]
@interface AboutUs ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)SZRTableView * tableView;
@property (nonatomic,strong) UILabel * versionLabel;
@property (nonatomic,copy) NSString * currentVersion;
@property(nonatomic,copy)NSString * lastVersion;
@end

@implementation AboutUs

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"关于我们"}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64) style:UITableViewStylePlain controller:self];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 150)];
    
    UIImageView * iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake((SZRScreenWidth-80)/2.0, 25, 80, 80)];
    iconImageV.image = [UIImage imageNamed:@"80*80"];
    iconImageV.layer.cornerRadius = 10.0f;
    iconImageV.layer.masksToBounds = YES;
    [headerView addSubview:iconImageV];
    //创建版本显示label
    [self createVersionLabel];
    [headerView addSubview:self.versionLabel];

    self.tableView.tableHeaderView = headerView;
}


-(void)createVersionLabel{
    
    self.versionLabel = [SZRFunction createLabelWithFrame:CGRectMake((SZRScreenWidth-120)/2.0, 115, 120, 20) color:[UIColor grayColor] font:[UIFont systemFontOfSize:14] text:nil];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    self.currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"合合 %@",self.currentVersion] withSubStr:self.currentVersion withColor:[UIColor grayColor] withFont:[UIFont systemFontOfSize:14]];
}


/*
#pragma mark 版本更新
- (void)VersionUpdata{
    //版本更新问题

    [[NSUserDefaults standardUserDefaults]setObject:@"version" forKey:self.currentVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [VDNetRequest VD_GetWithURL:VDVersonUpdata arrtribute:nil finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[@"error"]isEqualToString:@"0000"]) {
                VD_ShowBGBackError(NO);
            }else{
                NSArray * infoArr = responseObject[@"results"];
                NSDictionary * releaseInfo = [infoArr objectAtIndex:0];
                self.lastVersion = [releaseInfo objectForKey:@"version"];
//                [self compareVersion];
            }
        }else{
            VD_SHowNetError(NO);
        }
    }];

}
 */

#pragma mark 如果版本不一致需要更新
- (void)jumpAppStoreRequest{

    NSString * appStoreUrlStr = @"https://itunes.apple.com/us/app/ke-bang-shang-cheng/id1125927865?mt=8&uo=4";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrlStr]];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 3;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ABOUTUSCELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = DataArr[indexPath.row];
    cell.textLabel.text = DataArr[0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.lastVersion) {
//        //有
////        [self compareVersion];
//        
//    }else{
//        [self VersionUpdata];
//    }
    
}

-(void)compareVersion{
    if ([self.lastVersion compare:self.currentVersion] == NSOrderedDescending) {
        [self jumpAppStoreRequest];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您已经是最新版本!" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

}


- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

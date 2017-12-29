//
//  AppDelegate.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "SZRTabBarVC.h"
#import "HHLoginVC.h"
#import "DDMenuController.h"
#import "LeftVC.h"
#import "privateHealthVC.h"
#import "SZRGuideVC.h"
#import "AdvertiseView.h"
#import "HHRichContentMessage.h"
#import <UMSocialCore/UMSocialCore.h>
#import "RCDRCIMDataSource.h"
#import "PrivateDoctorModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "DWQPayManager.h"
#import "WXApi.h"
#import "HHVisitMessage.h"

@interface AppDelegate ()<CLLocationManagerDelegate,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,WXApiDelegate>
@property(nonatomic) int loginFailureTimes;
@property (nonatomic,strong)UINavigationController* nav ;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"nagvation_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 100, 10, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
    [self.window makeKeyAndVisible];
    
    //启动框架 对象持久化功能
    [[GlobalInfo getInstance] initialPersistedModels];
    
    [self loadVersionUpdata];
    [self setupRongCloud];
    //设置UM分享
    [self configUMShare];
    
    [self loadVC];
    
    //高德地图
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = @"0e5b23472180fa48d02e2ae586abc93c";
    
    //支付宝 / 微信
    [DWQPAYMANAGER dwq_registerApp];
    
    [self setUpBugly];
    
    //删除所有本地推送
    [application cancelAllLocalNotifications];
    
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    
    return YES;
}

#pragma mark 收集log日志
- (void)setUpBugly{
    [Bugly startWithAppId:BUGLY_APP_ID];
}
/**
 第一次加载
 */
-(void)loadVC{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:FIRST_START]){
        [DEFAULTS setObject:@"" forKey:CLIENTTOKEN];
        [DEFAULTS setObject:@"" forKey:RCDTOKEN];
        SZRGuideVC * guidVC = [[SZRGuideVC alloc]init];
        self.window.rootViewController = guidVC;
    }else{
        [self createLunchView];
    }
}



//加载起始页
-(void)createLunchView{
    AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
    advertiseView.filePath = @"";
    advertiseView.dismissBlock = ^(){
        [self loadMainVC];
    };
    [advertiseView show];
    
}

-(void)loadMainVC{
    SZRLog(@"[VDUserTools VD_GetToken] = %@",[VDUserTools VD_GetToken]);
    if ([[VDUserTools VD_GetToken] isEqualToString:@""]) {
        HHLoginVC * loginVC = [[HHLoginVC alloc]init];
        self.nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = self.nav;
    }else{
        [VDUserTools HH_ChangeDBPath];
        self.window.rootViewController = [DDMenuController shareDDMenuVC];
        
        [self tokenLogin];
    }
}

/**
 设置tabBarVC为根视图
 */
-(void)rootVCWithTabBarVC{
    self.window.rootViewController = [DDMenuController shareDDMenuVC];
    [self.window makeKeyAndVisible];
}

#pragma mark UM分享
-(void)configUMShare{
    [[UMSocialManager defaultManager]openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMSHARE_APPKEY];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    [self configUSharePlatforms];
}
-(void)configUSharePlatforms{
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105977034"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"4165957460"  appSecret:@"b9d22b9ca1cb9d8ffc537367d27a40e2" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    //微信
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx75b26c82a2b9b84d" appSecret:@"fb9a8e1fc99215d5ca6ad89e1977636a" redirectURL:@"http://mobile.umeng.com/social"];
}



#pragma mark token自动登录
-(void)tokenLogin{
    
    [VDNetRequest VD_GetHHToken:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [VDUserTools HH_SavePriviteDoctor:dic];
        });
        //登录融云
        [self loginRC];
    } BGError:^(id responseObject) {
        [self gotoLoginViewAndDisplayReasonInfo:@"登录失效，请重新登录!"];
    } Error:^{
    }];
}


#pragma mark 融云
- (void)setupRongCloud{
    
    // 初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    //提前注册
    [[RCIM sharedRCIM] registerMessageType:[HHVisitMessage class]];
    // 开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    // 开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE)];
    // 导航按钮字体颜色
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor whiteColor];
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
}

#pragma mark 请求RongCloud Token 连接rongCloud
- (void)loginRC{
    NSString* clientID = [DEFAULTS objectForKey:RCDCLIENTID];
    NSString* clinetName = [DEFAULTS objectForKey:CLIENTNAME];
    NSString* clientPortraitUri = [DEFAULTS objectForKey:CLIENTHEADPORTRATION];
    
    NSString* RCToken = [VDUserTools VD_GetRCToken];
    
    if (![[VDUserTools VD_GetRCToken] isEqualToString:@""]) {
        // 自己的用户信息
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:clientID
                                      name:clinetName
                                  portrait:clientPortraitUri];
        [[RCIM sharedRCIM] refreshUserInfoCache:_currentUserInfo withUserId:clientID];
        //  currentUserInfo 自己的用户信息
        [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
        
        [[RCIM sharedRCIM] connectWithToken:RCToken success:^(NSString *userId) {
            //好友列表之类设置
            SZRLog(@"");
            
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            //重新获取RCToken
            [self GetRCToken];
        }];
    }
}

// 请求融云接口
- (void)GetRCToken{
    [VDNetRequest VD_GetRongCloudToken:^(NSDictionary *dic) {
        
        [DEFAULTS setObject:dic[@"token"] forKey:RCDTOKEN];
        [DEFAULTS setObject:dic[@"id"] forKey:RCDCLIENTID];
        [DEFAULTS synchronize];
        NSString * clientID = [DEFAULTS objectForKey:RCDCLIENTID];
        NSString * clientName = [DEFAULTS objectForKey:CLIENTNAME];
        
        // 测试之后都能取到值
        RCUserInfo* user = [[RCUserInfo alloc] initWithUserId:clientID name:clientName portrait:[DEFAULTS objectForKey:CLIENTHEADPORTRATION]];
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:clientID];
        [RCIM sharedRCIM].currentUserInfo = user;
        [[RCIM sharedRCIM] connectWithToken:dic[@"token"] success:^(NSString *userId) {
            //好友列表之类设置
            SZRLog(@"");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kChangeUnReadMessageNum" object:self];
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            
        }];
        
    } BGError:^(id responseObject) {
        
    } Error:^{
        
    }];
    //同步好友信息
}

-(void)gotoLoginViewAndDisplayReasonInfo:(NSString *)reason{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showTextOnly:reason];
        [DEFAULTS setValue:@"" forKey:CLIENTTOKEN];
        [DEFAULTS setValue:@"" forKey:RCDTOKEN];
        HHLoginVC * loginVC = [[HHLoginVC alloc] init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    });
}

// 监听网络状态
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:
                              @"您的帐号在别的设备上登录，"
                              @"您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        HHLoginVC *loginVC = [[HHLoginVC alloc] init];
        UINavigationController * navi = [[UINavigationController alloc]
                                         initWithRootViewController:loginVC];
        self.window.rootViewController = navi;
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        NSDictionary* dataDic = @{@"token":[VDUserTools VD_GetToken]};
        [VDNetRequest VD_PostWithURL:VDCLIENTRCDTokenURL arrtribute:@{VDHTTPPARAMETERS:dataDic} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            if (!error && [responseObject[RESULT] boolValue]) {
                NSDictionary* userDic = [SZRFunction dictionaryWithJsonString:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
                [DEFAULTS setObject:userDic[@"token"] forKey:RCDTOKEN];
                [DEFAULTS synchronize];
                [[RCIM sharedRCIM]connectWithToken:userDic[@"token"] success:^(NSString *userId) {
                    
                } error:^(RCConnectErrorCode status) {
                    
                } tokenIncorrect:^{
                    
                }];
            }
            
        }];
    }
}



-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
    //已签约成功消息
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage * msg = (RCInformationNotificationMessage *)message.content;
        if ([msg.message rangeOfString:@"已签约成功"].location != NSNotFound) {
            //更新本地存储
            [VDUserTools HH_UpdateDoctorSignState:[[SZRFunction idWithRCID:message.targetId] intValue] signState:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kUpdatePrivateHealthVCCellSignedDoctor" object:self];
        }
    }
    
    if ([RCIMClient sharedRCIMClient].sdkRunningMode ==
        RCSDKRunningMode_Backgroud &&
        0 == left) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_DISCUSSION),
                                                                             @(ConversationType_APPSERVICE),
                                                                             @(ConversationType_PUBLICSERVICE),
                                                                             @(ConversationType_GROUP)
                                                                             ]];
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        unreadMsgCount;
        
    }
}





-(void)applicationDidBecomeActive:(UIApplication *)application{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // 每次程序进入后台时，记得归档全部需要持久化的对象
    [[GlobalInfo getInstance] persistModels];
    
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[@(ConversationType_PRIVATE)]];
        
        application.applicationIconBadgeNumber = unreadMsgCount;
        
    }
}
//推送处理2  注册用户通知设置
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

#pragma mark - 版本更新
- (void)loadVersionUpdata{
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    [DEFAULTS setObject:@"version" forKey:currentVersion];
    [DEFAULTS synchronize];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    [mgr POST:HHVerson_UpdataURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * infoArr = responseObject[@"results"];
        if (infoArr.count !=0) {
            NSDictionary * releaseInfo = [infoArr objectAtIndex:0];
            NSString * lastVersion = [releaseInfo objectForKey:@"version"];
            //字符串比较
            if ([lastVersion compare:currentVersion] == NSOrderedDescending) {
                //调用更新弹出视图
                [self alertUpdateProgram];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SZRLog(@"error %@",error);
        VD_SHowNetError(NO);
    }];
}

//AlertView
-(void)alertUpdateProgram
{
    UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"有新的版本，马上去更新吧" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上去更新", nil];
    [aleart show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSString * appStoreUrlStr = @"https://itunes.apple.com/us/app/id1187795698?l=zh&ls=1&mt=8";
    NSString * appStoreUrlStr =@"https://itunes.apple.com/cn/app/%E5%90%88%E5%90%88%E5%81%A5%E5%BA%B7/id1187795698?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrlStr]];
    
}

/**
 *  @author DevelopmentEngineer-DWQ
 *
 *  最老的版本，最好也写上
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [DWQPAYMANAGER dwq_handleUrl:url];
}
/**
 *  @author DevelopmentEngineer-DWQ
 *
 *  iOS 9.0 之前 会调用
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [DWQPAYMANAGER dwq_handleUrl:url];
}
/**
 *  @author DevelopmentEngineer-DWQ
 *
 *  iOS 9.0 以上（包括iOS9.0）
 */

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    
    return [DWQPAYMANAGER dwq_handleUrl:url];
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}




- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

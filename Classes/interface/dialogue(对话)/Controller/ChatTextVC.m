
//  ChatTextVC.m
//  TextRongCloud_Demo
//
//  Created by 莱昂纳德 on 16/7/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChatTextVC.h"
#import "SZRCollectionView.h"
#import "SZRTableView.h"
#import "functionView.h"
#import "RealTimeLocationEndCell.h"
#import "RealTimeLocationStartCell.h"
#import "RealTimeLocationStatusView.h"
#import "RealTimeLocationViewController.h"

// 新加送礼物
#import "GiftView.h"
#import "UIView+LYAdd.h"
#import "GiftBarrageView.h"
#import "GiftBarrage.h"
#import "HHRichContentMessageCell.h"
#import "HHRichContentMessage.h"

// 签约信息model
#import "HHAddUserInformation.h"
#import "RCDataBaseManager.h"
// 签约医生
#import "SignDoctorView.h"
// 电话咨询
#import "BackGroundView.h"
// 上门家纺
#import "SendServiceOrderVC.h"
// 在线问诊
#import "OnlineVisitsView.h"
// 服务订单
#import "ServiceOrderView.h"

// 医生简介
#import "DoctorIntroductionVC.h"
#import "PrivateDoctorModel.h"

#import "SigningStatesCell.h"
#import "RCDTestMessage.h"
#import "HHVisitMessage.h"
#import "TestCell.h"
#import "NSString+LYString.h"
#import "PayVC.h"
#import "OrderDetailsVC.h"

/*!
 消息Cell点击的回调  RCMessageCellDelegate（我们要点击cell，播放视频，所以要遵守这个代理，然后实现点击cell的方法）
 */
@interface ChatTextVC ()<RCMessageCellDelegate,RCRealTimeLocationObserver,
RealTimeLocationStatusViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,GiftViewDelegate>

@property(nonatomic, weak) id<RCRealTimeLocationProxy> realTimeLocation;
@property(nonatomic, strong)
RealTimeLocationStatusView *realTimeLocationStatusView;
@property (nonatomic,strong) UILabel*positionLabel,*functionLabel,*pennantsSeveralLa,*highPraiseLa;

@property (nonatomic,strong) GiftView* giftView;// 送礼物View
@property (nonatomic,strong) GiftBarrage* giftService;
@property (nonatomic, strong) UIView *dismissGiftView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIView* topView;//表头
@property (nonatomic,strong) functionView* fuctionV;
@property (nonatomic,assign) BOOL isMinus;//+ -

@property (nonatomic,strong) SignDoctorView* signDoctorView;
@property (nonatomic,strong) BackGroundView* backGroundView;
@property (nonatomic,strong) OnlineVisitsView* onlineVisitsView;
@property (nonatomic,strong) ServiceOrderView * serviceOrderView;

@property (nonatomic,strong) LoginModel *logModel;

@property (nonatomic,assign) NSInteger signState;

@property (nonatomic, assign) NSString * tmpId;

@end

@implementation ChatTextVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //在进入聊天界面时候  对于主动发送（direction == 1）的 objectName == HH:custom进行全部删除
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.conversationDataRepository];
    for (RCMessageModel * model in arr) {
        
        if (model.messageDirection == 1 && [model.objectName isEqualToString:@"HH:custom"]) {
            [self deleteMessage:model];
        }
    }
    
    self.displayUserNameInCell = NO;
    self.tabBarController.tabBar.hidden = YES;
    // 设置表情包颜色
    self.chatSessionInputBarControl.emojiBoardView.backgroundColor = RGBCOLOR(248, 248, 248);
    
    // 因为下个界面导航栏设置透明的，所以在viewWillAppear里面设置导航
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"nagvation_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 100, 10, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [self.giftService startBarrage];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSMutableArray * tmpArr = [NSMutableArray arrayWithArray:self.conversationDataRepository];
    for (RCMessageModel * model in tmpArr) {
        if([model.content isKindOfClass:[HHVisitMessage class]]){
            HHVisitMessage * visitMessage = (HHVisitMessage *)model.content;
            NSDictionary * dict = [SZRFunction dictionaryWithJsonString:visitMessage.parameterJson];
            NSString * homeServiceId = dict[@"homeServiceId"];
            NSString * tmpServiceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LY_SERVICE_ID"];
            if ([homeServiceId isEqualToString:tmpServiceId]) {
                [self deleteMessage:model];
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.giftService stopBarrage];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.logModel = [VDUserTools VDGetLoginModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendPaySuccessMessage:) name:@"OrderPaySuccessful" object:nil];
    
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    //聊天界面的背景颜色
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
#pragma mark 发送礼物
    //在功能面板上插入一个Item，用来发送锦旗，并标记tag，方便区分
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"actionbar_picture_icon"] title:@"发送锦旗" tag:201];
    // 注册自定义送礼物消息
    [self registerClass:[HHRichContentMessageCell class] forMessageClass:[HHRichContentMessage class]];
    // 注册家访cell
    [self registerClass:[SigningStatesCell class] forMessageClass:[HHVisitMessage class]];
    
    [self createLeftNavBtn];
    [self addRealTimeLocation];
    [self setupGiftUI];
}

- (void)sendPaySuccessMessage:(NSNotification *)notice{
    
    NSString * pushContent = [NSString stringWithFormat:@"用户 %@ 成功支付订单", [DEFAULTS objectForKey:CLIENTNAME]];
    RCInformationNotificationMessage * notificationMessage = [RCInformationNotificationMessage notificationWithMessage:@"已成功支付订单" extra:@"OrderPaySuccessful"];
    [self sendMessage:notificationMessage pushContent:pushContent];
}

- (void)setupGiftView{
    self.giftView = [[[NSBundle mainBundle] loadNibNamed:@"GiftView" owner:self options:nil] lastObject];
    self.giftView.y = SZRScreenHeight;
    // 代理
    self.giftView.delegate = self;
    [self.view addSubview:self.dismissGiftView];
    [self.view addSubview:self.giftView];
    self.giftView.y -= self.giftView.height;
}
- (void)setupGiftUI{
    self.dataArray = [NSMutableArray array];
    // 这快有问题
    self.giftService = [[GiftBarrage alloc] initBarrageToView:self.view];
    
}

#pragma mark GiftViewDelegate
- (void)giftView:(GiftView *)giftView rechargeBtnDidClicked:(UIButton *)rechargeBtn{
    SZRLog(@"冲冲冲冲");
}
- (void)giftView:(GiftView *)giftView sendBtnDidClickedWithFCount:(NSString *)fCount{
    self.chatSessionInputBarControl.hidden = NO;
    
    // 点击发送按钮移除View
    [self hiddenGiftView];
    [self.giftService addBarrageItem:[GiftBarrageView giftIcon:@"tinyCar" giftName:@"送一幅锦旗"]];
    HHRichContentMessage * message = [HHRichContentMessage messageWithTitle:@"锦旗" digest:@"合合" imageURL:@"Huge01.jpeg" extra:@""];
    [self sendMessage:message pushContent:message.title];
    
}


#pragma mark - Getter/Setter
- (UIView *)dismissGiftView {
    if (!_dismissGiftView) {
        _dismissGiftView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_dismissGiftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissGiftTapGesture:)]];
        [_dismissGiftView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissGiftPanGesture:)]];
    }
    return _dismissGiftView;
}
#pragma mark - UIGestureRecognizer
- (void)handleDismissGiftTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self hiddenGiftView];
}

- (void)handleDismissGiftPanGesture:(UIPanGestureRecognizer *)panGesture {
    [self hiddenGiftView];
}
- (void)hiddenGiftView {
    if (_giftView.y != SZRScreenHeight) {
        self.chatSessionInputBarControl.hidden=NO;
        [UIView animateWithDuration:0.4 animations:^{
            _giftView.y = SZRScreenHeight;
        } completion:^(BOOL finished) {
            [_giftView removeFromSuperview];
            [_dismissGiftView removeFromSuperview];
        }];
    }
}


-(void)addRealTimeLocation{
    /*******************实时地理位置共享***************/
    [self registerClass:[RealTimeLocationStartCell class]
        forMessageClass:[RCRealTimeLocationStartMessage class]];
    [self registerClass:[RealTimeLocationEndCell class]
        forMessageClass:[RCRealTimeLocationEndMessage class]];
    
    __weak typeof(&*self) weakSelf = self;
    [[RCRealTimeLocationManager sharedManager]
     getRealTimeLocationProxy:self.conversationType
     targetId:self.targetId
     success:^(id<RCRealTimeLocationProxy> realTimeLocation) {
         weakSelf.realTimeLocation = realTimeLocation;
         [weakSelf.realTimeLocation addRealTimeLocationObserver:self];
         [weakSelf updateRealTimeLocationStatus];
     }
     error:^(RCRealTimeLocationErrorCode status) {
         NSLog(@"get location share failure with code %d", (int)status);
     }];
    
    /******************实时地理位置共享**************/
    
}
-(void)createLeftNavBtn{
    //设置导航条样式
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName :[UIFont systemFontOfSize:19.f],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //左按钮
    UIButton * leftBtn = [SZRFunction createButtonWithFrame:CGRectMake(0, 0, 22, 22) withTitle:nil withImageStr:kBackBtnName withBackImageStr:nil];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStyleDone target:self action:@selector(addBtnClick:)];
    //把字体设置成白色
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.title = self.doctorModel.name;
}

// 创建头视图
- (void)createHeaderView{
    //职位
    self.positionLabel = [UILabel new];
    self.positionLabel.text = self.doctorModel.name;
    self.positionLabel.textColor = [UIColor whiteColor];
    self.positionLabel.font =[UIFont systemFontOfSize:14];
    [ self.topView addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.topView.mas_top).offset(8);
        make.size.mas_equalTo(CGSizeMake(300, 30));
    }];
    
    //主治
    self.functionLabel = [UILabel new];
    self.functionLabel.numberOfLines = 0;
    self.functionLabel.font = [UIFont systemFontOfSize:14];
    self.functionLabel.textColor = [UIColor whiteColor];
    if (self.doctorModel.goodField) {
        self.functionLabel.attributedText =[SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"擅长领域:%@",self.doctorModel.goodField] withSubStr:@"擅长领域:" withColor:nil withFont:nil];
    }
    //labelsize的最大值
    CGSize maximumLabelSize = CGSizeMake(SZRScreenWidth- 20*2, 9999);
    CGSize expectSize = [self.functionLabel sizeThatFits:maximumLabelSize];
    self.functionLabel.textAlignment = NSTextAlignmentLeft;
    [ self.topView addSubview:self.functionLabel];
    [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.positionLabel.mas_left);
        make.top.equalTo(self.positionLabel.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(expectSize.width, expectSize.height));
    }];
    //锦旗数
    self.pennantsSeveralLa = [UILabel new];
    self.pennantsSeveralLa.text = @"锦旗数：39";
    self.pennantsSeveralLa.textColor = [UIColor whiteColor];
    self.pennantsSeveralLa.font =[UIFont systemFontOfSize:14];
    [ self.topView addSubview:self.pennantsSeveralLa];
    [self.pennantsSeveralLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.functionLabel.mas_left);
        make.top.equalTo(self.functionLabel.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    //好评
    self.highPraiseLa = [UILabel new];
    self.highPraiseLa.text = @"好评：125";
    self.highPraiseLa.textColor = [UIColor whiteColor];
    self.highPraiseLa.font =[UIFont systemFontOfSize:14];
    [ self.topView addSubview:self.highPraiseLa];
    [self.highPraiseLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pennantsSeveralLa.mas_centerX).offset(120);
        make.top.equalTo(self.pennantsSeveralLa.mas_top);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    [self createFunctionView];
}

#pragma mark 创建4个功能btn
- (CGFloat)createFunctionView{
    CGFloat btnHeight;
    if (!self.fuctionV) {
        self.fuctionV = [functionView new];
        btnHeight = [self.fuctionV addSubBtn];
        __weakSelf;
        self.fuctionV.btnClickBlock = ^(NSInteger tag){
            if (tag == 103) {
                [weakSelf.view.window addSubview:weakSelf.signDoctorView];
            }
            else if (tag == 102){
                SZRLog(@"咨询医生");
                [weakSelf.view.window addSubview:weakSelf.backGroundView];
            }
            else if (tag == 101){
                SendServiceOrderVC * sendServiceOrderVC = [[SendServiceOrderVC alloc]init];
                sendServiceOrderVC.doctorModel = weakSelf.doctorModel;
                sendServiceOrderVC.comitVisistBlock = ^(NSString * homeServiceId){
                    [weakSelf commitVisitsMessageWithServiceId:homeServiceId];
                };
                [weakSelf.navigationController pushViewController:sendServiceOrderVC animated:YES];
            }
            else{
                [weakSelf.view.window addSubview:weakSelf.onlineVisitsView];
            }
        };
        
        [self.topView addSubview:self.fuctionV];
        [self.fuctionV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.highPraiseLa.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(btnHeight);
            // 这句是关键，highPraiseLa的尺寸大小已经确定，让它去和topView底部做约束进而确定topView的高度
            make.bottom.equalTo(self.topView.mas_bottom).offset(-25);
        }];
    }
    return btnHeight;
}

- (void)addBtnClick:(UIBarButtonItem* )sender{
    self.isMinus = !self.isMinus;
    UIImage *image = self.isMinus ? [UIImage imageNamed:@"minus"] : [UIImage imageNamed:@"add"];
    [sender setImage:image];
    self.topView ? @"" : [self createHeaderView];
    self.topView.hidden = !self.isMinus;
}

/**
 懒加载topView
 */
-(UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = RGBCOLOR(30, 88, 102);
        [self.view addSubview:_topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
            make.left.equalTo(self.view);
            make.width.mas_equalTo(SZRScreenWidth);
        }];
        [self createHeaderView];
    }
    return _topView;
}

#pragma mark 签约医生弹窗
- (SignDoctorView *)signDoctorView{
    if (!_signDoctorView) {
        _signDoctorView =[[SignDoctorView alloc] initWithFrame:SZRScreenBounds];
        _signDoctorView.doctorModel = self.doctorModel;
        SZRLog(@"[VDUserTools HH_SelectPrivateDoctorState:[self.doctorModel.doctorId intValue]] = %zd",[VDUserTools HH_SelectPrivateDoctorState:[self.doctorModel.doctorId intValue]]);
        self.signState = [VDUserTools HH_SelectPrivateDoctorState:[self.doctorModel.doctorId intValue]];
        _signDoctorView.signState = self.signState;
        __weakSelf;
        _signDoctorView.commitSignBtn = ^(){
            [weakSelf commitSignRequest];
        };
    }
    return _signDoctorView;
}
#pragma mark - 电话咨询
- (BackGroundView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[BackGroundView alloc] initWithFrame:SZRScreenBounds];
    }
    return _backGroundView;
}
#pragma mark - 在线问诊
- (OnlineVisitsView *)onlineVisitsView{
    if (!_onlineVisitsView) {
        _onlineVisitsView = [[OnlineVisitsView alloc] initWithFrame:SZRScreenBounds];
    }
    return _onlineVisitsView;
}

#pragma mark - 提交签约请求
-(void)commitSignRequest{
    if (self.signState == -1) {
        [VDNetRequest HH_CommitSign:self.doctorModel.doctorId success:^(NSDictionary *dic) {
            //改为提交签约状态
            PrivateDoctorModel * waitSignDoctor = [[PrivateDoctorModel alloc]init];
            waitSignDoctor.doctorId = [self.doctorModel.doctorId intValue];
            waitSignDoctor.doctorTypeId = [self.doctorModel.doctorType intValue];
            waitSignDoctor.state = [NSString stringWithFormat:@"0"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [VDUserTools HH_InsertPrivateDoctor:@[waitSignDoctor]];
            });
            self.signDoctorView.signState = 0;
            self.signState = 0;
            [self insertCommitSignMessage];
        } viewController:self showHud:YES];
    }
}

//发送提交签约消息
-(void)insertCommitSignMessage{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RCInformationNotificationMessage * commitSignMsg =
        [RCInformationNotificationMessage
         notificationWithMessage:@"请求签约" extra:nil];
        RCMessage * savedMsg = [[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND messageId:-1 content:commitSignMsg];
        [self sendMessage:savedMsg.content pushContent:@"请求签约"];
    });
    
}

#pragma mark - 发送提交上门家访信息
- (void)commitVisitsMessageWithServiceId:(NSString *)serviceId{
    
    //插入本地消息
    NSString * notificationStr = [NSString stringWithFormat:@"已成功向 %@ 发出请求", self.doctorModel.name];
    RCInformationNotificationMessage * notificationMessage = [RCInformationNotificationMessage notificationWithMessage:notificationStr extra:nil];
    RCMessage * rcMessage = [[RCIMClient sharedRCIMClient]
                             insertOutgoingMessage:ConversationType_PRIVATE targetId:self.targetId
                             sentStatus:SentStatus_SENT content:notificationMessage];
    [self appendAndDisplayMessage:rcMessage];
    /******************************/
    NSDictionary * dic = @{@"homeServiceId":serviceId};
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //向医师端发送消息
    NSString * pushContent = @"您收到了一个家访订单";
    HHVisitMessage * visitMessage = [HHVisitMessage messageWithContent:pushContent contentShow:pushContent flag:1 parameterJson:str];
    [self sendMessage:visitMessage pushContent:pushContent];
}

- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message{
    //由于找不到数据源到底是在何时插入到数据源，所以对数据源操作无效，在此调用这个方法只是不让视图显示，但并没有操作数据源
    if (message.messageDirection == 1 && [message.objectName isEqualToString:@"HH:custom"]) {
        return nil;
    }
    return message;
}

//发送消息的回调
- (void)didSendMessage:(NSInteger)stauts content:(RCMessageContent *)messageCotent{
}
//将要展示cell时对UI进行处理
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath{
    
    if (cell.model.messageDirection == 1 && [cell.model.content isKindOfClass:[HHVisitMessage class]]) {
        
        SigningStatesCell * signCell = (SigningStatesCell *)cell;
        signCell.hideBtn = YES;
    }
    
    if (cell.model.messageDirection == 2 && [cell.model.content isKindOfClass:[HHVisitMessage class]]) {
        
        
        SigningStatesCell * signCell = (SigningStatesCell *)cell;
        signCell.hideBtn = NO;
        
        signCell.agreeSignBtnBlock = ^(){
            
            HHVisitMessage * visitMessage = (HHVisitMessage *)cell.model.content;
            NSDictionary * dict = [SZRFunction dictionaryWithJsonString:visitMessage.parameterJson];
            NSString * price = dict[@"price"];
            NSString * homeServiceId = dict[@"homeServiceId"];
            OrderDetailsVC* detailsVC = [[OrderDetailsVC alloc] init];
            detailsVC.price = price;
            detailsVC.homeServiceId = homeServiceId;
            [self.navigationController pushViewController:detailsVC animated:YES];
        };
    }
}

#pragma mark - 服务订单
-(ServiceOrderView *)serviceOrderView{
    if (!_serviceOrderView) {
        _serviceOrderView = [[ServiceOrderView alloc]initWithFrame:SZRScreenBounds];
        [_serviceOrderView loadData];
        
    }
    return _serviceOrderView;
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView
     clickedItemWithTag:(NSInteger)tag {
    switch (tag) {
        case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
            if (self.realTimeLocation) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:nil
                                              delegate:self
                                              cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"发送位置", @"位置实时共享", nil];
                [actionSheet showInView:self.view];
            } else {
                [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            }
            
        } break;
        case 201:
        {
            // 记得调用super父类的方法
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            // 隐藏输入框
            self.chatSessionInputBarControl.hidden=YES;
            //            [self setupGiftView];
            [MBProgressHUD showTextOnly:@"该功能未开放"];
        }
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [super pluginBoardView:self.chatSessionInputBarControl.pluginBoardView
                clickedItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
        } break;
        case 1: {
            [self showRealTimeLocationViewController];
        } break;
    }
}

#pragma mark 地理位置的回调
- (void)locationDidSelect:(CLLocationCoordinate2D)location locationName:(NSString *)locationName mapScreenShot:(UIImage *)mapScreenShot{
    /**
     *  创建消息
     *
     * @param image 缩略图
     * @param location 二维地理位置信息
     * @param locationName 位置名称
     */
    RCLocationMessage *locationMessage =
    [RCLocationMessage messageWithLocationImage:mapScreenShot
                                       location:location
                                   locationName:locationName];
    [self sendMessage:locationMessage pushContent:nil];
    NSLog(@"location.latitude = %lf location.longitude = %lf locationName = %@",location.latitude,location.longitude,locationName);
}

/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController {
    RealTimeLocationViewController *lsvc =
    [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] ==
        RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    } else if ([self.realTimeLocation getStatus] ==
               RC_REAL_TIME_LOCATION_STATUS_IDLE) {
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc
                                            animated:YES
                                          completion:^{
                                              
                                          }];
}

- (void)updateRealTimeLocationStatus {
    if (self.realTimeLocation) {
        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
        __weak typeof(&*self) weakSelf = self;
        NSArray *participants = nil;
        switch ([self.realTimeLocation getStatus]) {
            case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
                [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
                break;
            case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
            case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
                participants = [self.realTimeLocation getParticipants];
                if (participants.count == 1) {
                    NSString *userId = participants[0];
                    [weakSelf.realTimeLocationStatusView
                     updateText:[NSString
                                 stringWithFormat:@"user<%@>正在共享位置", userId]];
                    [[RCIM sharedRCIM]
                     .userInfoDataSource
                     getUserInfoWithUserId:userId
                     completion:^(RCUserInfo *userInfo) {
                         if (userInfo.name.length) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [weakSelf.realTimeLocationStatusView
                                  updateText:[NSString stringWithFormat:
                                              @"%@正在共享位置",
                                              userInfo.name]];
                             });
                         }
                     }];
                } else {
                    if (participants.count < 1)
                        [self.realTimeLocationStatusView removeFromSuperview];
                    else
                        [self.realTimeLocationStatusView
                         updateText:[NSString stringWithFormat:@"%d人正在共享地理位置",
                                     (int)participants.count]];
                }
                break;
            default:
                break;
        }
    }
}

- (RealTimeLocationStatusView *)realTimeLocationStatusView {
    if (!_realTimeLocationStatusView) {
        _realTimeLocationStatusView = [[RealTimeLocationStatusView alloc]
                                       initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
        _realTimeLocationStatusView.delegate = self;
        [self.view addSubview:_realTimeLocationStatusView];
    }
    return _realTimeLocationStatusView;
}
#pragma mark - RealTimeLocationStatusViewDelegate
- (void)onJoin {
    [self showRealTimeLocationViewController];
}
- (RCRealTimeLocationStatus)getStatus {
    return [self.realTimeLocation getStatus];
}

- (void)onShowRealTimeLocationView {
    [self showRealTimeLocationViewController];
}

#pragma mark - RCRealTimeLocationObserver
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onParticipantsJoin:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient]
         .currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你加入了地理位置共享"];
    } else {
        [[RCIM sharedRCIM]
         .userInfoDataSource
         getUserInfoWithUserId:userId
         completion:^(RCUserInfo *userInfo) {
             if (userInfo.name.length) {
                 [weakSelf
                  notifyParticipantChange:
                  [NSString stringWithFormat:@"%@加入地理位置共享",
                   userInfo.name]];
             } else {
                 [weakSelf
                  notifyParticipantChange:
                  [NSString
                   stringWithFormat:@"user<%@>加入地理位置共享",
                   userId]];
             }
         }];
    }
}

- (void)onParticipantsQuit:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient]
         .currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你退出地理位置共享"];
    } else {
        [[RCIM sharedRCIM]
         .userInfoDataSource
         getUserInfoWithUserId:userId
         completion:^(RCUserInfo *userInfo) {
             if (userInfo.name.length) {
                 [weakSelf
                  notifyParticipantChange:
                  [NSString stringWithFormat:@"%@退出地理位置共享",
                   userInfo.name]];
             } else {
                 [weakSelf
                  notifyParticipantChange:
                  [NSString
                   stringWithFormat:@"user<%@>退出地理位置共享",
                   userId]];
             }
         }];
    }
}

- (void)onRealTimeLocationStartFailed:(long)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.conversationDataRepository.count; i++) {
            RCMessageModel *model = [self.conversationDataRepository objectAtIndex:i];
            if (model.messageId == messageId) {
                model.sentStatus = SentStatus_FAILED;
            }
        }
        NSArray *visibleItem =
        [self.conversationMessageCollectionView indexPathsForVisibleItems];
        for (int i = 0; i < visibleItem.count; i++) {
            NSIndexPath *indexPath = visibleItem[i];
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:indexPath.row];
            if (model.messageId == messageId) {
                [self.conversationMessageCollectionView
                 reloadItemsAtIndexPaths:@[ indexPath ]];
            }
        }
    });
}

- (void)notifyParticipantChange:(NSString *)text {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.realTimeLocationStatusView updateText:text];
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus)
                       withObject:nil
                       afterDelay:0.5];
    });
}

- (void)onFailUpdateLocation:(NSString *)description {
}

/**
 点击Cell头像的回调
 */
- (void)didTapCellPortrait:(NSString *)userId{
    if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        DoctorIntroductionVC* intrVC = [DoctorIntroductionVC new];
        intrVC.doctorModel = self.doctorModel;
        [self.navigationController pushViewController:intrVC animated:YES];
    }
}

/*!
 输入框中内容发生变化的回调
 */
- (void)inputTextView:(UITextView *)inputTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.isMinus) {
        self.isMinus = !self.isMinus;
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"add"]];
        self.topView.hidden = !self.isMinus;
    }
}
/**
 点击聊天界面收起视图
 */
- (void)tap4ResetDefaultBottomBarStatus:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // 收起建盘
        [self.chatSessionInputBarControl resetToDefaultStatus];
        if (self.isMinus) {
            self.isMinus = !self.isMinus;
            [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"add"]];
            self.topView.hidden = !self.isMinus;
        }
    }
}

//左侧返回按钮
- (void)leftBarButtonItemPressed:(id)sender {
    if ([self.realTimeLocation getStatus] ==
        RC_REAL_TIME_LOCATION_STATUS_OUTGOING ||
        [self.realTimeLocation getStatus] ==
        RC_REAL_TIME_LOCATION_STATUS_CONNECTED) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:
                                  @"离开聊天，位置共享也会结束，确认离开"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        [self popupChatViewController];
    }
}

- (void)popupChatViewController {
    [super leftBarButtonItemPressed:nil];
    [self.realTimeLocation removeRealTimeLocationObserver:self];
    if (_needPopToRootView == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        [self.realTimeLocation quitRealTimeLocation];
        [self popupChatViewController];
    }
}

@end

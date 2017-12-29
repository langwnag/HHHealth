//
//  DoctorIntroductionVC.m
//  YiJiaYi
//
//  Created by mac on 2016/11/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DoctorIntroductionVC.h"
#import "DocterIntroView.h"
#import "ChatTextVC.h"
#import <UShareUI/UShareUI.h>
#import <RongIMKit/RCConversationModel.h>
#import "DoctListModel.h"

#define NAVBAR_CHANGE_POINT 50

@interface DoctorIntroductionVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView* scrollV;
@property (nonatomic,strong) DocterIntroView* docterIntroView;
@property (nonatomic,strong) UIButton* bottomBtn;
@property (nonatomic,weak) UILabel* introduceLabel;
@property (nonatomic,weak) UILabel* introLa;
@property (nonatomic,weak) UILabel* goodfieldLa;


@end

@implementation DoctorIntroductionVC
/** 设置导航透明*/
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    self.scrollV.contentSize = CGSizeMake(SZRScreenWidth, CGRectGetMaxY(self.introduceLabel.frame)+80);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{

    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVRIGHTIMAGE:@"share"}];
    [self.view addSubview:self.scrollV];
    [self.scrollV addSubview:self.docterIntroView];

    self.introduceLabel = [self setupLableWithAttriStr:[self loadModelData]];
    [self setupBottomView];
}

-(NSMutableAttributedString *)loadModelData{
    DoctListModel * model = self.doctorModel;
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n职称：%@\n性别：%@\n工作年限：%@\n工作单位：%@",model.jobTitle,model.sex,model.serviceYear,model.workUnit]];
    if (model.goodField) {
        [self addSubAttri:[NSString stringWithFormat:@"\n\n\n  擅长领域：\n\n\n%@",model.goodField] subStr:@"  擅长领域：\n" attriStr:attriStr];
    }
    
    [self addSubAttri:[NSString stringWithFormat:@"\n\n\n  个人简介：\n\n\n%@",model.individualResume] subStr:@"  个人简介：\n" attriStr:attriStr];
    
    [self addSubAttri:[NSString stringWithFormat:@"\n\n\n  教育背景：\n\n\n%@",model.educationalBackground] subStr:@"  教育背景：\n" attriStr:attriStr];
    
    [self addSubAttri:[NSString stringWithFormat:@"\n\n\n  工作经历：\n\n\n%@",model.workExperience] subStr:@"  工作经历：\n" attriStr:attriStr];
    
    if (model.spiritualMessage) {
        [self addSubAttri:[NSString stringWithFormat:@"\n\n\n  心灵寄语：\n\n\n%@",model.spiritualMessage] subStr:@"  心灵寄语：\n" attriStr:attriStr];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [paragraphStyle setLineSpacing:kAdaptedHeight(4)];
    [attriStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attriStr.length)];
    
    
    return attriStr;
}

-(void)addSubAttri:(NSString *)str subStr:(NSString *)subStr attriStr:(NSMutableAttributedString *)attriStr{
    
    NSRange range = [str rangeOfString:subStr];
    NSMutableAttributedString * subAttri = [[NSMutableAttributedString alloc]initWithString:str];
    [subAttri addAttribute:NSBackgroundColorAttributeName value:HEXCOLOR(0x145564) range:range];
    
    [subAttri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kAdaptedWidth(17)] range:range];
   
    //    @"\n\n擅长领域：\n\n%@"
    [subAttri addAttributes:@{NSBackgroundColorAttributeName:HEXCOLOR(0x145564),NSFontAttributeName:[UIFont systemFontOfSize:kAdaptedWidth(5)]} range:NSMakeRange(2, 1)];
    [subAttri addAttributes:@{NSBackgroundColorAttributeName:HEXCOLOR(0x145564),NSFontAttributeName:[UIFont systemFontOfSize:kAdaptedWidth(2.5)]} range:NSMakeRange(11, 1)];

    [attriStr appendAttributedString:subAttri];

}

- (UIScrollView *)scrollV{
    if (!_scrollV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _scrollV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollV.backgroundColor = RGBCOLOR(22, 48, 78);
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.delegate = self;
        _scrollV.bounces = NO;
        _scrollV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollV;
}

- (DocterIntroView *)docterIntroView{
    if (!_docterIntroView) {
        _docterIntroView = [[[NSBundle mainBundle]loadNibNamed:@"DocterIntroView" owner:self options:nil] lastObject];
        _docterIntroView.frame = CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight(214));
        [VDNetRequest VD_OSSImageView:_docterIntroView.headImageV fullURLStr:self.doctorModel.headPortrait placeHolderrImage:kDefaultDoctorImage];
        _docterIntroView.nameLabel.text = self.doctorModel.name;
    }
    return _docterIntroView;
}

/** 底部视图*/
- (void)setupBottomView{

    UIButton* bottomBtn = [SZRFunction createButtonWithFrame:CGRectMake(0, SZRScreenHeight -50, SZRScreenWidth, 50) withTitle:@"选择该医生" withImageStr:nil withBackImageStr:nil];
    [bottomBtn addTarget:self action:@selector(clickMessage:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.backgroundColor = RGBCOLOR(34, 202, 170);
    [self.view addSubview:bottomBtn];
    self.bottomBtn = bottomBtn;
}

- (void)clickMessage:(UIButton* )btn{
    [VDUserTools HH_InsertContactDoctor:@[self.doctorModel] finish:^{
    }];
    ChatTextVC * chatVC = [[ChatTextVC alloc]initWithConversationType:ConversationType_PRIVATE targetId:self.doctorModel.doctorRCId];
    chatVC.doctorModel = self.doctorModel;
    chatVC.displayUserNameInCell = NO;
    [self.navigationController pushViewController:chatVC animated:NO];


}
/**
 初始化label
 @param dataText 给Label赋值
 @return la
 */
- (UILabel* )setupLableWithAttriStr:(NSAttributedString *)attriStr{
    
    UILabel* La = [[UILabel alloc] init];
    [self.scrollV addSubview:La];
    La.textColor = HEXCOLOR(0xfffada);
    La.font = [UIFont systemFontOfSize:kAdaptedWidth(14)];
    La.sd_layout
    .leftSpaceToView(_scrollV,10)
    .topSpaceToView(_scrollV,kAdaptedHeight(214))
    .rightSpaceToView(_scrollV,10)
    .autoHeightRatio(0);
    La.isAttributedContent = YES;
    La.attributedText = attriStr;
    return La;
}

- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)rightBtnClick{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
}

//分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  @"http://img4.duitang.com/uploads/item/201603/03/20160303190556_yhB48.thumb.700_0.jpeg";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"我最爱的胡歌，🌹🌹" descr:@"胡歌，1982年9月20日出生于上海市徐汇区，中国内地演员、歌手、制片人。" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://www.hehehome.cn";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
    
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        [self.navigationController.navigationBar lt_setBackgroundImage:@""];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    }
    
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

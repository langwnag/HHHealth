//
//  HealthRecordsVC.m
//  YiJiaYi
//
//  Created by mac on 2016/11/18.
//  Copyright © 2016年 mac. All rights reserved.
//
#define Button_HEIGHT 30
#define Button_WIDTH 120
#define btnTitleArr @[@"个人资料",@"体检报告"]

#import "HealthRecordsVC.h"
#import "StoreVerifyNullView.h"
// 个人资料 体检报告
#import "PersonalDataView.h"
#import "MedicalReportView.h"
#import "SZRImageBrower.h"
@interface HealthRecordsVC ()<UIScrollViewDelegate,MedicalReportCellClickDelegate>
@property (nonatomic,strong) StoreVerifyNullView* storeVerifyNullView;
@property (nonatomic,strong) SZRTableView* tableV;
// 底部滚动式图
@property (nonatomic,strong) UIScrollView* scrollV;
@property (nonatomic,strong) PersonalDataView* personalDataView;
@property (nonatomic,strong) MedicalReportView* medicalReportView;
@property(nonatomic,strong)UIView * midView;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UILabel* slideLa;
@property(nonatomic,assign)int selecteIndex;
@property(nonatomic,assign)BOOL isPersonalData;//当前view为个人资料


@end

@implementation HealthRecordsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHealthUI];
    [self initData];
    
}

- (void)createHealthUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"我的健康档案",NAVRIGTHTITLE:@"保存"}];
    //创建scrollView
    [self createScrollView];
    [self createSlideBtn];
    
}
-(void)initData{
    self.isPersonalData = YES;
}
- (void)createScrollView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0,30, SZRScreenWidth, SZRScreenHeight)];
    // 个人资料
    self.personalDataView = [[PersonalDataView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight)];
    self.personalDataView.viewController = self;
    [self.scrollV addSubview:self.personalDataView];
    // 健康体检
    self.medicalReportView = [[MedicalReportView alloc] initWithFrame:CGRectMake(SZRScreenWidth, 0, SZRScreenWidth, SZRScreenHeight)];
    self.medicalReportView.Tagdelegate = self;
    [self.scrollV addSubview:self.medicalReportView];
    //底部视图的其他设置
    self.scrollV.contentSize = CGSizeMake(2 * SZRScreenWidth, 0);
    
    self.scrollV.pagingEnabled = YES;
    //不显示滚动条
    self.scrollV.showsHorizontalScrollIndicator = NO;
    self.scrollV.showsVerticalScrollIndicator = NO;
    //关闭回弹效果
    self.scrollV.bounces = NO;
    self.scrollV.delegate = self;
    
    [self.view addSubview:self.scrollV];
}

- (void)createSlideBtn{
    self.midView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 30)];
    self.midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.midView];
    float gap = (SZRScreenWidth - Button_WIDTH*2)/3;

    for (int i = 0; i < btnTitleArr.count; i++) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        // gap 是最左侧的宽度，如果i=0；第一个就别成 gap + i*(Button_WIDTH + gap)
        btn.frame = CGRectMake(gap + i*(Button_WIDTH + gap), 0, Button_WIDTH, Button_HEIGHT);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        //设置btn的tag值 个人资料tag：101  体检报告tag:102
        btn.tag = 101+i;
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:SZR_NewNavColor forState:UIControlStateSelected];
        [self.midView addSubview:btn];
        if (i==0) {
            btn.selected = YES;
            UILabel* la = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SZRScreenWidth, 1)];
            la.backgroundColor = [UIColor grayColor];
            [self.midView addSubview:la];
            self.slideLa = [[UILabel alloc]initWithFrame:CGRectMake(0, 28.5, 130, 3)];
            self.slideLa.backgroundColor = SZR_NewNavColor;
            self.slideLa.center = CGPointMake(btn.center.x, self.slideLa.center.y);
            [self.midView addSubview:self.slideLa];
        }
    }
}

-  (void)ClickBtn:(UIButton* )btn{
    if (btn.tag == 102) {
        self.isPersonalData = NO;
//        if ([self.medicalReportView respondsToSelector:@selector(createReportUI)]) {
//            [self.medicalReportView performSelector:@selector(createReportUI)];
//        }
        [self modifyBtnStatic:[self.midView viewWithTag:102]];

    }else{
        self.isPersonalData = YES;
        [self modifyBtnStatic:[self.midView viewWithTag:101]];

    }
    //设置scrollView的偏移量
    self.scrollV.contentOffset = self.isPersonalData ? CGPointMake(0, 0) : CGPointMake(SZRScreenWidth, 0);
}
#pragma mark 实现scrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [self modifyBtnStatic:[self.midView viewWithTag:101]];

    }else if(scrollView.contentOffset.x == SZRScreenWidth){
        [self modifyBtnStatic:[self.midView viewWithTag:102]];
    }
}
-(void)modifyBtnStatic:(UIButton *)btn{
    //选中btn
    btn.selected = YES;
    btn.titleLabel.tintColor = SZR_NewNavColor;
    self.slideLa.center = CGPointMake(btn.center.x, self.slideLa.center.y);
    //未选中的btn
    UIButton * normalBtn = [self.midView viewWithTag:btn.tag == 101?102:101];
    normalBtn.selected = NO;
    btn.titleLabel.tintColor = [UIColor grayColor];
    
}
// 实现协议方法
- (void)MedicalReportCellClick:(UIImageView *)imageV{
    __weakSelf;
    [weakSelf.navigationController setNavigationBarHidden:YES animated:YES];
    SZRImageBrower * brow = [SZRImageBrower sharedInstance];
        brow.showNavBarBlock = ^(){
            [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
            
        };
        [SZRImageBrower createUI:imageV view:self.view];
}


// 视图为空 添加
- (void)addRecordsNullView{
    if (!self.storeVerifyNullView) {
        self.storeVerifyNullView = [[[NSBundle mainBundle] loadNibNamed:@"StoreVerifyNullView" owner:nil options:nil] lastObject];
//        [self.storeVerifyNullView loadImageView:kDefaultDoctorImage labelStr:@"您的私人医生还没有上传档案，请耐心等待"];
        self.storeVerifyNullView.frame = self.tableV.frame;
    }
    [self.view addSubview:self.storeVerifyNullView];
    [self.view bringSubviewToFront:self.storeVerifyNullView];
}
//移除我的订单为空视图
- (void)removeRecordsNullView{
    if (self.storeVerifyNullView !=nil) {
        [self.storeVerifyNullView removeFromSuperview];
    }
}

- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick{
    if (self.scrollV.contentOffset.x == 0) {
        //保存个人资料
        [self.personalDataView updateUserInfo];
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

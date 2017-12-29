//
//  HealthRecordsVC.m
//  YiJiaYi
//
//  Created by mac on 2016/11/18.
//  Copyright © 2016年 mac. All rights reserved.
//
#define Button_HEIGHT 44
#define Button_WIDTH 120
#define btnTitleArr @[@"个人资料",@"体检报告"]

#import "HealthRecordsVC.h"
#import "StoreVerifyNullView.h"
// 个人资料 体检报告
#import "PersonalDataView.h"
#import "MedicalReportView.h"
#import "SZRImageBrower.h"

// 关于PDF
#import "ZPFDownLoaderManager.h"
#import "ZPFProcess.h"

#import "ReaderViewController.h"
#import "ReaderDocument.h"


#define BACE_COLOR ([UIColor colorWithRed:234/255.0 green:236/255.0 blue:236/255.0 alpha:1.000])

@interface HealthRecordsVC ()<UIScrollViewDelegate,MedicalReportCellClickDelegate,ReaderViewControllerDelegate>
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
    
    self.scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0,44, SZRScreenWidth, SZRScreenHeight)];
    // 个人资料
    self.personalDataView = [[PersonalDataView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight)];
    self.personalDataView.viewController = self;
    [self.scrollV addSubview:self.personalDataView];
    // 健康体检
    self.medicalReportView = [[MedicalReportView alloc] initWithFrame:CGRectMake(SZRScreenWidth, 0, SZRScreenWidth, SZRScreenHeight)];
    self.medicalReportView.viewController = self;
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
    self.midView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 44)];
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
            UILabel* la = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, SZRScreenWidth, 1)];
            la.backgroundColor = [UIColor grayColor];
            [self.midView addSubview:la];
            self.slideLa = [[UILabel alloc]initWithFrame:CGRectMake(0, 42.5, 130, 3)];
            self.slideLa.backgroundColor = SZR_NewNavColor;
            self.slideLa.center = CGPointMake(btn.center.x, self.slideLa.center.y);
            [self.midView addSubview:self.slideLa];
        }
    }
}

-  (void)ClickBtn:(UIButton* )btn{
    if (btn.tag == 102) {
        self.isPersonalData = NO;
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

// 代理方法
- (void)MedicalReportCellClick:(MedicalReportModel *)medicalModel{
    
    [self dowmloadFileWithPath:medicalModel.reportUrl];

}


-(void) dowmloadFileWithPath:(NSString *) path{
    NSString *urlString = [NSString stringWithFormat:@"%@",path];
    
    ZPFProcess* processView=[[ZPFProcess alloc] initWithFrame:CGRectMake(SZRScreenWidth/2-40, SZRScreenHeight/2-40, 80, 80)];
    processView.backgroundColor= BACE_COLOR;
    processView.layer.cornerRadius=20;
    processView.layer.masksToBounds=YES;
    [self.view addSubview:processView];
    
    [[ZPFDownLoaderManager sharedManager] downLoader:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] successBlock:^(NSString *path) {
        NSLog(@"文件已经下载完毕,本地路径为:..%@",path);
        
        [processView removeFromSuperview];
        [self openDocxWithPath:path];
        
    } processBlock:^(float process) {
        //更新控件
        dispatch_async(dispatch_get_main_queue(), ^{
            processView.process = process;
        });
        
    } errorBlock:^(NSError *error) {
        NSLog(@"下载失败...%@",error);
    }];
    
}
-(void)openDocxWithPath:(NSString *)filePath {
    ReaderDocument* document = [[ReaderDocument alloc] initWithFilePath:filePath password:nil];
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        [self.navigationController pushViewController:readerViewController animated:YES];
#else // present in a modal view controller
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    else // Log an error so that we know that something went wrong
    {
        SZRLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath);
    }
}

-(void)dismissReaderViewController:(ReaderViewController *)viewController {
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
    
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

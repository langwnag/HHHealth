//
//  SelecterDoctorVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//
#define PCH_Button_HEIGHT 25
#define PCH_Button_WIDTH 100
#import "SelecterDoctorVC.h"
#import "SZRTableView.h"
#import "SelecterDoctorCell.h"
#import "healthyCircleVC.h"
#import "SZRTabBarVC.h"
#import "DoctorIntroductionVC.h"
#import "DoctListModel.h"
#import "ChatTextVC.h"

/**
 *  上面label的tag值为 200 201 202
    btn的tag值为300 301 302
 */

#define DICARR @{@"300":@[@"距离1",@"距离2",@"距离3",@"距离4"],@"301":@[@"口碑1",@"口碑2",@"口碑3",@"口碑4"],@"302":@[@"费用1",@"费用2",@"费用3",@"费用4"]}

@interface SelecterDoctorVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) UIView* secondLine;

@property(nonatomic,strong)SZRTableView * selectTableView;//顶部选择tableView
@property(nonatomic,strong)NSMutableArray * selectDataArr;//选择tableView的数据源
@property(nonatomic,strong)UILabel * footerLabel;//tableView的footerLabel


@property(nonatomic,strong)UIView * shadowView;//阴影视图
@property(nonatomic,assign)CGFloat selectBtnTag;//选择btn的tag

@end

@implementation SelecterDoctorVC
{
    NSInteger _page;
    NSDictionary * _paramsDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavItems:@{NAVTITLE:@"选择您的医生",NAVRIGTHTITLE:@"确定"}];
    //设置背景颜色
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    
    [self createUI];
    
    [self initData];
    [self requestDoctorData];
    
}
#pragma  mark 创建3个边框
- (void)createUI
{
    [self createTableView];
}

#pragma mark - 顶部选择视图，暂时去掉
-(void)createTopConditionView{
    NSArray* imageArr = @[@"Visit_SelectBG",@"Visit_SelectBG",@"Visit_SelectBG"];
    NSArray* labelArr = @[@"按距离",@"按口碑",@"按费用"];
    //btn的间距(10是俩个btn的间距)
    CGFloat btnWidth = (SZRScreenWidth - 10*2-40)/3.0;
    for (int i = 0; i<imageArr.count; i++) {
        UIButton* disBtn = [SZRFunction createButtonWithFrame:CGRectMake(20+i*(btnWidth+10), 15, btnWidth, PCH_Button_HEIGHT) withTitle:nil withImageStr:nil withBackImageStr:imageArr[i]];
        disBtn.tag = 300 + i;
        //注册事件
        [disBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:disBtn];
        UILabel* disLabel = [SZRFunction createLabelWithFrame:CGRectMake(10, 2.5, btnWidth-10*2, 20) color:RGBCOLOR(126, 126, 126) font:[UIFont boldSystemFontOfSize:14] text:labelArr[i]];
        disLabel.tag = 200 + i;
        [disBtn addSubview:disLabel];
    }
    
    //顶部按钮和tableView的分界线
    self.secondLine = [SZRFunction createImageViewFrame:CGRectMake(0, 15+PCH_Button_HEIGHT+7, SZRScreenWidth, 8) imageName:@"CareFamily_cellLine" color:nil];
    [self.view addSubview:self.secondLine];
    
}


#pragma mark 加载数据
- (void)initData
{
    self.dataArr = [NSMutableArray array];
    _page = 1;
}

-(void)resetParamsDic{
//    SZRLog(@"%zd,")
    NSDictionary* dic = @{@"page":[NSString stringWithFormat:@"%zd",_page],@"id":self.doctorID};
    _paramsDic = @{@"data":[RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dic]],@"token":[VDUserTools VD_GetToken]};
}


-(void)requestDoctorData{
    if (![VDNetRequest haveNet]) {
        [MBProgressHUD showTextOnly:@"网络连接错误!"];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
    [self resetParamsDic];
    [VDNetRequest VD_PostWithURL:VDDoctorSelectList_URL arrtribute:@{VDHTTPPARAMETERS:_paramsDic} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[RESULT] boolValue]) {
                
                NSArray * dataArr = (NSArray *)[RSAAndDESEncrypt DESDecryptResponseObject:responseObject];
                if (dataArr.count == 0) {
                    [self.tableV.mj_footer endRefreshingWithNoMoreData];
                }else{
                    SZRLog(@"选择医生列表%@",kBGDataStr)
                    for (NSDictionary * dic in dataArr) {
                        DoctListModel * model = [[DoctListModel alloc]init];
                        [model setModelValueWithDic:dic];
                        [self.dataArr addObject:model];
                    }

                    [self.tableV reloadData];
                    [self resetFooterLabelText];
                    [self endRefresh];
                }
                
                [MBProgressHUD hideHUD];
            }else{
                VD_ShowBGBackError(YES);
                [self endRefresh];
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:self];
                }
            }
        }else{
            SZRLog(@"error %@",error);
            [self endRefresh];
            VD_SHowNetError(YES);
        }
    }];
}



#pragma mark 创建TableView
- (void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableV = [[SZRTableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.secondLine.frame), SZRScreenWidth, SZRScreenHeight- CGRectGetMaxY(self.secondLine.frame) - 64) style:UITableViewStylePlain controller:self];
    self.tableV.backgroundColor = [UIColor clearColor];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableV registerNib:[UINib nibWithNibName:@"SelecterDoctorCell" bundle:nil] forCellReuseIdentifier:@"SELECTERDOCTORCELL"];
    
    //表尾
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 40)];
    self.footerLabel = [SZRFunction createLabelWithFrame:CGRectMake(0, 10, SZRScreenWidth, 20) color:SZR_NewLightGreen font:[UIFont systemFontOfSize:13] text:@""];
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:self.footerLabel];
    
    self.tableV.tableFooterView = footerView;
    
    //创建上拉加载
    [self createUpRefresh];
    //下拉刷新
    [self createDownRefresh];
}

-(void)createUpRefresh{
    self.tableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        
        [self requestDoctorData];
    }];
}

-(void)createDownRefresh{
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArr removeAllObjects];
        _page = 1;
        [self requestDoctorData];
    }];
}

#pragma mark tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectTableView) {
        return self.selectDataArr.count;
    }
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        return 44;
    }
    
    DoctListModel * model = self.dataArr[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SelecterDoctorCell class] contentViewWidth:SZRScreenWidth];
    
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
        if (self.selectDataArr.count > 0) {
            cell.textLabel.text = self.selectDataArr[indexPath.row];
        }
        return cell;
    }
    
    SelecterDoctorCell* selectCell = [tableView dequeueReusableCellWithIdentifier:@"SELECTERDOCTORCELL" forIndexPath:indexPath];
   
    if (self.dataArr.count > 0) {
        DoctListModel * model = self.dataArr[indexPath.row];
        selectCell.skipVCBlock = ^(){
            
            [self chatWithDoctor:model];
        };
        SZRLog(@"selectCell.selecterBtn.userInteractionEnabled = %d",selectCell.selecterBtn.userInteractionEnabled);
        selectCell.model = model;
    }
   
    return selectCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.selectTableView) {
        UILabel * label = [[self.view viewWithTag:self.selectBtnTag] viewWithTag:self.selectBtnTag - 100];
        label.text = self.selectDataArr[indexPath.row];
        [self closeView];
    }
    if (tableView == self.tableV) {
        [self skipToDoctorIntroVC:self.dataArr[indexPath.row]];
    }
}

-(void)chatWithDoctor:(DoctListModel *)model{
    [VDUserTools HH_InsertContactDoctor:@[model]finish:^{
    
    }];
    ChatTextVC * vc = [[ChatTextVC alloc]initWithConversationType:ConversationType_PRIVATE targetId:model.doctorRCId];
    vc.doctorModel = model;
    vc.displayUserNameInCell = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)skipToDoctorIntroVC:(DoctListModel *)model{
    DoctorIntroductionVC* doctorVC = [[DoctorIntroductionVC alloc] init];
    doctorVC.doctorModel = model;
    [self.navigationController pushViewController:doctorVC animated:YES];
}

#pragma mark 创建选择tableView
-(void)createSelectTableView{
    self.selectTableView = [[SZRTableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain controller:self];
    self.selectTableView.dataSource = self;
    self.selectTableView.delegate = self;
    [self.selectTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELLID"];
    self.selectTableView.tableFooterView = [UIView new];
    
}

#pragma mark 创建阴影视图
-(void)createShadowView{
    self.shadowView = [SZRFunction SZRCreateShadeView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [self.shadowView addGestureRecognizer:tap];
}

//收起视图
-(void)closeView{
    [self.selectTableView removeFromSuperview];
    [self.shadowView removeFromSuperview];
}

-(void)topBtnClick:(UIButton *)btn{
    CGRect btnFrame = btn.frame;
    
    self.selectBtnTag = btn.tag;
    
    if (!self.selectTableView) {
        [self createSelectTableView];
    }
    if (!self.shadowView) {
        [self createShadowView];
    }

    self.selectTableView.frame = CGRectMake(btnFrame.origin.x, CGRectGetMaxY(btnFrame), btnFrame.size.width, 200);
    self.selectDataArr = DICARR[[NSString stringWithFormat:@"%zd",btn.tag]];
    [self.selectTableView reloadData];
    
    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.selectTableView];
    
}

-(void)resetFooterLabelText{
    
    self.footerLabel.text = [NSString stringWithFormat:@"已经成功为你找到%zd位医生",self.dataArr.count];
}

-(void)endRefresh{
    //停止刷新
    [self.tableV.mj_header endRefreshing];
    [self.tableV.mj_footer endRefreshing];
    
}


//右侧发返回按钮
- (void)rightBtnClick
{
//    UIViewController * rootVC = self.navigationController.
  
    [self.navigationController popToRootViewControllerAnimated:YES];
  
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

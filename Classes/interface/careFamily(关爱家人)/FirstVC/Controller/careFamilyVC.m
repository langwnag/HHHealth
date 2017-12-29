//
//  careFamilyVC.m
//  YiJiaYi
//
//  Created by SZR on 16/9/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "careFamilyVC.h"
//cell
#import "CareFamilyCell.h"
#import "CareFamilyModel.h"
#import "FamilyDetailsVC.h"
#import "StoreVerifyNullView.h"
@interface careFamilyVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)SZRTableView * tableView;
//底部关联个数label
@property(nonatomic,strong)UILabel * relationNumLabel;
@property (nonatomic,strong)NSMutableArray* docterArr;
/** 空视图 */
@property (nonatomic,strong) StoreVerifyNullView* storeVerifyNullView;


@end

@implementation careFamilyVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createUI];
    //加载数据
    [self loadData];
    [self docterArr];
//    [self addRecordsNullView];
//    [self.view showBlankPageView];
}
// 视图为空 添加
- (void)addRecordsNullView{
    if (!self.storeVerifyNullView) {
        self.storeVerifyNullView = [[[NSBundle mainBundle] loadNibNamed:@"StoreVerifyNullView" owner:nil options:nil] lastObject];
        [self.storeVerifyNullView loadImageView:@"care_family_bg" labelStr:@"暂未关联家人~"];
        self.storeVerifyNullView.tramitLabel.textColor = [UIColor whiteColor];
        self.storeVerifyNullView.frame = self.tableView.frame;
        [SZRFunction SZRSetLayerImage:self.storeVerifyNullView imageStr:@"dl-bj"];

    }
//    [self.tableView addSubview:self.storeVerifyNullView];
//    [self.view bringSubviewToFront:self.storeVerifyNullView];
}

-(void)createUI{
    [self createNavItems:@{NAVTITLE:@"关爱家人",NAVRIGHTIMAGE:@"CareFamily_Add", NAVLEFTIMAGE:kBackBtnName}];

    //创建tableView
    [self createTableView];
}
- (NSMutableArray *)docterArr{
    if (_docterArr == nil) {
        // 初始化
        // 1加载数据
        NSString* path = [[NSBundle mainBundle] pathForResource:@"CareFamily.plist" ofType:nil];
        NSMutableArray* dictArr = [NSMutableArray arrayWithContentsOfFile:path];
        NSMutableArray* newArr = [NSMutableArray array];
        for (NSDictionary* dict in dictArr) {
            CareFamilyModel* dM = [CareFamilyModel careFamilyWithDict:dict];
            [newArr addObject:dM];
        }
        _docterArr = newArr;
    }
    return _docterArr;
}

-(void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64) style:UITableViewStylePlain controller:self];
    [SZRFunction SZRSetLayerImage:self.tableView imageStr:@"dl-bj"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 40)];
    //创建底部footerView
    self.relationNumLabel = [SZRFunction createLabelWithFrame:CGRectMake(0, 10, SZRScreenWidth, 20) color:SZR_NewLightGreen font:[UIFont systemFontOfSize:14] text:@""];
    self.relationNumLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.relationNumLabel];
    self.tableView.tableFooterView = view;
    //提前注册
    [self.tableView registerNib:[UINib nibWithNibName:@"CareFamilyCell" bundle:nil] forCellReuseIdentifier:@"CareFamilyCell"];
}
//加载数据
-(void)loadData{
    [self buttomLabelContent];
}

//设置底部关联个数label内容
-(void)buttomLabelContent{
    self.relationNumLabel.text = @"你已经关联了5位家人";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _docterArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1创建cell
    CareFamilyCell * careFamilyCell = [tableView dequeueReusableCellWithIdentifier:@"CareFamilyCell" forIndexPath:indexPath];
    careFamilyCell.LookClickBtnBlock =^(){
//        [self skipFamilyDetailsVC];
    };
    // 2给cell传递模型
    careFamilyCell.careFamilyModel = self.docterArr[indexPath.row];
    return careFamilyCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FamilyDetailsVC* familyVC = [FamilyDetailsVC new];
    familyVC.familyModel = self.docterArr[indexPath.row];
    familyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:familyVC animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

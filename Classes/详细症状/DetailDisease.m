//
//  DetailDisease.m
//  YiJiaYi
//
//  Created by SZR on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DetailDisease.h"
#import "SZRTableView.h"
#import "DiseaseHeaderView.h"
#import "DiseaseCell.h"
#import "PerfectInformationVC.h"
//表尾
#import "DiseaseFooterView.h"
#import "MedicalHistoryCell.h"
//模型
//病史
#import "DiseaseHistoryModel.h"


@interface DetailDisease ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)SZRTableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataArr;

@property(nonatomic,strong)NSArray * headerDataArr;//区头数据源数组

@property(nonatomic,assign)CGFloat rowHeight;//行高
//选中的疾病
@property(nonatomic,strong)NSMutableArray * diseaseSelectedArr;


@end

@implementation DetailDisease

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initData];
    [self createUI];
    [self loadData];
    
}

-(void)createUI{
  
    [self createNavItems:
    @{
    NAVLEFTIMAGE:kBackBtnName,
    NAVTITLE:@"详细症状",
    NAVRIGTHTITLE:@"取消"
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建tableView
    self.tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0,0, SZRScreenWidth, SZRScreenHeight-64) style:UITableViewStyleGrouped controller:self];
    //关闭回弹效果
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //提前注册
    [self.tableView registerNib:[UINib nibWithNibName:@"DiseaseHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"DiseaseHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiseaseCell" bundle:nil] forCellReuseIdentifier:@"DiseaseCell"];
    //创建表尾
     DiseaseFooterView * footerView = [[[NSBundle mainBundle]loadNibNamed:@"DiseaseFooterView" owner:nil options:nil]firstObject];
    NSString * str = footerView.textView.text;
    footerView.returnBlock = ^(){
        
        DiseaseHistoryModel * model = [[DiseaseHistoryModel alloc]init];
        model.symptomArr = [[NSMutableArray alloc]initWithArray:self.diseaseSelectedArr];
        model.describe = str;
    
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"PerfectInformationVC")]) {
                PerfectInformationVC * vc = (PerfectInformationVC *)obj;
                [vc.deseaseMarr addObject:model];
                [self.navigationController popToViewController:vc animated:YES];
                *stop = YES;
            }
        }];
    };
    self.tableView.tableFooterView = footerView;
    
}

-(void)initData{
    self.dataArr = [[NSMutableArray alloc]init];
    self.diseaseSelectedArr = [[NSMutableArray alloc]init];
}

-(void)loadData{
    self.headerDataArr = @[self.bodyPart];
    self.dataArr = [[NSMutableArray alloc]initWithArray:@[@[@"病1",@"病2",@"病3",@"病4",@"病5"]]];
}
#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headerDataArr.count;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
//关闭系统默认区尾的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiseaseCell * diseaseCell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseCell" forIndexPath:indexPath];
    diseaseCell.diseaseBlock = ^(NSString * str){
        [self.diseaseSelectedArr addObject:str];
    };
    self.rowHeight = [diseaseCell createBtnWithArr:self.dataArr[indexPath.section]];

    return diseaseCell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DiseaseHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DiseaseHeaderView"];
    headerView.headerTitle.text = [NSString stringWithFormat:@"%@您是否有以下症状?",self.headerDataArr[section]];
    
    return headerView;
}

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

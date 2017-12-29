//
//  HealthCircleView.m
//  YiJiaYi
//
//  Created by SZR on 16/9/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HealthCircleView.h"

#import "HealthCircleCell.h"
#import "HealthCircleFooterView.h"
#import "CircleModel.h"
#import "healthyCircleVC.h"

#define ViewHeight SZRScreenHeight-64-49
//疾病数组
#define DESEASE_ARR @[@"心脑血管",@"冠心病",@"糖尿病",@"高血压",@"胃病",@"精神病",@"肿瘤",@"营养",@"妇科炎症"]

@interface HealthCircleView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray * dataArr;

@property(nonatomic,assign)CGFloat rowHeight;//行高

@property(nonatomic,strong)HealthCircleFooterView * footerView;

@property(nonatomic,strong)NSNumber * selectedCircleID;//选择的疾病分类
@property(nonatomic,strong)NSMutableArray * selectedCircleIDs;//选择的疾病分类

@property(nonatomic,assign)BOOL fontViewISTableView;//顶部视图是否为tableView

@end

@implementation HealthCircleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.fontViewISTableView = YES;
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    //创建tableVIew
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, ViewHeight)];
//    [SZRFunction SZRSetLayerImage:self.tableView imageStr:@"dl-bj"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
    
    self.footerView = [[[NSBundle mainBundle]loadNibNamed:@"HealthCircleFooterView" owner:nil options:nil]firstObject];
    __weak HealthCircleView * tempSelf = self;
    
    self.footerView.confirmBtnClickBlock = ^(){
        [tempSelf changeView];
    };
    self.tableView.tableFooterView = self.footerView;
    //提前注册
    [self.tableView registerClass:NSClassFromString(@"HealthCircleCell") forCellReuseIdentifier:@"HealthCircleCell"];
    
    [self loadData];
}
- (void)loadData{
    [VDNetRequest HH_RequestHandle:nil URL:[NSString stringWithFormat:@"%@user/helthyCicleRange/selectAllCicleRangeList.html",VDNewServiceURL] viewController:nil success:^(id responseObject) {
        _dataArr = [CircleModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failureEndRefresh:^{
        
    } showHUD:NO hudStr:@""];
}


-(void)createSecondView{
    if (!self.secondView) {
        NSLog(@"创建大家圈视图");
        self.secondView = [[DajiaView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, self.frame.size.height)];
        self.secondView.circleVC = self.circleVC;
        [self addSubview:self.secondView];
    }
    [self.secondView reloadCircleData:self.selectedCircleIDs];
}

- (NSMutableArray *)selectedCircleIDs{
    
    if (!_selectedCircleIDs) {
        
        _selectedCircleIDs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectedCircleIDs;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthCircleCell * healthCircleCell = [tableView dequeueReusableCellWithIdentifier:@"HealthCircleCell" forIndexPath:indexPath];
    
    healthCircleCell.selectedDiseaseStrBlock = ^(NSNumber * circleID){
//        self.selectedCircleID = circleID;
        if(self.selectedCircleIDs.count > 0 &&[self.selectedCircleIDs containsObject:circleID]){
            [self.selectedCircleIDs removeObject:circleID];
        }else{
            
            [self.selectedCircleIDs addObject:circleID];
        }
    };
    self.rowHeight = [healthCircleCell loadData:self.dataArr];
    return healthCircleCell;
}

-(void)changeView{
    
    if (self.fontViewISTableView) {
        //tabelView在最上面
        if (self.selectedCircleIDs.count > 0) {
            
            [self createSecondView];
            [self bringSubviewToFront:self.secondView];
            self.fontViewISTableView = NO;
        }else{
            
            [MBProgressHUD showTextOnly:@"请选择一个分类"];
        }
    }
    
}

-(void)showDeseaseSelectView{
    
    if (!self.fontViewISTableView) {
        [self bringSubviewToFront:self.tableView];
        self.fontViewISTableView = YES;
    }
}



@end

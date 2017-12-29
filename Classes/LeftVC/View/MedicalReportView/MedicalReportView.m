//
//  MedicalReportView.m
//  YiJiaYi
//
//  Created by mac on 2017/2/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MedicalReportView.h"
#import "RecordGridCell.h"
#import "SZRImageBrower.h"
#import "StoreVerifyNullView.h"
#import "MedicalReportModel.h"

#define ItemImageArr @[@"medical_01",@"medical_icon",@"medical_01",@"medical_icon"]

@interface MedicalReportView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* tableV;
// item高度
@property(nonatomic,assign)CGFloat perItemHeight;
/** 空视图 */
@property (nonatomic,strong) StoreVerifyNullView* storeVerifyNullView;
/** page */
@property (nonatomic,assign) NSInteger page;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray* medicalDataArr;


@end

@implementation MedicalReportView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
       
        [self initData];
        [self createReportUI];
        [self addRecordsNullView];

    }
    return self;
}

- (NSMutableArray *)medicalDataArr{
    if (!_medicalDataArr) {
        _medicalDataArr = [NSMutableArray array];
    }
    return _medicalDataArr;
}

#pragma mark - 为了上线临时添加
- (void)addRecordsNullView{
    if (!self.storeVerifyNullView) {
        self.storeVerifyNullView = [[[NSBundle mainBundle] loadNibNamed:@"StoreVerifyNullView" owner:nil options:nil] lastObject];
        [self.storeVerifyNullView loadImageView:@"icon_doctor_header" labelStr:@"您的私人医生还没有上传档案，请耐心等待"];
        self.storeVerifyNullView.frame = self.tableV.frame;
    }
    [self addSubview:self.storeVerifyNullView];
    [self bringSubviewToFront:self.storeVerifyNullView];
}

- (void)initData{
    self.page = 1;
    self.perItemHeight = ((SZRScreenWidth-10*5)/4)/320*480-40;
//    SZRLog(@"🙄🙄开始 self.perItemHeight %lf", self.perItemHeight);

}
- (void)createReportUI{
    [self.tableV registerClass:[RecordGridCell class] forCellReuseIdentifier:@"RecordGridCell"];
    [self addSubview:self.tableV];
    [self downRefresh];
    [self upRefresh];
//    [self loadDataMedicalReport];

}

- (void)downRefresh{
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.medicalDataArr removeAllObjects];
        _page = 1;
        [self loadDataMedicalReport];
    }];
}

- (void)upRefresh{
    self.tableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self loadDataMedicalReport];
    }];
}

- (UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.medicalDataArr.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordGridCell* gridCell = [tableView dequeueReusableCellWithIdentifier:@"RecordGridCell" forIndexPath:indexPath];
    MedicalReportModel* model = self.medicalDataArr[indexPath.item];
    
    gridCell.imageClickBlock= ^(NSIndexPath* indexPath){
    
    if ([self.Tagdelegate respondsToSelector:@selector(MedicalReportCellClick:)]) {
            [self.Tagdelegate MedicalReportCellClick:model];
       }
    };
    if (self.medicalDataArr.count > 0) {
        [gridCell loadDataWithArr:self.medicalDataArr];
    }
    return gridCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    SZRLog(@"😁😁self.perItemHeight  %lf cell最高度: = %lf",self.perItemHeight,ceilf(ItemImageArr.count/4.0)* self.perItemHeight);
    return ceilf(self.medicalDataArr.count/2.0)* self.perItemHeight + 21+0.8+5+5 + 10 +(ceilf(self.medicalDataArr.count/2.0)-1)*8;
}


- (void)loadDataMedicalReport{

    NSDictionary* paramsDic = @{@"page":[NSString stringWithFormat:@"%ld",self.page]};
    [VDNetRequest HH_RequestHandle:paramsDic URL:kURL(@"user/medicalReport/selectMedicalReportList.html") viewController:self.viewController success:^(id responseObject) {
        
        id obj = [RSAAndDESEncrypt DESDecryptResponseObject:responseObject];
        NSArray* medicalArr = [MedicalReportModel mj_objectArrayWithKeyValuesArray:obj];
        [self.medicalDataArr addObjectsFromArray:medicalArr];
        if (medicalArr.count == 0) {
            [self.tableV.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableV.mj_footer endRefreshing];
        }
        [self.tableV.mj_header endRefreshing];
        [self.tableV reloadData];
    
    } failureEndRefresh:^{
        [self.tableV.mj_footer endRefreshing];
    } showHUD:NO hudStr:@""];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

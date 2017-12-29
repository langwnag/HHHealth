//
//  LYRelevantDishViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYRelevantDishViewController.h"
#import "RelevantFoodCell.h"
#import "LYRelevantFoodModel.h"
#import "ClassDetailVC.h"
#import "IWMPlayerViewController.h"

@interface LYRelevantDishViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

static CGFloat const cellHeight = 140.0f;

@implementation LYRelevantDishViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
}

//相关菜例
- (void)requestNetDataWithMaterialId:(NSString *)materialId page:(NSInteger)page{
//    [self.dataArr removeAllObjects];
    NSDictionary * dic = @{@"methodName":@"ApiRelatedDishes", @"material_id":materialId, @"page":[NSString stringWithFormat:@"%ld", page], @"size":@"10", @"appid":@"225858ca5671aca4658eef91fe445a87", @"appkey":@"f533b9849bcf7493"};
    [VDNetRequest COOKING_RequestHandle:dic
                         viewController:self
                                success:^(id responseObject) {
                            
                                    LYRelevantFoodModel * model = [LYRelevantFoodModel whc_ModelWithJson:responseObject];
                                    [self.dataArr addObjectsFromArray:model.data.data];
                                    [self.tableView reloadData];
                                    NSLog(@"%ld", self.dataArr.count);
                                    NSString * maxHeight = [NSString stringWithFormat:@"%lf", self.dataArr.count * cellHeight];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LYScrollViewShouldChangeContentSize" object:maxHeight] ;
                                    
                                    CGRect rect = self.tableView.frame;
                                    rect.size.height = self.dataArr.count * cellHeight;
                                    self.tableView.frame = rect;
                                    
                                    CGRect rect1 = self.view.frame;
                                    rect1.size.height = self.dataArr.count * cellHeight;
                                    self.view.frame = rect1;
                                    
                                } failureEndRefresh:^{
                                    
                                } showHUD:NO hudStr:nil];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"RelevantFoodCell" bundle:nil] forCellReuseIdentifier:@"RelevantFoodCell"];
    }
    return _tableView;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RelevantFoodCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelevantFoodCell"];
    if (self.dataArr.count > 0) {
        LYRelevantDetailData * dataModel = self.dataArr[indexPath.row];
        cell.model = dataModel;
        __weak LYRelevantDishViewController * weakSelf = self;
        cell.playBlock = ^(){
            [weakSelf setupCLplayer:[NSURL URLWithString:dataModel.video] titleStr:dataModel.desc];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.dataArr.count > 0) {
        LYRelevantDetailData * dataModel = self.dataArr[indexPath.row];
        ClassDetailVC * vc = [[ClassDetailVC alloc] init];
        vc.dishId = dataModel.dishes_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

- (void)setMaterialId:(NSString *)materialId{
    _materialId = materialId;
    [self requestNetDataWithMaterialId:materialId page:1];
}

- (void)setPage:(NSInteger)page{
    _page = page;
    [self requestNetDataWithMaterialId:self.materialId page:page];
}

    
#pragma mark - play video
- (void)setupCLplayer:(NSURL *)url titleStr:(NSString* )titleStr{
        
        IWMPlayerViewController *movie = [[IWMPlayerViewController alloc] init];
        movie.hidesBottomBarWhenPushed = YES;
        movie.videoURL = url;
        movie.videoTitle = titleStr;
        [self.navigationController pushViewController:movie animated:YES];
        
}



@end

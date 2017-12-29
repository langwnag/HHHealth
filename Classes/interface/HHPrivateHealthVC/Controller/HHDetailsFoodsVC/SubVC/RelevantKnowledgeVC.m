//
//  RelevantKnowledgeVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RelevantKnowledgeVC.h"
#import "RelevantKnowledgeHeaderView.h"
#import "RelevantKnowledgeCell.h"
#import "RelevantModel.h"
@interface RelevantKnowledgeVC ()
/** 表头 */
@property (nonatomic,strong) RelevantKnowledgeHeaderView* relevantKnowledgeHeaderView;
/** 数据源 */
@property (nonatomic,copy) NSArray* dataArray;
/** 模型 */
@property (nonatomic,strong) RelevantModel* model;
/** 数据源 */
//@property (nonatomic,strong) NSMutableArray* dataArr;

@end

@implementation RelevantKnowledgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataRelevant];
    [self.tableView registerClass:[RelevantKnowledgeCell class] forCellReuseIdentifier:@"RelevantKnowledgeCell"];

    self.tableView.tableHeaderView = self.relevantKnowledgeHeaderView;
}
//- (NSMutableArray *)dataArr{
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//    }
//    return _dataArr;
//}
- (void)loadDataRelevant{

    NSDictionary* paramsDic = @{@"methodName":@"ApiDishesKnowledge",
                                @"dishes_id":self.dishesId,
                                @"appid":COOKING_APPID,
                                @"appkey":COOKING_APPKEY
                                };
    [VDNetRequest COOKING_RequestHandle:paramsDic
                         viewController:self
                                success:^(id responseObject) {
                                
//                                    self.dataArr = [NSMutableArray array];
//                                    RelevantModel* model = [RelevantModel mj_objectWithKeyValues:responseObject[@"data"]];
//                                    [self.dataArr addObject:model];
//                                    
                                self.model = [RelevantModel mj_objectWithKeyValues:responseObject[@"data"]];
                                    [VDNetRequest VD_OSSImageView:self.relevantKnowledgeHeaderView.imageUrl fullURLStr:self.model.image placeHolderrImage:kDefaultLoading];
                                    [self.tableView reloadData];
                                } failureEndRefresh:^{
                                    
                                } showHUD:NO hudStr:@""];


}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"相关常识",@"制作指导"];
    }
    return _dataArray;
}

- (RelevantKnowledgeHeaderView *)relevantKnowledgeHeaderView{
    if (!_relevantKnowledgeHeaderView) {
        _relevantKnowledgeHeaderView = [[RelevantKnowledgeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, k6P_3AdaptedHeight(787))];
    }
    return _relevantKnowledgeHeaderView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RelevantKnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelevantKnowledgeCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titltStr = @"相关常识";
            cell.test = self.model.nutrition_analysis;
        }else{
             cell.titltStr = @"制作指导";
             cell.test = self.model.production_direction;
        }
//    RelevantModel* model = self.dataArr[indexPath.row];
//    cell.relevantModel = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row == 0) {
            NSString* str = self.model.nutrition_analysis;
            return [self.tableView cellHeightForIndexPath:indexPath model:str keyPath:@"test" cellClass:[RelevantKnowledgeCell class] contentViewWidth:SZRScreenWidth];
        }
        NSString* str = self.model.production_direction;
        return [self.tableView cellHeightForIndexPath:indexPath model:str keyPath:@"test" cellClass:[RelevantKnowledgeCell class] contentViewWidth:SZRScreenWidth];
    
//    RelevantModel* model = self.dataArr[indexPath.row];
//    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"relevantModel" cellClass:[RelevantKnowledgeCell class] contentViewWidth:SZRScreenWidth];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击middle-%d",(int)indexPath.row);
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

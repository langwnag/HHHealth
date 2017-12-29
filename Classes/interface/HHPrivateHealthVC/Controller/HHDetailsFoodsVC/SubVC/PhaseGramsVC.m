//
//  PhaseGramsVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PhaseGramsVC.h"
#import "RelevantKnowledgeHeaderView.h"
#import "TitlePhaseHeaderFooterView.h"
#import "PhaseGramsCell.h"
#import "PhaseGramsModel.h"
@interface PhaseGramsVC ()
/** RelevantKnowledgeHeaderView */
@property (nonatomic,strong) RelevantKnowledgeHeaderView* relevantKnowledgeHeaderView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray* dataArray;
/** 模型 */
@property (nonatomic,strong) PhaseGramsModel* phaseModel;


@end
static NSString *const headID = @"head";

@implementation PhaseGramsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataPhase];
    [self.tableView registerClass:[PhaseGramsCell class] forCellReuseIdentifier:@"PhaseGramsCell"];
    [self.tableView registerClass:[TitlePhaseHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headID];
    self.tableView.tableHeaderView = self.relevantKnowledgeHeaderView;

}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (void)loadDataPhase{
    NSDictionary* paramsDic = @{@"methodName":@"ApiDishesSuitable",
                                @"dishes_id":self.dishesId,
                                @"appid":COOKING_APPID,
                                @"appkey":COOKING_APPKEY
                                };
    [VDNetRequest COOKING_RequestHandle:paramsDic
                         viewController:self
                                success:^(id responseObject) {
                                    
                                    PhaseGramsModel* phaseModel = [PhaseGramsModel mj_objectWithKeyValues:responseObject[@"data"][@"material"]];
                                    NSArray* tempArr1 = phaseModel.suitable_with;
                                    NSArray* tempArr2 = phaseModel.suitable_not_with;
                                    self.dataArray = [NSMutableArray arrayWithArray:@[tempArr1,tempArr2]];
                                    self.phaseModel = phaseModel;
                                    [VDNetRequest VD_OSSImageView:self.relevantKnowledgeHeaderView.imageUrl fullURLStr:self.phaseModel.image placeHolderrImage:kDefaultLoading];
                                    [self.tableView reloadData];
                                } failureEndRefresh:^{
                                    
                                } showHUD:NO hudStr:@""];
    
    
}


- (RelevantKnowledgeHeaderView *)relevantKnowledgeHeaderView{
    if (!_relevantKnowledgeHeaderView) {
        if (!_relevantKnowledgeHeaderView) {
            _relevantKnowledgeHeaderView = [[RelevantKnowledgeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, k6P_3AdaptedHeight(787))];
        }
    }
    return _relevantKnowledgeHeaderView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60+k6P_3AdaptedWidth(40)+.8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhaseGramsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PhaseGramsCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        Suitable_with* model = self.dataArray[indexPath.section][indexPath.row];
        [VDNetRequest VD_OSSImageView:cell.imgUrl fullURLStr:model.image placeHolderrImage:kDefaultLoading];
        cell.titlePhaseLa.text = model.material_name;
        cell.desLa.text = model.suitable_desc;
    }else{
        Suitable_not_with* model = self.dataArray[indexPath.section][indexPath.row];
        [VDNetRequest VD_OSSImageView:cell.imgUrl fullURLStr:model.image placeHolderrImage:kDefaultLoading];
        cell.titlePhaseLa.text = model.material_name;
        cell.desLa.text = model.suitable_desc;
        
        
    }
    return cell;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TitlePhaseHeaderFooterView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];

    if (section == 0 ) {
        if (self.phaseModel.suitable_with.count > 0) {
            headerView.titleStr = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"与%@搭配相宜的食材",self.phaseModel.material_name] withSubStr:@"相宜" withColor:[UIColor greenColor] withFont:[UIFont systemFontOfSize:15]];
        }
    }else{
        if (self.phaseModel.suitable_not_with.count > 0) {
             headerView.titleStr = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"与%@搭配相克的食材",self.phaseModel.material_name] withSubStr:@"相克" withColor:[UIColor redColor] withFont:[UIFont systemFontOfSize:15]];
        }else{
            headerView.hidden = YES;
        }
    }
    return headerView;
}

// *******记住：设置区头颜色********
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
        UITableViewHeaderFooterView* headerV = (UITableViewHeaderFooterView* )view;
        headerV.backgroundView.backgroundColor = [UIColor whiteColor];

}

// UITableView的Style为Plain时禁止headerInsectionView固定在顶端：
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 50;
//    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

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

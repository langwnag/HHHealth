//
//  IngredientsVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "IngredientsVC.h"
#import "PersonalDataCell.h"
#import "IngredientsCell.h"
#import "IngredientsModel.h"

@interface IngredientsVC ()

/** 数据源 */
@property (nonatomic,strong) NSMutableArray* dataArray;

@end

@implementation IngredientsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataIngredient];

    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataCell" bundle:nil] forCellReuseIdentifier:@"PersonalDataCell"];
    [self.tableView registerClass:[IngredientsCell class] forCellReuseIdentifier:@"IngredientsCell"];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
- (void)loadDataIngredient{
    NSDictionary* paramsDic = @{@"methodName":@"ApiDishesIngredients",
                                @"dishes_id":self.dishesId,
                                @"appid":COOKING_APPID,
                                @"appkey":COOKING_APPKEY
                                };
    [VDNetRequest COOKING_RequestHandle:paramsDic
                         viewController:self
                                success:^(id responseObject) {
                                    IngredientsModel* model = [IngredientsModel mj_objectWithKeyValues:responseObject[@"data"]];
                                    NSArray * tmpArr1 = model.material;
                                    NSArray * tmpArr2 = model.spices;
                                    self.dataArray = [NSMutableArray arrayWithArray:@[tmpArr1, tmpArr2]];
                                    [self.tableView reloadData];
                                } failureEndRefresh:^{
                                    
                                } showHUD:NO hudStr:@""];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 44.0 : k6P_3AdaptedHeight(808)+8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        PersonalDataCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataCell" forIndexPath:indexPath];
        titleCell.valueLabel.textColor = [UIColor blackColor];
        titleCell.keyLabel.textColor = [UIColor blackColor];
        titleCell.dividerV.backgroundColor = [UIColor grayColor];
        titleCell.backgroundColor = [UIColor whiteColor];

        Material* model = self.dataArray[indexPath.section][indexPath.row];
        titleCell.keyLabel.text = model.material_name;
        titleCell.valueLabel.text = model.material_weight;
        
        return titleCell;
        
    }else{
        IngredientsCell* ingCell = [tableView dequeueReusableCellWithIdentifier:@"IngredientsCell" forIndexPath:indexPath];
        Spices* model = self.dataArray[indexPath.section][indexPath.row];
        [VDNetRequest VD_OSSImageView:ingCell.imgUrl fullURLStr:model.image placeHolderrImage:kDefaultLoading];
        ingCell.titleStr = model.title;
        return ingCell;
        
    }
    
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

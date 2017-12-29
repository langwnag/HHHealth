//
//  TableViewCell.m
//  YiJiaYi
//
//  Created by mac on 2017/6/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CategoryListCell.h"
#import "FoodView.h"
@interface CategoryListCell ()
@property (weak, nonatomic) IBOutlet UIView *collectionBgView;
/** FoodView */
@property (nonatomic,strong) FoodView* foodView;
/** 数据源 */
@property (nonatomic,copy) NSArray * foodDataArr;
@end

@implementation CategoryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.collectionBgView addSubview:self.foodView];
    [self.foodView.dataMarr addObjectsFromArray:self.foodDataArr];
}

- (NSArray *)foodDataArr{
    if (!_foodDataArr) {
        _foodDataArr = @[@"腊肠",@"甜",@"广东小吃",@"小吃",@"增强免面疫力"];
    }
    return _foodDataArr;
}

- (FoodView *)foodView{
    if (!_foodView) {
        _foodView = [[FoodView alloc] initWithFrame:CGRectMake(34, 0, SZRScreenWidth, 48)];
    }
    return _foodView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

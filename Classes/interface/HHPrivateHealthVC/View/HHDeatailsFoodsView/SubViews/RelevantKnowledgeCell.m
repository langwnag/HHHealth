//
//  RelevantKnowledgeCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RelevantKnowledgeCell.h"
@interface RelevantKnowledgeCell ()
/** <#注释#> */
@property (nonatomic,strong) UIImageView* picImg;
/** <#注释#> */
@property (nonatomic,strong) UIView* lastView;
/** <#注释#> */
@property (nonatomic,strong) UILabel* nutritionTitle;
/** <#注释#> */
@property (nonatomic,strong) UILabel* titleLa;
/** <#注释#> */
@property (nonatomic,strong) UIView* secondView;
/** <#注释#> */
@property (nonatomic,strong) UILabel* productionTitle;
/** <#注释#> */
@property (nonatomic,strong) UILabel* desLa;

@end
@implementation RelevantKnowledgeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        self.picImg = [UIImageView new];
        
        self.lastView = [UIView new];
        self.lastView.backgroundColor = [UIColor groupTableViewBackgroundColor];
       
//        self.nutritionTitle = [UILabel new];
//        self.nutritionTitle.text = @"相关知识";
        
        self.titleLa = [UILabel new];
//        self.titleLa.numberOfLines = 0;
        
//        self.secondView = [UIView new];
//        self.secondView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
//        self.productionTitle = [UILabel new];
//        self.productionTitle.text = @"制作指导";
        
        self.desLa = [UILabel new];
//        self.desLa.numberOfLines = 0;
        [self.contentView sd_addSubviews:@[self.lastView,self.titleLa,self.desLa]];
//        [self.contentView sd_addSubviews:@[self.picImg,self.lastView,self.nutritionTitle,self.titleLa,self.secondView,self.productionTitle,self.desLa]];
        
//        self.picImg.sd_layout
//        .topSpaceToView(self.contentView,k6P_3AdaptedHeight(20))
//        .rightEqualToView(self.contentView)
//        .leftEqualToView(self.contentView)
//        .heightIs(k6P_3AdaptedHeight(768));

        self.lastView.sd_layout
        .topEqualToView(self.contentView)
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .heightIs(8);

//        self.nutritionTitle.sd_layout
//        .topSpaceToView(_lastView,k6P_3AdaptedHeight(20))
//        .leftSpaceToView(self.contentView,k6P_3AdaptedWidth(44))
//        .widthIs(220)
//        .heightIs(21);
        
        self.titleLa.sd_layout
        .widthIs(220)
        .heightIs(21)
        .topSpaceToView(_lastView,k6P_3AdaptedHeight(20))
        .leftSpaceToView(self.contentView,k6P_3AdaptedWidth(44));
        
//        self.secondView.sd_layout
//        .topEqualToView(_titleLa)
//        .leftEqualToView(self.contentView)
//        .rightEqualToView(self.contentView)
//        .heightIs(8);
        
//        self.productionTitle.sd_layout
//        .topSpaceToView(_secondView,k6P_3AdaptedHeight(20))
//        .leftSpaceToView(self.contentView,k6P_3AdaptedWidth(44))
//        .widthIs(220)
//        .heightIs(21);

        self.desLa.sd_layout
        .topSpaceToView(self.titleLa,k6P_3AdaptedHeight(20))
        .leftSpaceToView(self.contentView,k6P_3AdaptedWidth(44))
        .rightSpaceToView(self.contentView,k6P_3AdaptedWidth(44))
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:self.desLa bottomMargin:k6P_3AdaptedHeight(20)];

    }
    return self;
}

- (void)setRelevantModel:(RelevantModel *)relevantModel{
    _relevantModel = relevantModel;
    [VDNetRequest VD_OSSImageView:self.picImg fullURLStr:relevantModel.image placeHolderrImage:kDefaultLoading];
    self.titleLa.text = relevantModel.nutrition_analysis;
    self.desLa.text = relevantModel.production_direction;

}

- (void)setTest:(NSString *)test{
    _test = test;
    self.desLa.text = test;
}
- (void)setTitltStr:(NSString *)titltStr{
    _titltStr = titltStr;
    self.titleLa.text = titltStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

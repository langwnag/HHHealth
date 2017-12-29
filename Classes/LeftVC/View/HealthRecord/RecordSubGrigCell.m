//
//  HealthRecordCell.m
//  YiJiaYi
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RecordSubGrigCell.h"
#import "NSString+LYString.h"
@implementation RecordSubGrigCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}
- (void)createUI{
    UIView* contentView = self.contentView;
    self.imageV = [UIImageView new];
    [contentView addSubview:self.imageV];

    self.timeLa = [UILabel new];
    self.timeLa.font = kLightFont(kFontAdaptedWidth(12));
    self.timeLa.textColor = kWord_Gray_6;
    [contentView addSubview:self.timeLa];
    
    self.testDescLa = [UILabel new];
    self.testDescLa.font = kLightFont(kFontAdaptedWidth(12));
    self.testDescLa.textColor = kWord_Gray_6;
    [contentView addSubview:self.testDescLa];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAdaptedHeight(-5));
        make.left.mas_equalTo(kAdaptedWidth(5));
        make.right.mas_offset(kAdaptedWidth(-5));
        make.bottom.mas_offset(kAdaptedHeight(5));
    }];
    
    [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(kAdaptedHeight(2));
        make.centerX.equalTo(self.imageV.mas_centerX);
        make.right.mas_offset(kAdaptedWidth(-5));
        make.right.mas_offset(kAdaptedHeight(5));
    }];
    
    [self.testDescLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLa.mas_bottom).offset(k6P_3AdaptedHeight(7));
        make.centerX.equalTo(self.imageV.mas_centerX);
        make.width.height.equalTo(self.testDescLa);
    }];
}

- (void)setModel:(MedicalReportModel *)model{
    _model = model;
    [VDNetRequest VD_OSSImageView:self.imageV fullURLStr:model.reportKey placeHolderrImage:kDefaultLoading];
    self.timeLa.text = [NSString getTimeWithStamp:[NSString stringWithFormat:@"%ld",model.reportTime] dateFormartter:@"yyyy-MM-dd"];
    self.testDescLa.text = model.type;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

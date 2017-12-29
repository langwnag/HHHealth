//
//  ShowStatesCell.m
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ShowStatesCell.h"
@interface ShowStatesCell ()
@property (nonatomic,strong) UILabel* lineLa;

@end
@implementation ShowStatesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.topUpWayLa = [SZRFunction createLabelWithFrame:CGRectNull color:kWord_Gray_4 font:[UIFont systemFontOfSize:kAdaptedHeight(24/2)] text:@""];
    [self.contentView addSubview:self.topUpWayLa];
    [self.topUpWayLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kAdaptedWidth(37/2));
        make.top.mas_equalTo(kAdaptedHeight(27/2));
        make.size.mas_equalTo(CGSizeMake(kAdaptedWidth(200), kAdaptedHeight(24/2)));
    }];
    self.moneyLa = [SZRFunction createLabelWithFrame:CGRectNull color:[UIColor orangeColor] font:[UIFont systemFontOfSize:kAdaptedHeight(15)] text:@""];
    self.moneyLa.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.moneyLa];
    [self.moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kAdaptedWidth(37/2));
        make.top.equalTo(self.topUpWayLa.mas_top);
        make.size.mas_equalTo(CGSizeMake(kAdaptedWidth(120), kAdaptedHeight(20)));
    }];
    self.dataLa = [SZRFunction createLabelWithFrame:CGRectNull color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:kAdaptedHeight(10)] text:@""];
    [self.contentView addSubview:self.dataLa];
    [self.dataLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topUpWayLa.mas_left);
        make.top.equalTo(self.topUpWayLa.mas_bottom).offset(kAdaptedHeight(27/2));
        make.size.mas_equalTo(CGSizeMake(kAdaptedWidth(220), kAdaptedHeight(24/2)));
    }];
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = HEXCOLOR(0xdfdee1);
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dataLa.mas_bottom).offset(kAdaptedHeight(27/2));
        make.left.mas_equalTo(kAdaptedWidth(36/2));
        make.right.mas_equalTo(-kAdaptedWidth(36/2));
        make.height.mas_equalTo(0.5);
    }];
    self.lineLa = lineLabel;
}
- (void)configCellWithModel:(ShowStatesModel *)model{
    self.topUpWayLa.text = model.title;
    self.dataLa.text = model.data;
    self.moneyLa.text = model.money;
}
+ (CGFloat)heightWithModel:(ShowStatesModel *)model{
    ShowStatesCell* cell = [[ShowStatesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell configCellWithModel:model];
    [cell layoutIfNeeded];
    CGRect frame =  cell.lineLa.frame;
    return frame.origin.y + frame.size.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
@implementation ShowStatesModel

@end

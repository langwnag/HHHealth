//
//  VDTitleAndPromptCell.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/8/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "VDTitleAndPromptCell.h"

@interface VDTitleAndPromptCell()

@property(strong,nonatomic)UIView *lineView;
@end
//static const CGFloat spaceWith=15;

@implementation VDTitleAndPromptCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背影色
        self.backgroundColor=[UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        CGFloat spaceWith = kAdaptedWidth(15);
        
        if (self.keyLabel==nil) {
            self.keyLabel=[[UILabel alloc]init];
            self.keyLabel.font=kAdaptedFontSize(14);
            self.keyLabel.textColor=kWord_Gray_6;
            [self.contentView addSubview:self.keyLabel];
            [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(spaceWith);
                make.centerY.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(80, kAdaptedHeight(15)));
            }];
        }
        
        if (self.valueLabel==nil) {
            self.valueLabel=[[UILabel alloc]init];
            self.valueLabel.textAlignment=NSTextAlignmentRight;
            self.valueLabel.font=kAdaptedFontSize(14);
            self.valueLabel.textColor=kWord_Gray_9;
            [self.contentView addSubview:self.valueLabel];
            [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(SZRScreenWidth-80-2*spaceWith, kAdaptedHeight(18)));
            }];
        }
        
        if (self.lineView==nil) {
            self.lineView = [[UIView alloc] init];
            self.lineView.hidden=YES;
            self.lineView.backgroundColor=COLOR_UNDER_LINE;
            [self.contentView addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(spaceWith);
                make.right.mas_equalTo(self).offset(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(@0.5);
            }];
        }
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


-(void)setCellDataKey:(NSString *)curkey curValue:(NSString *)curvalue
{
    self.keyLabel.text=curkey;
    self.valueLabel.text = curvalue;
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

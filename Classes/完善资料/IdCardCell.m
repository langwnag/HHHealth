//
//  IdCardCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "IdCardCell.h"
@interface IdCardCell ()
@property(strong,nonatomic)UIView *lineView;

@end
@implementation IdCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置背影色
        self.backgroundColor=[UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        CGFloat spaceWith = kAdaptedWidth(15);

        if (self.keyLabel==nil) {
            self.keyLabel=[[UILabel alloc]init];
            self.keyLabel.font=kAdaptedFontSize(14);
            self.keyLabel.textColor=kWord_Gray_6;
            self.keyLabel.text = @"身份证号";
            [self.contentView addSubview:self.keyLabel];
            [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(spaceWith);
                make.centerY.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(80, kAdaptedHeight(15)));
            }];
        }
        if (self.cardTextField==nil) {
            self.cardTextField=[[UITextField alloc]init];
            self.cardTextField.textAlignment=NSTextAlignmentRight;
            self.cardTextField.font=kAdaptedFontSize(14);
            self.cardTextField.textColor=kWord_Gray_9;
            self.cardTextField.keyboardType = UIKeyboardTypeNumberPad;
            [self.contentView addSubview:self.cardTextField];
            [self.cardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

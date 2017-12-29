//
//  NamePhoneNumCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NamePhoneNumCell.h"

@interface NamePhoneNumCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@end

@implementation NamePhoneNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    _nameLabel.font = kLightFont(k6PFontAdaptedWidth(14));
    _nameTF.font = _nameLabel.font;
    _phoneLabel.font = _nameLabel.font;
    _phoneNum.font = _nameLabel.font;
    _phoneNum.delegate = self;
    
    UIView * contentView = self.contentView;
    _nameLabel.sd_layout
    .leftSpaceToView(contentView,k6PAdaptedWidth(82.0/3))
    .widthIs(k6PAdaptedWidth(175.0/3))
    .centerYEqualToView(contentView)
    .heightIs(k6PAdaptedHeight(55.0/3));
    
    _nameTF.sd_layout
    .leftSpaceToView(_nameLabel,k6P_3AdaptedWidth(24))
    .rightSpaceToView(contentView,SZRScreenWidth/2 + k6P_3AdaptedWidth(60))
    .heightIs(k6P_3AdaptedHeight(81))
    .centerYEqualToView(contentView);
    
    _nameTF.sd_cornerRadius = @(k6PAdaptedHeight(5));
    [self textFieldContentInset:_nameTF];
    
    _phoneLabel.sd_layout
    .leftSpaceToView(contentView,SZRScreenWidth/2)
    .heightRatioToView(_nameLabel,1)
    .centerYEqualToView(contentView);
    [_phoneLabel setSingleLineAutoResizeWithMaxWidth:k6P_3AdaptedWidth(160)];
    
    _phoneNum.sd_layout
    .leftSpaceToView(_phoneLabel,k6P_3AdaptedWidth(24))
    .rightSpaceToView(contentView,k6P_3AdaptedWidth(105))
    .centerYEqualToView(contentView)
    .heightRatioToView(_nameTF,1);
    
    _phoneNum.sd_cornerRadius = @(k6PAdaptedHeight(5));
    [self textFieldContentInset:_phoneNum];
    
}

-(void)textFieldContentInset:(UITextField *)textField{
    textField.sd_cornerRadius = @(k6PAdaptedHeight(5));
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 10)];
    textField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8,10)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length + string.length > 11) {
        return NO;
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  OrderAddressCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderAddressCell.h"

@implementation OrderAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self configUI];
    }
    return self;
}



-(void)configUI{

    _titleLabel = [SZRFunction createLabelWithFrame:CGRectNull color:kWord_Gray_4 font:kLightFont(k6PFontAdaptedWidth(14)) text:@"前往地址"];
    _titleLabel.textAlignment = NSTextAlignmentRight;

    _addressTextView = [[UITextView alloc]init];
    [_addressTextView setTextColor:HEXCOLOR(0x444444)];
    _addressTextView.font = kLightFont(k6PFontAdaptedWidth(13));
    _addressTextView.backgroundColor = kBG_LightGray_Color;
    _addressTextView.delegate = self;
    _addressTextView.scrollEnabled = NO;
    _addressTextView.layer.cornerRadius = k6PAdaptedWidth(5);
    _addressTextView.layer.masksToBounds = YES;
    
    UIView * contentView = self.contentView;
    [contentView sd_addSubviews:@[_titleLabel,_addressTextView]];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIView * contentView = self.contentView;

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(k6PAdaptedWidth(82.0/3));
        make.top.equalTo(contentView).offset(k6P_3AdaptedHeight(28));
        make.width.equalTo(@(k6PAdaptedWidth(175.0/3)));
        make.height.equalTo(@(k6PAdaptedHeight(55.0/3)));
    }];
    
    [_addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(k6PAdaptedWidth(12));
        make.top.equalTo(_titleLabel.mas_top);
        make.right.equalTo(contentView.mas_right).offset(- k6PAdaptedWidth(82.0/3));
        make.bottom.equalTo(contentView.mas_bottom).offset(-k6P_3AdaptedHeight(28));
    }];
    
    
   
    
    
}


-(void)textViewDidChange:(UITextView *)textView{
    //博客园-FlyElephant
    static CGFloat maxHeight = 100.0f;
    CGRect frame = textView.frame;
    SZRLog(@"frame = %@",NSStringFromCGRect(frame));
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    SZRLog(@"size = %@",NSStringFromCGSize(size));
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            [_addressTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(size.height));
            }];
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;// 不允许滚动
            
        }
    }
    
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    SZRLog(@"textView.bounds = %@",NSStringFromCGRect(textView.bounds));
    UITableView * tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
    
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

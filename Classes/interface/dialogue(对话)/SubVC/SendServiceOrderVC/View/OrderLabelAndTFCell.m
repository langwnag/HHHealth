//
//  OrderLabelAndTFCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderLabelAndTFCell.h"
#import "ServiceTypeModel.h"
@interface OrderLabelAndTFCell ()

@property (weak, nonatomic) IBOutlet UIImageView *rightTriangleImageV;



@end

@implementation OrderLabelAndTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self.contentLabel addSubview:_rightTriangleImageV];
    
    self.titleLabel.font = kLightFont(k6PFontAdaptedWidth(14));
    self.contentLabel.font = self.titleLabel.font;
    
    
    UIView * contentView = self.contentView;
    self.titleLabel.sd_layout
    .leftSpaceToView(contentView,k6PAdaptedWidth(82.0/3))
    .widthIs(k6PAdaptedWidth(175.0/3))
    .centerYEqualToView(contentView)
    .heightIs(k6PAdaptedHeight(55.0/3));
    
    self.contentLabel.sd_layout
    .leftSpaceToView(_titleLabel,k6PAdaptedWidth(12))
    .rightSpaceToView(contentView,k6PAdaptedWidth(82.0/3))
    .heightIs(k6P_3AdaptedHeight(81))
    .centerYEqualToView(contentView);
    
    self.contentLabel.sd_cornerRadius = @(k6PAdaptedWidth(5));
    [self.contentLabel setInsets:UIEdgeInsetsMake(0, k6P_3AdaptedWidth(31), 0, k6P_3AdaptedWidth(84))];
    
    _rightTriangleImageV.sd_layout
    .rightSpaceToView(_contentLabel,k6P_3AdaptedWidth(30))
    .widthIs(k6P_3AdaptedWidth(24))
    .heightEqualToWidth(YES)
    .centerYEqualToView(_contentLabel);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentLabel:)];
    [self.contentLabel addGestureRecognizer:tap];
    
    
}



-(void)contenLabelText:(NSString *)str{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    //第一行头缩进
    [paragraphStyle setFirstLineHeadIndent:k6P_3AdaptedWidth(31)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    [_contentLabel setAttributedText:attributedString];
}

-(void)tapContentLabel:(UITapGestureRecognizer *)tap{
    if ([_titleLabel.text isEqualToString:@"预约时间"]) {
        [self selectOrderTime];
    }else{
        [self selectServiceType];
    }

}

-(void)selectOrderTime{
    NSDate * beginDate = _contentLabel.text.length > 0 ? [NSDate dateWithString:_contentLabel.text format:@"yyyy-MM-dd"] : [NSDate date];
    ActionSheetDatePicker * datePicker = [[ActionSheetDatePicker alloc]initWithTitle:@"预约时间" datePickerMode:UIDatePickerModeDate selectedDate:beginDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        _contentLabel.text = [selectedDate formatYMD];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self];
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:7 * 24 * 3600];
    [datePicker showActionSheetPicker];
}

-(void)selectServiceType{
    
    if (!self.serviceTypes) {
        if (self.serviceTypeBlock) {
            self.serviceTypeBlock();
        }
    }else{
        [self showServiceTypePickerView];
    }
    
    
}

-(void)showServiceTypePickerView{
    
    NSMutableArray * serviceTypeNames = [NSMutableArray array];
    [self.serviceTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [serviceTypeNames addObject:[(ServiceTypeModel *)obj serviceName]];
    }];
    
    NSInteger selectIndex = _contentLabel.text.length > 0 ? [serviceTypeNames indexOfObject:_contentLabel.text] : 0;
    [ActionSheetStringPicker showPickerWithTitle:@"服务类型" rows:serviceTypeNames initialSelection:selectIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        _contentLabel.text = serviceTypeNames[selectedIndex];
        self.serviceId = [self.serviceTypes[selectedIndex] serviceId];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

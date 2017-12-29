//
//  MyOrderCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MyOrderCell.h"
#import "SelectFamilyVisitModel.h"
@implementation MyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageUrl.layer.cornerRadius = 5.0f;
    self.imageUrl.layer.masksToBounds = YES;
    self.nameLa.font = SYSTEMFONT(36/3);
    self.attendingLa.textColor = kWord_Gray_6;
    self.attendingLa.font = SYSTEMFONT(36/3);
    self.lineV.backgroundColor = HEXCOLOR(0xe9e9e9);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelectFamilyVisitModel:(SelectFamilyVisitModel *)selectFamilyVisitModel{
    _selectFamilyVisitModel = selectFamilyVisitModel;
    [VDNetRequest VD_OSSImageView:self.imageUrl fullURLStr:selectFamilyVisitModel.doctorInformation.pictureUrl placeHolderrImage:kDefaultDoctorImage];
    self.nameLa.text = selectFamilyVisitModel.doctorInformation.name;
    
  
    // 字符串转字典数组
//    NSData *jsonData = [selectFamilyVisitModel.doctorInformation.goodField dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableArray * arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
//    for (int i = 0 ;i < arr.count; i++) {
//        NSDictionary* dic = arr[i];
//        NSString* keyStr = [NSString stringWithFormat:@"%d",i];
//        NSString* valueStr = [dic objectForKey:keyStr];
//        self.attendingLa.text = valueStr;
//    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

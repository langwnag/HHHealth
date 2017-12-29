//
//  OrderTimeCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderTimeCell.h"
@interface OrderTimeCell ()
@property (strong, nonatomic) UIButton* currentSelectBtn;


@end

@implementation OrderTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.twentyBtn.selected = YES;

    self.tenBtn.layer.cornerRadius = 5.0f;
    self.tenBtn.layer.masksToBounds = YES;
    self.tenBtn.backgroundColor = HEXCOLOR(0xe4e4e4);
    [self.tenBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.tenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.tenBtn setBackgroundImage:IMG(@"defaultBackG") forState:UIControlStateNormal];
    [self.tenBtn setBackgroundImage:IMG(@"selectBackG") forState:UIControlStateSelected];
    
    
    self.twentyBtn.layer.cornerRadius = 5.0f;
    self.twentyBtn.layer.masksToBounds = YES;
    [self.twentyBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.twentyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.twentyBtn setBackgroundImage:IMG(@"defaultBackG") forState:UIControlStateNormal];
    [self.twentyBtn setBackgroundImage:IMG(@"selectBackG") forState:UIControlStateSelected];

    self.thirtybtn.layer.cornerRadius = 5.0f;
    self.thirtybtn.layer.masksToBounds = YES;
    self.thirtybtn.backgroundColor = HEXCOLOR(0xe4e4e4);
    [self.thirtybtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.thirtybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.thirtybtn setBackgroundImage:IMG(@"defaultBackG") forState:UIControlStateNormal];
    [self.thirtybtn setBackgroundImage:IMG(@"selectBackG") forState:UIControlStateSelected];
    

    self.oneHourBtn.layer.cornerRadius = 5.0f;
    self.oneHourBtn.layer.masksToBounds = YES;
    self.oneHourBtn.backgroundColor = HEXCOLOR(0xe4e4e4);
    [self.oneHourBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.oneHourBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.oneHourBtn setBackgroundImage:IMG(@"defaultBackG") forState:UIControlStateNormal];
    [self.oneHourBtn setBackgroundImage:IMG(@"selectBackG") forState:UIControlStateSelected];
    

}
- (IBAction)tenBtn:(UIButton *)sender {
    [self.tenBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
   
}
- (IBAction)twicebtn:(UIButton *)sender {
    [self.twentyBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

}
- (IBAction)thirtyBtn:(UIButton *)sender {
    [self.thirtybtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

}
- (IBAction)oneHourBtn:(UIButton *)sender {
    [self.oneHourBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)selectBtn:(UIButton* )btn{
        self.twentyBtn.selected = NO;
    
        self.currentSelectBtn.selected = NO;
        btn.selected = YES;
        self.currentSelectBtn = btn;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

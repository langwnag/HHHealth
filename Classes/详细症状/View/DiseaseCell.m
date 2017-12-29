//
//  DiseaseCell.m
//  YiJiaYi
//
//  Created by SZR on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DiseaseCell.h"

@implementation DiseaseCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

-(CGFloat)createBtnWithArr:(NSArray *)dataArr{
    //距左边间距
    CGFloat leftSpace = 10;
    CGFloat barLineSpace = 10;
    for (int i = 0; i < dataArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = 100 + i;
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 12.5f;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = SZRNavColor.CGColor;
        //注册事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //计算文字的大小
        CGFloat length = [dataArr[i] boundingRectWithSize:CGSizeMake(SZRScreenWidth,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
        [btn setTitle:dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:SZRNavColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"diseaseSelectBg"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        btn.frame = CGRectMake(leftSpace, barLineSpace, length+15, 25);
        //判断是否需要换行
        if (leftSpace+length+15+10 > SZRScreenWidth) {
            //换行时将leftSpace置为20
            leftSpace = 10;
            barLineSpace = barLineSpace + 25 + 10;
            btn.frame = CGRectMake(leftSpace, barLineSpace, length+15, 25);
        }
        
        leftSpace = btn.frame.size.width + btn.frame.origin.x + 10;
        [self.contentView addSubview:btn];
    }
    return barLineSpace + 50;
}

-(void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (self.diseaseBlock) {
            self.diseaseBlock(btn.titleLabel.text);
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

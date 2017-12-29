//
//  MyCell.m
//  Cell自适应宽度
//
//  Created by SZR on 16/10/12.
//  Copyright © 2016年 VDChina. All rights reserved.
//

#import "MyCell.h"

#import "Masonry.h"

@implementation MyCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //长按手势
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClick)];
        [self addGestureRecognizer:longPress];
        //单击手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress)];
        [self.deseaseLabel addGestureRecognizer:tap];
        
        [self.contentView bringSubviewToFront:self.deleteBtn];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //约束
    [self.deseaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@0.1);
        make.right.equalTo(self.contentView).priorityLow();
        make.height.equalTo(@25);
        make.height.equalTo(self.contentView).priorityLow();
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
}


-(UILabel *)deseaseLabel{
    if (!_deseaseLabel) {
        _deseaseLabel = [[UILabel alloc]init];
        _deseaseLabel.font = [UIFont boldSystemFontOfSize:13];
        _deseaseLabel.backgroundColor = SZR_NewLightGreen;
        _deseaseLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_deseaseLabel];
    }
    return _deseaseLabel;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"left_delete"] forState:UIControlStateNormal];
        _deleteBtn.hidden = YES;
        [self.contentView addSubview:self.deleteBtn];
    }
    return _deleteBtn;
}

-(void)deleteBtnClick{
    [self.delegate deleteCellAtIndexpath:self.indexPath];
}

-(void)longClick{
    [self.delegate showAllDeleteBtn];
}

-(void)tapPress{
    [self.delegate hideAllDeleteBtn];
}


@end

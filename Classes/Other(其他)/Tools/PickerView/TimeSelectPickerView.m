//
//  TimeSelectPickerView.m
//  SZRPickerView
//
//  Created by SZR on 2016/12/27.
//  Copyright © 2016年 Family technology. All rights reserved.
//



#import "TimeSelectPickerView.h"
#define NavOffSet 64
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height - NavOffSet

@implementation TimeSelectPickerView
{
    
    NSArray * _dataArr;
    
}

-(instancetype)initWithSelectedDataArr:(NSArray *)arr{
    if (self = [super init]) {
        _selectedMarr = [NSMutableArray arrayWithArray:arr];
        self.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [self loadData];
        [self createUI];
    }
    return self;
}

-(void)loadData{
    
    NSMutableArray * timeMarr = [[NSMutableArray alloc]initWithObjects:@"无", nil];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:-8*3600];
    NSString * str = @"";
    do {
        str = [date stringWithFormat:@"HH:mm"];
        [timeMarr addObject:str];
        date = [[NSDate alloc]initWithTimeInterval:10*60 sinceDate:date];
    } while ([str compare:@"23:50"]);

    _dataArr = timeMarr;
}

-(void)createUI{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-250, ScreenWidth, 250)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    [bottomView addSubview:topView];
    
    UILabel * midLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    midLabel.textColor = [UIColor blackColor];
    midLabel.font = [UIFont boldSystemFontOfSize:17];
    midLabel.text = @"服药时间";
    midLabel.textAlignment = NSTextAlignmentCenter;
    midLabel.center = CGPointMake(self.center.x, midLabel.center.y);
    [bottomView addSubview:midLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGBCOLOR(21, 126, 251) forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.frame = CGRectMake(10, 0, 100, 30);
    [cancelButton addTarget:self action:@selector(dismissPickview) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelButton];

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:RGBCOLOR(21, 126, 251) forState:UIControlStateNormal];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmButton.frame = CGRectMake(ScreenWidth - 10 - 100, 0, 100, 44);
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:confirmButton];
    
    CGFloat labelWidth = ScreenWidth/4;
    NSArray * titleArr = @[@"第一次",@"第二次",@"第三次",@"第四次"];
    for (int i = 0; i < 4; i++) {
        UILabel * label = [UILabel new];
        label.frame = CGRectMake(labelWidth*i, 40, labelWidth, 20);
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:label];
    }
    
    _pickerView = [UIPickerView new];
    _pickerView.frame = CGRectMake(0, 70, ScreenWidth, 250 - 70);
    _pickerView.dataSource = self;
    _pickerView.delegate =self;

    [bottomView addSubview:_pickerView];
 
}

-(void)reloadData{
    int i = (int)_selectedMarr.count;
    while (i < 4) {
        [_selectedMarr addObject:@"无"];
        i++;
    }
    for (int i = 0; i < 4; i++) {
        NSInteger index = [_dataArr containsObject:_selectedMarr[i]] ? [_dataArr indexOfObject:_selectedMarr[i]] : 0;
        [_pickerView selectRow:index inComponent:i animated:YES];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self reloadData];
}

#pragma makr- pickview delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataArr.count;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
    }
    pickerLabel.text = _dataArr[row];
    return pickerLabel;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return ScreenWidth / 4;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    BOOL ret = NO;
    for (int i = 0; i < _selectedMarr.count; i++) {
        if (i != component && [_selectedMarr[i] isEqualToString:_dataArr[row]]) {
            ret = YES;
            [pickerView selectRow:0 inComponent:component animated:YES];
            [_selectedMarr replaceObjectAtIndex:component withObject:_dataArr[0]];
        }
    }
    if (!ret) {
        [_selectedMarr replaceObjectAtIndex:component withObject:_dataArr[row]];
    }
    
}


-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

-(void)dismissPickview{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)confirmAction{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.confirmBlock) {
            self.confirmBlock(_selectedMarr);
        }
    }];
}


@end

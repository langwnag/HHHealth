//
//  TimeSelectPickerView.h
//  SZRPickerView
//
//  Created by SZR on 2016/12/27.
//  Copyright © 2016年 Family technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(NSArray *);

@interface TimeSelectPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,copy)ConfirmBlock confirmBlock;
@property(nonatomic,strong)NSMutableArray * selectedMarr;
@property(nonatomic,strong)UIPickerView * pickerView;


-(instancetype)initWithSelectedDataArr:(NSArray *)arr;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
-(void)show;
-(void)reloadData;



@end

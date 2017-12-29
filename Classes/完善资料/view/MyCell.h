//
//  MyCell.h
//  Cell自适应宽度
//
//  Created by SZR on 16/10/12.
//  Copyright © 2016年 VDChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>

-(void)deleteCellAtIndexpath:(NSIndexPath *)path;
-(void)showAllDeleteBtn;
-(void)hideAllDeleteBtn;

@end

@interface MyCell : UICollectionViewCell

//病情label
@property(nonatomic,strong)UILabel * deseaseLabel;
//左上角删除按钮
@property(nonatomic,strong)UIButton * deleteBtn;

@property(nonatomic,strong)NSIndexPath * indexPath;
//代理
@property(nonatomic,assign)id<CellDelegate>delegate;

@end

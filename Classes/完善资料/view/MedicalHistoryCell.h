//
//  MedicalHistoryCell.h
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/8/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MedicalSkipVCBlock)(void);
//删除数组指定下标元素block
typedef void(^DeleteArrItemBlock)(NSString *);

@interface MedicalHistoryCell : UITableViewCell

@property(nonatomic,strong)UILabel * leftLabel;
@property(nonatomic,strong)UIImageView *addImageV;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSMutableArray * dataArr;
//是否显示左上角删除按钮
@property(nonatomic,assign)BOOL isShowDeleteBtn;

@property(nonatomic,copy)MedicalSkipVCBlock medicalSkipVCBlock;
@property(nonatomic,copy)DeleteArrItemBlock deleteArrItemBlock;

-(void)loadDiseaseArr:(NSArray *)arr;
//-(void)loadDiseaseArr:(NSArray *)arr with:(UITableView *)tableView;
-(void)hideDeleteBtn;


@end

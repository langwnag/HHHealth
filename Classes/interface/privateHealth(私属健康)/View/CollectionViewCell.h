//
//  CollectionViewCell.h
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface CollectionViewCell : UICollectionViewCell
//头像图片
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//消息角标
@property (weak, nonatomic) IBOutlet UIImageView *messageImageV;

- (void)loadDataWithModel:(CollectionModel* )model;


@end

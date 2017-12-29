//
//  HealthRecordsBtn.h
//  YiJiaYi
//
//  Created by mac on 2016/11/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HealthRecordsBtn;
//初始使用字符串
typedef void(^InitialStrBlock)(NSString *);

// 声明协议
@protocol HealthRecordsBtnDelegate <NSObject>
@optional
// 声明方法
- (void)HealthRecordsBtnDidClickedName:(NSString* )paramStr;

@end

@interface HealthRecordsBtn : UIScrollView
@property (nonatomic,weak) id<HealthRecordsBtnDelegate> Tagdelegate;

@property(nonatomic,assign)int selecteIndex;
@property(nonatomic,copy)InitialStrBlock initialStrBlock;

- (void)createAchivesUI;
@end

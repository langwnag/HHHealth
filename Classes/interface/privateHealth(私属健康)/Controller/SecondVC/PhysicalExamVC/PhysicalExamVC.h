//
//  PhysicalExamVC.h
//  YiJiaYi
//
//  Created by SZR on 2017/2/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseVC.h"
#import "ExamView.h"
#import "ExamComplete.h"
typedef NS_ENUM(NSInteger,ExamState){
    ExamState_NOCommitExam,//未提交体检预约
    ExamState_AlreadyCommitExam,//已提交体检预约 但未完成
    ExamState_ExamComplete,
};


@interface PhysicalExamVC : BaseVC

@property (nonatomic,strong) ExamView * examView;
@property (nonatomic,strong) ExamComplete * examCompleteView;

@property(nonatomic,assign)ExamState examState;

@end

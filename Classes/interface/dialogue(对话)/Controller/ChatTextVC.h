//
//  ChatTextVC.h
//  TextRongCloud_Demo
//
//  Created by 莱昂纳德 on 16/7/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RCConversationModel.h>
#import <RongCloudIMKit/RongIMKit/RCConversationViewController.h>
#import "DoctListModel.h"


@interface ChatTextVC : RCConversationViewController
{
    BOOL _needPopToRootView;
}

@property(nonatomic,strong)DoctListModel * doctorModel;

@end

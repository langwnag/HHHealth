//
//  ModifyName.h
//  客邦
//
//  Created by SZR on 16/4/8.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "BaseVC.h"
//返回昵称的block
typedef void(^ReturnTextBlock)(NSString *);

@interface ModifyName : BaseVC

@property(nonatomic,copy)ReturnTextBlock returnTextBlock;

-(instancetype)initWithNickName:(NSString *)nickName;


@end

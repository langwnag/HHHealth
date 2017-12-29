//
//  NewPassWordViewController.h
//  yingke
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@class login;
@interface ModifyPassWordVC :BaseVC
@property(nonatomic,strong)NSMutableDictionary* dict;
@property(nonatomic,copy) login *logininfo;

//从a传值到b  属性必须定义在.h文件中
@property(nonatomic,strong)NSString *userPhone;
@property(nonatomic,copy)NSString  *smsCode;
@end

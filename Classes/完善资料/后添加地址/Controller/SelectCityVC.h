//
//  SelectCityVC.h
//  Zhuan
//
//  Created by LA on 2017/10/31.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectAddressModel;
@interface SelectCityVC : UITableViewController
/** 传递 市model*/
@property (nonatomic, strong) SelectAddressModel* selectModel;
/** 传code */
@property (nonatomic, copy) NSString* codeStr;
@property (nonatomic,copy) NSString* cityStr;
@end

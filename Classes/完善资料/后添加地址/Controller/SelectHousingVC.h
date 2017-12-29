//
//  SelectHousingVC.h
//  Zhuan
//
//  Created by LA on 2017/10/31.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectAddressModel.h"

@interface SelectHousingVC : UITableViewController
/** 传递 区域model*/
@property (nonatomic, strong) CityModel* cityModel;
/** 传code */
@property (nonatomic, copy) NSString* areaCodeStr;
@property (nonatomic, copy) NSString* nameStr;

@end

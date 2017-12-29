//
//  SZRTableView.h
//  MicroNews
//
//  Created by MS on 15-12-15.
//  Copyright (c) 2015年 SZR. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 实现对tableview的封装
 */
@interface SZRTableView : UITableView
/**
 *  初始化tableview
 *
 *  @param frame      tabelView的frame
 *  @param style      tableView的样式 plain group
 *  @param controller 界面
 *
 *  @return tableView
 */
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(id<UITableViewDataSource,UITableViewDelegate>)controller;



@end

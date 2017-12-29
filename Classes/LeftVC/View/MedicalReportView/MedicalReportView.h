//
//  MedicalReportView.h
//  YiJiaYi
//
//  Created by mac on 2017/2/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalReportModel.h"

@protocol MedicalReportCellClickDelegate <NSObject>
- (void)MedicalReportCellClick:(MedicalReportModel* )medicalModel;
@end

@interface MedicalReportView : UIView
/** VC */
@property(nonatomic,strong)UIViewController * viewController;
@property (nonatomic,weak) id <MedicalReportCellClickDelegate>Tagdelegate;

- (void)createReportUI;


@end

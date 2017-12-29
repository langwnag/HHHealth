//
//  OverseasMedicalFooter.h
//  YiJiaYi
//
//  Created by mac on 2017/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ContactTFBlock)(NSString* ,NSString* );
@interface OverseasMedicalFooter : UIView
@property (weak, nonatomic) IBOutlet UITextField *contactNameTF;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTF;
@property(nonatomic,copy)ContactTFBlock contactTFBlock ;

@end

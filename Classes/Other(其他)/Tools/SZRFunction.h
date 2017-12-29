 //
//  SZRFunction.h
//  yingke
//
//  Created by SZR on 16/3/17.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^actionBlock) (NSInteger indexPath);

@interface SZRFunction : NSObject

@property(nonatomic,copy) actionBlock actionBlock;


/**
*  构建富文本
*
*  @param str    全部字符串
*  @param subStr 需修改颜色的子串
*  @param color  修改成的颜色
*  @param font   修改成的字体大小
*
*  @return 富文本字符串
*/
+(NSMutableAttributedString *)SZRCreateAttriStrWithStr:(NSString *)str
                                         withSubStr:(NSString *)subStr
                                          withColor:(UIColor *)color
                                           withFont:(UIFont *)font;
/**
 *  创建button
 *
 *  @param frame        位置大小
 *  @param title        标题
 *  @param imageStr     前景图片
 *  @param backImageStr 背景图片
 *
 *  @return button实例
 */
+(UIButton *)createButtonWithFrame:(CGRect)frame
                         withTitle:(NSString *)title
                      withImageStr:(NSString *)imageStr
                  withBackImageStr:(NSString *)backImageStr;

+(UIButton *)createBtn:(NSString *)btnTitle titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont;
/**
 *  创建label
 *
 *  @param frame Label大小
 *  @param color 字体颜色
 *  @param font  字体大小
 *
 *  @return UILabel对象
 */
+(UILabel *)createLabelWithFrame:(CGRect)frame
                           color:(UIColor *)color
                            font:(UIFont *)font
                            text:(NSString* )text;

+(UIView *)createView:(UIColor *)BGColor;



//根据十六进制转换成颜色 @"4db8b8"
+(UIColor *)SZRstringTOColor:(NSString *)str;
/**
 *  创建textField
 *
 *  @param frame       frame
 *  @param font        字体
 *  @param placeholder 占位符
 *
 *  @return UITextField实例
 */
+(UITextField *)VDCreateTextFieldFrame:(CGRect)frame color:(UIColor *)color   font:(UIFont *)font placeholder:(NSString *)placeholder;


/**
 *  创建UIAlertController弹窗
 *  @param title        标题
 *  @param extMessage   标题消息
 *  @param ButtonMessages 设置按钮的信息
 *  @param action      按钮的回调
 *  @param viewVC      控制器
 */
+ (void)createAlertViewTextTitle:(NSString *)title withTextMessage:(NSString *)message WithButtonMessages:(NSArray *)ButtonMessages Action:(actionBlock)actionBlock viewVC:(UIViewController *)viewVC style:(UIAlertControllerStyle)style;


/**
 *  根据颜色设置图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+(UIImage*) createImageWithColor:(UIColor*) color;

/**
 *  创建imageView
 *
 *  @param frame     frame
 *  @param imageName 图片名称
 *  @param color     背景颜色
 *
 *  @return UIImageView
 */
+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color;

/**
 *  创建阴影视图
 *
 *  @param block 点击阴影视图回调
 *
 *  @return 阴影视图
 */
+(UIView *)SZRCreateShadeView;
/**
 *  设置view的图层图片
 *
 *  @param view     view
 *  @param imageStr 图片名字
 */
+(void)SZRSetLayerImage:(UIView *)view imageStr:(NSString *)imageStr;


#pragma mark 时间戳

/**
 时间 ———> 时间戳
 */
+(long)SZR_timeStampWithTime:(NSString *)time;

/**
 *  返回 YYYY-MM-dd 时间样式
 *
 *  @param timeStamp 时间戳
 *
 *  @return YYYY-MM-dd 时间
 */
+(NSString *)VD_TimeFormat:(NSString *)timeStamp;


#pragma mark json 字典 互换
/**
 *  json转字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 *  字典转json
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

#pragma mark 随机生成固定位数的数
+(NSString *)randomKey;

#pragma mark 正则表达式
/**
 *  判断是否是手机号码
 *
 *  @param phoneNum 要检测的手机号码字符春
 *
 *  @return YES 是 NO 不是
 */
+(BOOL)VD_CheckPhoneNum:(NSString *)phoneNum;
//Mr.Li添加 - 2017-06-12
+ (NSString *)verifyPhoneNum:(NSString *)phoneNum;

/**
 *  判断验证码是否正确
 */
+(BOOL)VD_CheckVerifyCode:(NSString *)verifyCode;
//Mr.Li添加 - 2017-06-12
+ (NSString *)verifyCode:(NSString *)verifyCode;

/**
 *  判断密码是否至少6位
 */
+(BOOL)VD_CheckPassword:(NSString *)password;
/**
 *  判断昵称是否正确
 *  中英文，数字，下划线，不能全数字
 */
+(BOOL)VD_CheckNickName:(NSString *)nickName;
/*
 *  判断邮箱是否正确
 */
+(BOOL)VD_CheckEmail:(NSString *)email;

/*
 *  判断QQ号码是否正确
 */
+(BOOL)VD_CheckQQNum:(NSString *)QQNum;
+(BOOL)HH_CheckNoNegativeNum:(NSString *)numStr;

/*
 *  正则匹配用户身份证号15或18位
 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;

+(NSString *)idWithRCID:(NSString *)RCID;

+(NSString *)doctorRCIDWithID:(NSString *)doctorID;

@end

//
//  SZRFunction.m
//  yingke
//
//  Created by SZR on 16/3/17.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "SZRFunction.h"
#define iOS8 [[UIDevice currentDevice].systemVersion doubleValue] >= 8.0
@interface SZRFunction()<UIAlertViewDelegate>

@end
@implementation SZRFunction


//构建富文本
+(NSMutableAttributedString *)SZRCreateAttriStrWithStr:(NSString *)str
                                            withSubStr:(NSString *)subStr
                                             withColor:(UIColor *)color
                                              withFont:(UIFont *)font{
    NSRange range = [str rangeOfString:subStr];
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc]initWithString:str];
    if (color) {
        [attriStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    if (font) {
        [attriStr addAttribute:NSFontAttributeName value:font range:range];
    }
    return attriStr;
}

+(UIView *)createView:(UIColor *)BGColor{
    UIView * view = [UIView new];
    view.backgroundColor = BGColor;
    return view;
}

//创建button
+(UIButton *)createButtonWithFrame:(CGRect)frame
                         withTitle:(NSString *)title
                      withImageStr:(NSString *)imageStr
                  withBackImageStr:(NSString *)backImageStr{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (!CGRectIsNull(frame)) {
       btn.frame = frame;
    }
    [btn setTitle:title forState:UIControlStateNormal];
    if (imageStr != nil) {
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];

    }
    if (backImageStr !=nil) {
        [btn setBackgroundImage:[UIImage imageNamed:backImageStr] forState:UIControlStateNormal];
    }
    
    return btn;
}

+(UIButton *)createBtn:(NSString *)btnTitle titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont{
    UIButton * btn = [UIButton new];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont;
    return btn;
}

//创建label
+(UILabel *)createLabelWithFrame:(CGRect)frame color:(UIColor *)color font:(UIFont *)font text:(NSString* )text{
    UILabel * label = [[UILabel alloc]init];
    if (!CGRectIsNull(frame)) {
        label.frame = frame;
    }
    label.textColor = color;
    label.font = font;
    label.text = text;
    return label;
}

//文本框大小及占位符
+(UITextField *)VDCreateTextFieldFrame:(CGRect)frame color:(UIColor *)color   font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]init];
    textField.font=font;
    
    if (!CGRectIsNull(frame)) {
        textField.frame = frame;
    }

    if (color) {
        textField.textColor = color;
    }

    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;

    return textField;
}

// UIAlertController的封装方法
+ (void)createAlertViewTextTitle:(NSString *)title withTextMessage:(NSString *)message WithButtonMessages:(NSArray *)ButtonMessages Action:(actionBlock)actionBlock viewVC:(UIViewController *)viewVC style:(UIAlertControllerStyle)style
{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    int indexPath = 0;
    for (NSString* VDStr in ButtonMessages) {
        
        if ([VDStr isEqualToString:@"删除"]) {
            [alertVC addAction:[UIAlertAction actionWithTitle:VDStr style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
                if (actionBlock) {
                    actionBlock(indexPath);
                }
            }]];
        }else if ([VDStr isEqualToString:@"取消"]) {
            [alertVC addAction:[UIAlertAction actionWithTitle:VDStr style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
                if (actionBlock) {
                    actionBlock(indexPath);
                }
            }]];
        }else{
            [alertVC addAction:[UIAlertAction actionWithTitle:VDStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (actionBlock) {
                    actionBlock(indexPath);
                }
            }]];
        }
        
        indexPath ++;
    }
    [viewVC presentViewController:alertVC animated:YES completion:nil];
}


+(void)SZRSetLayerImage:(UIView *)view imageStr:(NSString *)imageStr{
    UIImage* image = [UIImage imageNamed:imageStr];
    view.layer.contents = (id)image.CGImage;
}

+(UIColor *)SZRstringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}
//根据颜色设置图片
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//文本框中图片大小 名称 颜色
+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]init];
    
    if (!CGRectIsNull(frame)) {
        imageView.frame = frame;
    }
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

//创建阴影视图
+(UIView *)SZRCreateShadeView{
    
    UIView * shadeView = [[UIView alloc]initWithFrame:SZRScreenBounds];
    shadeView.backgroundColor = [UIColor blackColor];
    shadeView.alpha = 0.4;
    return shadeView;
}

+(long)SZR_timeStampWithTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:time];
    //----------nsdate按formatter格式转成nsstring
    return (long)[date timeIntervalSince1970];
}

//返回 YYYY-MM-dd 样式时间
+(NSString *)VD_TimeFormat:(NSString *)timeStamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    double b =[timeStamp doubleValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:b/1000];
    return [formatter stringFromDate:confromTimesp];
    
}


//随机生成固定位数的数
+(NSString *)randomKey{
    NSString *alphabet = @"1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];

    
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform((float)numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    NSString *result = [NSString stringWithCharacters:characters length:24];
    free(characters);
    return result;
}


#pragma mark  字典 json数据互转
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+(BOOL)VD_CheckPhoneNum:(NSString *)phoneNum{
    NSString * pattern = @"^(1[3,4,5,7,8]\\d{9})$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:phoneNum];
}
//Mr.Li添加 - 2017-06-12
+ (NSString *)verifyPhoneNum:(NSString *)phoneNum{
    if (phoneNum.length == 0) {
        return @"请输入手机号码";
    }else if(phoneNum.length != 11){
        return @"请输入11位手机号码";
    }else if(![self VD_CheckPhoneNum:phoneNum]){
        return @"您的号码有误，请重新输入";
    }
    return @"YES";
}

+(BOOL)VD_CheckVerifyCode:(NSString *)verifyCode{
    NSString * pattern = @"^\\d{4,6}$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:verifyCode];
}
//Mr.Li添加 - 2017-06-12
+ (NSString *)verifyCode:(NSString *)verifyCode{
    if (verifyCode.length == 0) {
        return @"请输入验证码";
    }else if(verifyCode.length != 6){
        return @"请输入6位验证码";
    }
    return @"YES";
}
//判断密码是否至少6位
+(BOOL)VD_CheckPassword:(NSString *)password{
    NSString * pattern = @"^[0-9_a-zA-Z]{6,18}$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:password];
}
//判断昵称
+(BOOL)VD_CheckNickName:(NSString *)nickName{
    NSString * pattern = @"^[a-zA-Z\\d\\_\u2E80-\u9FFF]{2,16}$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:nickName];
}
//判断QQ号码是否正确
+(BOOL)VD_CheckQQNum:(NSString *)QQNum{
    NSString * pattern = @"^[1-9][0-9]{4,9}$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:QQNum];
}
//邮箱正则表达式
+(BOOL)VD_CheckEmail:(NSString *)email{
    
    NSString * pattern = @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:email];
}
//非负实数正则表达式
//"^([0-9])+(\.[0-9]+)?$"
+(BOOL)HH_CheckNoNegativeNum:(NSString *)numStr{
    NSString * pattern = @"^([0-9])+(\\.[0-9]+)?$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:numStr];
}

//正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}


+(NSString *)idWithRCID:(NSString *)RCID{
    NSRange range = [RCID rangeOfString:@"_" options:NSBackwardsSearch];
    return [RCID substringFromIndex:range.location+1];
}

+(NSString *)doctorRCIDWithID:(NSString *)doctorID{
    return [NSString stringWithFormat:@"DOCTOR_RONGCLOUD_ID_%@",doctorID];
}

@end

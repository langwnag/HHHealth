//
//  Other.h
//  YiJiaYi
//
//  Created by SZR on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#ifndef Other_h
#define Other_h

// 送礼物用到的
#define LY_EaseMob_MSG_TYPE_GIFT         @"gift"            // 礼物

#define LY_avatar   @"avatar"
#define LY_nickName @"nickName"
#define LY_content  @"content"
#define LY_giftType @"giftType"
#define LY_level    @"level"
#define LY_userId   @"userId"
#define LY_dataType @"dataType"
#define LY_onlineCount @"onlineCount"
#define LY_coinCount @"coinCount"

// 用户的信息
#define USER_avatar @"default_head"
#define USER_nickName @"Louisly" // [GVUserDefaults standardUserDefaults].nickname
#define USER_userId @"12345" // [GVUserDefaults standardUserDefaults].userid
#define USER_level @"43" // [GVUserDefaults standardUserDefaults].level




#pragma mark - The global type and constant
static NSString *PYAuto = @"auto";
static NSString *PYNone = @"none";

typedef NSString *PYInterval;
static PYInterval PYIntervalAuto = @"auto";
static PYInterval PYIntervalAll  = @"all";

typedef NSString *PYSymbol;
static PYSymbol PYSymbolNone           = @"none";
static PYSymbol PYSymbolCircle         = @"circle";
static PYSymbol PYSymbolRectangle      = @"rectangle";
static PYSymbol PYSymbolTriangle       = @"triangle";
static PYSymbol PYSymbolDiamond        = @"diamond";
static PYSymbol PYSymbolEmptyCircle    = @"emptyCircle";
static PYSymbol PYSymbolEmptyRectangle = @"emptyRectangle";
static PYSymbol PYSymbolEmptyTriangle  = @"emptyTriangle";
static PYSymbol PYSymbolEmptyDiamond   = @"emptyDiamond";
static PYSymbol PYSymbolHeart          = @"heart";
static PYSymbol PYSymbolDroplet        = @"droplet";
static PYSymbol PYSymbolPin            = @"pin";
static PYSymbol PYSymbolArrow          = @"arrow";
static PYSymbol PYSymbolStar5          = @"star5";

typedef NSString *PYSort;
static PYSort PYSortNone       = @"none";
static PYSort PYSortAscending  = @"ascending";
static PYSort PYSortDescending = @"descending";

typedef NSString *PYPosition;
static PYPosition PYPositionLeft   = @"left";
static PYPosition PYPositionRight  = @"right";
static PYPosition PYPositionCenter = @"center";
static PYPosition PYPositionTop    = @"top";
static PYPosition PYPositionBottom = @"bottom";

typedef NSString *PYOrient;
static PYOrient PYOrientHorizontal = @"horizontal";
static PYOrient PYOrientVertical   = @"vertical";

//#define __DEBUG__ 1
#ifdef __DEBUG__
#define PYLog(...) NSLog(__VA_ARGS__)
#else
#define PYLog(...) do{} while(0)
#endif


#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define PY_WEB_VIEW UIWebView
#define PY_WEB_DELEGATE UIWebViewDelegate
#define PY_COLOR UIColor
#define PY_IMAGE UIImage
#define PY_EDGE_INSET UIEdgeInsets
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#define PY_WEB_VIEW WebView
#define PY_WEB_DELEGATE WebFrameLoadDelegate
#define PY_COLOR NSColor
#define PY_IMAGE NSImage
#define PY_EDGE_INSET NSEdgeInsets
#endif


#pragma mark - The template marco

/**
 *  The template of the add methods.
 *  Which can help user to add datas into the Array,
 *  Eg: the xAxis in `PYOptions`
 *  This can create a method named 'addXAxis'
 */
#define PYAddMethodTemplate(cls, type, mName, pName)                            \
- (cls *(^)(type *pName))add##mName;                                        \
- (cls *(^)(NSArray *arr))add##mName##Arr;                                  \

/**
 *  the template of implemetion of add methods.
 */
#define PYAddMethodImpTemplate(cls, type, mName, pName)                         \
- (cls *(^)(type *pName))add##mName {                                       \
if(_##pName == nil) {                                                   \
_##pName = [[NSMutableArray alloc] init];                           \
}                                                                       \
return ^id(type *val) {                                                 \
[_##pName addObject:val];                                           \
return self;                                                        \
};                                                                      \
}                                                                           \
- (cls *(^)(NSArray *arr))add##mName##Arr {                                 \
if(_##pName == nil) {                                                   \
_##pName = [[NSMutableArray alloc] init];                           \
}                                                                       \
return ^id(NSArray *arr) {                                              \
[_##pName addObjectsFromArray:arr];                                 \
return self;                                                        \
};                                                                      \
}

/*
 if (_##pName != nil                                                     \
 && ![_##pName isMemberOfClass:[NSArray class]]) {            \
 NSLog(@"ERROR:##pName## is not the type named 'NSMutableArray'");   \
 return nil;                                                         \
 }                                                                       \
 */

/**
 *  The template of custom initializer.
 *  We can use this initializer to create the object,
 *  then use the block to update the property of the object.
 */
#define PYInitializerTemplate(cls, name)                                        \
+ (cls *)init##cls##WithBlock:(void(^)(cls * name))block;

/**
 *  The implemention of the custom initializer(above).
 */
#define PYInitializerImpTemplate(cls)                                           \
+ (cls *)init##cls##WithBlock:(void(^)(cls *))block {                       \
cls *tmp = [[self alloc] init];                                         \
block(tmp);                                                             \
return tmp;                                                             \
}

/**
 *  The template of the interface which is property custom setter.
 *  You can use this interface to set value for special property.
 *
 *  @param cls  The property is in this class
 *  @param type The property's type
 *  @param name The name of parameter which the property in the object.
 */
#define PYPropertyEqualTemplate(cls, type, name)                                \
- (cls * (^) (type name)) name##Equal;                                      \


/**
 *  The default implementation for the special the interface(above).
 *  You can use this default in the object.
 *
 *  @param cls  The property is in this class
 *  @param type The property's type
 *  @param name The name of parameter which the property in the object.
 */
#define PYPropertyEqualImpTemplate(cls, type, name)                             \
- (cls * (^) (type name))name##Equal{                                       \
return ^(type name) {                                                   \
self.name         = name;                                           \
return self;                                                        \
};                                                                      \
}                                                                           \



#endif /* Other_h */

//
//  GlobalInfo.h
//  Created by 莱昂纳德 on 2017/1/23.
//  Copyright © 2017年 All rights reserved.
//
//GlobalInfo   1.全局 持久化
//             2.全局通用常用 变量
//             3.单例

#import "GlobalInfo.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface GlobalInfo()
@end

@implementation GlobalInfo
static GlobalInfo *shareGlobalInfo = nil;

+ (instancetype)getInstance
{
    if(shareGlobalInfo == nil)
    {
        shareGlobalInfo = [[GlobalInfo alloc]init];
    }
    return shareGlobalInfo;
}
-(void)initialPersistedModelsInBackGround{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initialPersistedModels];
    });
}

-(void)persistModelsInBackGround{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self persistModels];
    });
    
}
-(void)initialPersistedModels{
    
    //把本地所有需要读取的 复用率高 且 全局通用的 读出来
   
    unsigned int modelCount, i;
    
    objc_property_t* models = class_copyPropertyList([self class], &modelCount);
    for (i = 0; i < modelCount; i++) {
    
        objc_property_t model = *(models+i);
        const char *modelName = property_getName(model);
        
        NSString *modelNameStr=    [NSString stringWithUTF8String:modelName];
        
        NSString * firstLetter=     [modelNameStr substringToIndex:1];
        NSRange rang=NSMakeRange(0,1);
        NSString  *UpperModelNameStr= [modelNameStr stringByReplacingCharactersInRange:rang withString:[firstLetter uppercaseString]];
        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",UpperModelNameStr]];
        SEL setSel = NSSelectorFromString([NSString stringWithFormat:@"set%@:",UpperModelNameStr]);
        
        if ([self respondsToSelector:setSel]) {
            
            id object=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
            if (object) {
                [self performSelector:setSel
                           withObject:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];
            }else{
              
                //如果没有持久化过 就直接给他一个空实例
                NSString *propType = [self getPropertyType:model];
                NSString *type = [NSString stringWithString:propType];
                if ([type isEqualToString:@"NSMutableArray"]) {
                   
//                    [self performSelector:setSel
//                               withObject: obj];
                    [self setValue:[NSMutableArray arrayWithCapacity:10] forKey:UpperModelNameStr];
                }else if([type isEqualToString:@"NSMutableDictionary"]){
                    [self setValue:[NSMutableDictionary dictionaryWithCapacity:10] forKey:UpperModelNameStr];
                }else{
                    
                      Class someClass = NSClassFromString(UpperModelNameStr);
                    if (someClass) {
                        id obj = [[someClass alloc] init];
                        
                        [self setValue:obj forKey:UpperModelNameStr];
                    
                    }else{
                        //如果还是没有
                        SZRLog(@"不支持该类型实例化");
                    }
                }
               }
            }
        }
    }
    
                
                
// objc_msgSend(self, setSel, [NSKeyedUnarchiver unarchiveObjectWithFile:path]);


// 全局只有唯一 一个
-(void)persistModel:(id )model{
    // 归档,存入本地
    NSString *className=    NSStringFromClass([model class]);
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",className]];
    [NSKeyedArchiver archiveRootObject:model toFile:path];
}

// 这里是持久化全部MODEL
-(void)persistModels{
    unsigned int modelCount, i;
    objc_property_t* models = class_copyPropertyList([self class], &modelCount);
    for (i = 0; i < modelCount; i++) {
        objc_property_t model = *(models+i);
        const char *modelName = property_getName(model);
        
        NSString *modelNameStr=    [NSString stringWithUTF8String:modelName];
        
        NSString * firstLetter=     [modelNameStr substringToIndex:1];
        NSRange rang=NSMakeRange(0,1);
        NSString  *UpperModelNameStr=      [modelNameStr stringByReplacingCharactersInRange:rang withString:[firstLetter uppercaseString]];
        
        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",UpperModelNameStr]];
        [NSKeyedArchiver archiveRootObject:[self valueForKey:modelNameStr]    toFile:path];
    }
}

-(NSString *)getPropertyType:(objc_property_t)property
{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    
    strcpy(buffer, attributes);
    
    char *state = buffer, *attribute;
    
    while ((attribute = strsep(&state, ",")) != NULL) {
        
        if (attribute[0] == 'T') {
            if(attribute[1] == '@') {
                NSString *typeStr=[[NSString alloc] initWithCString:(attribute+3) encoding:NSUTF8StringEncoding];
                return [typeStr substringToIndex:typeStr.length-1];
            } else {
                NSString *typeStr=[[NSString alloc] initWithCString:(attribute+1) encoding:NSUTF8StringEncoding];
                return [typeStr substringToIndex:typeStr.length-1];
            }
        }
    }
    return @"";
}



@end

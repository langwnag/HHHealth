//
//  HHDataBase.m
//  YiJiaYi
//
//  Created by mac on 2017/1/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHDataBase.h"
#import "FMDatabase.h"
#import "CollectionModel.h"
@implementation HHDataBase
static FMDatabase * _db;

+ (void)initialize{
// 拼接路径
    NSString* Path = [NSString stringWithFormat:@"%@/Library/Caches/Data.db",NSHomeDirectory()];
    _db = [FMDatabase databaseWithPath:Path];
    [_db open];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_item (id integer PRIMARY KEY, itemDict blob NOT NULL, idStr text NOT NULL)"];
}

+ (void)saveItemDict:(NSDictionary *)itemDict {
    
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:itemDict];
    
    [_db executeUpdateWithFormat:@"INSERT INTO t_item (itemDict, idStr) VALUES (%@, %@)",dictData, itemDict[@"id"]];
    
}

+ (NSArray *)list {
    
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_item"];
    NSMutableArray *list = [NSMutableArray array];
    
    while (set.next) {
        // 获得当前所指向的数据
        // 转化为二进制
        NSData *dictData = [set objectForColumnName:@"itemDict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
        CollectionModel* como = [[CollectionModel alloc] init];
        [como setValuesForKeysWithDictionary:dict];
        [list addObject:como];
//        [list addObject:[CollectionModel mj_objectWithKeyValues:dict]];
        
    }
    return list;
}

+ (NSArray *)listWithRange:(NSRange)range {
    
    NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM t_item LIMIT %lu, %lu",range.location, range.length];
    FMResultSet *set = [_db executeQuery:SQL];
    NSMutableArray *list = [NSMutableArray array];
    
    while (set.next) {
        // 获得当前所指向的数据
        
//        NSData *dictData = [set objectForColumnName:@"itemDict"];
//        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
//        [list addObject:[Item mj_objectWithKeyValues:dict]];
    }
    return list;
}

+ (BOOL)isExistWithId:(NSString *)idStr
{
    BOOL isExist = NO;
    
    FMResultSet *resultSet= [_db executeQuery:@"SELECT * FROM t_item where idStr = ?",idStr];
    while ([resultSet next]) {
        if([resultSet stringForColumn:@"idStr"]) {
            isExist = YES;
        }else{
            isExist = NO;
        }
    }
    return isExist;
}




@end

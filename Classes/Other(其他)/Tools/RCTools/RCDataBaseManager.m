//
//  RCDataBaseManager.m
//  HeheHealthManager
//
//  Created by SZR on 2017/3/17.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "RCDataBaseManager.h"

#import <FMDB/FMDB.h>


@interface RCDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSString* code;
@property (nonatomic,strong) NSString* state;

@end

@implementation RCDataBaseManager

static NSString *const userTableName = @"USERTABLE";
static NSString *const signTableName = @"SIGNTABLE";

+(RCDataBaseManager *)shareInstance{
    static RCDataBaseManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RCDataBaseManager alloc]init];
        [instance dbQueue];
    });
    return instance;
}


- (FMDatabaseQueue *)dbQueue {
    if ([RCIMClient sharedRCIMClient].currentUserInfo.userId == nil) {
        return nil;
    }
    if (!_dbQueue) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory
                            stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"HHClientRCInfo%@",
                             [RCIMClient sharedRCIMClient]
                             .currentUserInfo.userId]];
        
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        if (_dbQueue) {
            [self createUserTableIfNeed];
        }
    }
    return _dbQueue;
}

-(void)createUserTableIfNeed{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if (![self isTableOK:userTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE USERTABLE (id integer PRIMARY "
            @"KEY autoincrement, userid text,name text, "
            @"portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL =
            @"CREATE unique INDEX idx_userid ON USERTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        // 创建签约医生表

        if (![self isTableOK:signTableName withDB:db]) {
            NSString *createSignSql = @"CREATE TABLE SIGNTABLE (id integer PRIMARY "
            @"KEY autoincrement, doctorId text,code text,state text)";
            [db executeUpdate:createSignSql];
            NSString* createIndexSql = @"CREATE unique INDEX idx_blackId ON " @"SIGNTABLE(doctorId,code,state);";
            [db executeUpdate:createIndexSql];
        }
    }];
}

- (void)closeDBForDisconnect {
    self.dbQueue = nil;
}

//存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user {
    NSString *insertSql =
    @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql, user.userId, user.name, user.portraitUri];
    }];
}
// 储存签约状态
- (void)insertUserToDBDoctorId:(NSString *)doctorId code:(NSString* )code {
    //插入的sql语句
    NSString *insertSignSql = @"REPLACE INTO SIGNTABLE (doctorId,code) VALUES (?,?)";

    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSignSql,doctorId,code];
    }];
}



//从表中获取用户信息
- (RCUserInfo *)getUserByUserId:(NSString *)userId {
    __block RCUserInfo *model = nil;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs =
        [db executeQuery:@"SELECT * FROM USERTABLE where userid = ?", userId];
        while ([rs next]) {
            model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
        }
        [rs close];
    }];
    return model;
}
// 查询医生签约状态
- (NSString* )querySignDoctorStates:(NSString *)doctorId  {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *selectSignSql = @"SELECT * FROM SIGNTABLE where doctorId = ？";
        //执行查询sql
        FMResultSet *set = [db executeQuery:selectSignSql,doctorId];
        while ([set next]) {
            //遍历查询结果
          _code= [set stringForColumn:@"code"];
        }
        [set close];
    }];
   
    return _code;
}



- (BOOL)isTableOK:(NSString *)tableName withDB:(FMDatabase *)db {
    BOOL isOK = NO;
    
    FMResultSet *rs =
    [db executeQuery:@"select count(*) as 'count' from sqlite_master where "
     @"type ='table' and name = ?",
     tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count) {
            isOK = NO;
        } else {
            isOK = YES;
        }
    }
    [rs close];
    
    return isOK;
}




@end

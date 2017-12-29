//
//  GlobalInfo.h
//  Created by 莱昂纳德 on 2017/1/23.
//  Copyright © 2017年 All rights reserved.
//

//GlobalInfo   1.全局 持久化
//             2.全局通用常用 变量
//             3.单例

#import "CollectionModel.h"
#import "HHMomentModel.h"
@interface GlobalInfo : NSObject

//============如果需要 持久化 请在这里声明  ============
@property (nonatomic,strong) CollectionModel* collectionModel;



+(GlobalInfo *)getInstance;
//初始化 所有已经被持久化的实例
-(void)initialPersistedModels;

//持久化实例
-(void)persistModel:(id )model;

-(void)persistModels;

-(void)persistModelsInBackGround;

-(void)initialPersistedModelsInBackGround;


@end

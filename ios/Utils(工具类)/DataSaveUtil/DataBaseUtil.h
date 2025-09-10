//
//  DataBaseUtil.h
//  wsm
//
//  Created by chenxing on 12-12-30.
//  Copyright (c) 2012年 chenxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DataBaseUtil : NSObject
{
    FMDatabase *mDb;
}
@property (nonatomic,retain) FMDatabase *mDb;
+(DataBaseUtil *)instance;
-(BOOL)createTabaleWidthClass:(Class) tempClass;
-(BOOL)addClassWidthObj:(id) obj;
-(BOOL)updateClassWidthObj:(id) obj searchKey:(NSString *)searchKey searchValue:(NSString *)searchValue;
-(NSMutableArray *)findAllObjsByClass:(Class)tempClass;
-(id)findObjBySearchKey:(NSString *) searchKey searchValue:(NSString *)searchValue class:(Class)tempClass;
-(BOOL)deleteObjWithClass:(Class)tempClass searchKey:(NSString *) searchKey searchValue:(NSString *)searchValue;
-(BOOL)createTabaleWidthClassArray:(NSMutableArray *) tempClassArray;

-(BOOL)updateTableWidthDictionary:(NSMutableDictionary *)dic searchKey:(NSString *)searchKey searchValue:(NSString *)searchValue tableClass:(Class) tempClass;
-(BOOL)deleteObjWithClass:(Class)tempClass;
-(BOOL)deleteObjWithClass:(Class)tempClass limit:(NSString *)limit;

-(NSMutableArray *)findManyObjsByClass:(Class)tempClass limit:(NSString *)limit;

- (int) countItemByClass:(Class)tempClass limit:(NSString *)limit;
-(BOOL)addManyClassWidthObj:(NSArray *) array;

-(BOOL)resetClassWidthObj:(id) obj searchKey:(NSString *)searchKey searchValue:(NSString *)searchValue;
-(void)closeDataBase;
-(void)openDataBase;
-(BOOL)updateObjsByClass:(Class)tempClass limit:(NSString *)limit dictionary:(NSMutableDictionary *)dic;
- (int) countItemByClass:(Class)tempClass count:(NSString *)count limit:(NSString *)limit;

//创建和更新表
-(void)createAndUpdateAllTable;
@end

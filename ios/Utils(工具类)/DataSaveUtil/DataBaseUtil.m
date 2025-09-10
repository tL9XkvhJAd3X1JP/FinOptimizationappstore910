//
//  DataBaseUtil.m
//  wsm
//
//  Created by chenxing on 12-12-30.
//  Copyright (c) 2012年 chenxing. All rights reserved.
//

#import "DataBaseUtil.h"
#import <objc/runtime.h>
#import <objc/objc.h>
//#import "NomalUtil.h"
//类中有objId，取的是主健。xx_则不加字段
//static DataBaseUtil * sharedInstance = nil;
@implementation DataBaseUtil
@synthesize mDb;
-(void)dealloc
{
//    [mDb release];
//    [super dealloc];
}
-(NSString *)getDocumentsDirectory
{
    //存储中经常需要提取两个相关的目录路径：Documents和tmp
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
- (id)init
{
    if (self = [super init])
    {
        
        //创建数据库
        NSString *documentDirectory = [self getDocumentsDirectory];
        //dbPath： 数据库路径，在Document中。
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"dataDBReader.db"];
        //创建数据库实例 db
        self.mDb = [FMDatabase databaseWithPath:dbPath] ;
    }
    return self;
}

+(DataBaseUtil *)instance
{
//    @synchronized(self) {
//        if (sharedInstance == nil)
//        {
//            sharedInstance = [[self alloc] init];
//        }
//        if (sharedInstance.mDb != nil)
//        {
//            if (![sharedInstance.mDb open])
//            {
//                NSLog(@"not open database");
//            }
//        }
//
//        return sharedInstance;
//    }
    
    static DataBaseUtil *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        });
    if (sharedInstance.mDb != nil)
    {
        if (![sharedInstance.mDb open])
        {
            NSLog(@"not open database");
        }
    }

    return sharedInstance;
    
}
//唯一一次alloc单例，之后均返回nil
//+ (id)allocWithZone:(NSZone *)zone
//{
//    @synchronized(self) {
//        if (sharedInstance == nil) {
//            sharedInstance = [super allocWithZone:zone];
//            return sharedInstance;
//        }
//    }
//}

//copy返回单例本身
//- (id)copyWithZone:(NSZone *)zone
//{
//    return self;
//}
#pragma mark 反射
//iOS运行时判断某个类有那些成员变量,包含你类的成员变量
-(NSMutableDictionary *) getDicFromModelClass:(id) classInstance
{
    //     id LenderClass =objc_getClass("ClassName");
    //这里是遍历当前类的所有成员变量
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:1];
    
    Class clazz = [classInstance class];
    //进入父类遍历成员变量，终止时判断
    while(clazz != [NSObject class])
    {
        u_int count;
        
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        
        for (int i = 0; i < count ; i++)
            
        {
            objc_property_t prop=properties[i];
            
            const char* propertyName = property_getName(prop);
            
            //            const char* attributeName = property_getAttributes(prop);
            
            //        NSLog(@"%@",[NSString stringWithUTF8String:propertyName]);
            //可以找到变量数据类型
            //            NSLog(@"%@",[NSString stringWithUTF8String:attributeName]);
            //T@"NSString",&,N,Vflag
            //Tf,N,V_height_
            id value =  [classInstance performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
            //过滤不存储数据库的字段
            if (![[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding] hasSuffix:@"_"])
            {
                if(value == nil || (NSNull *)value == [NSNull null])
                {
                    [valueArray addObject:[NSNull null]];
                }
                else
                {
                    [valueArray addObject:value];
                    
                }
                [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
            }
            
            //        NSLog(@"%@",value);
        }
        
        free(properties);
        clazz = class_getSuperclass(clazz);
    }
    
    NSMutableDictionary* returnDic = [NSMutableDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    
    //    NSLog(@"%@", returnDic);
    
    return returnDic;
}
-(BOOL)createTabaleWidthClassArray:(NSMutableArray *) tempClassArray
{
    @synchronized (self)
    {
        NSMutableArray *sqlArray = [NSMutableArray arrayWithCapacity:[tempClassArray count]];
        NSMutableArray *arrayObject = [NSMutableArray arrayWithCapacity:5];
        for (Class tempClass in tempClassArray)
        {
            id obj = class_createInstance(tempClass, 0);
            NSString *tableName = [self getTableName:tempClass];
            //    id obj = objc_getClass([tableName UTF8String]);
            NSMutableDictionary *dic = [self getDicFromModelClass:obj];
            
            NSArray *keys = [dic allKeys];
            NSString *keyName = @"";
            int num = 0;
            for (NSString *key in keys)
            {
                num ++;
                if (num == [keys count])
                {
                    keyName = [keyName stringByAppendingFormat:@"%@ varchar",key];
                }
                else
                {
                    keyName = [keyName stringByAppendingFormat:@"%@ varchar, ",key];
                }
                
                
            }
            
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ( _id integer primary key autoincrement, %@)", tableName,keyName];
            [sqlArray addObject:sql];
            [arrayObject addObject:tempClass];
        }
        
        BOOL isok = YES;
        for (int i = 0; i< [sqlArray count]; i++)
        {
            NSString *tempSql = [sqlArray objectAtIndex:i];
            isok = [mDb executeUpdate:tempSql];
            if (!isok)
            {
                NSLog(@"error");
                continue;
            }
            else
            {
                [self addColumn:[arrayObject objectAtIndex:i]];
            }
            
        }
        
        //增加列
        //         NSString *add = [NSString stringWithFormat:@"alter table %@ add aaaaa varchar",tableName];
        //        [mDb executeUpdate:add];
        //[mDb close];
        
        return YES;
    }
    
}
-(BOOL)createTabaleWidthClass:(Class) tempClass
{
    @synchronized (self)
    {
        id obj = class_createInstance(tempClass, 0);
        NSString *tableName = [self getTableName:tempClass];
        //    id obj = objc_getClass([tableName UTF8String]);
        NSMutableDictionary *dic = [self getDicFromModelClass:obj];
        
        NSArray *keys = [dic allKeys];
        NSString *keyName = @"";
        int num = 0;
        for (NSString *key in keys)
        {
            num ++;
            if (num == [keys count])
            {
                keyName = [keyName stringByAppendingFormat:@"%@ varchar",key];
            }
            else
            {
                keyName = [keyName stringByAppendingFormat:@"%@ varchar, ",key];
            }
            
            
        }
        
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ( _id integer primary key autoincrement, %@)", tableName,keyName];
        NSLog(@"%@",sql);
        //    return [db executeUpdate:sql];
        
        
        BOOL isok = [mDb executeUpdate:sql];
        //增加列
        //         NSString *add = [NSString stringWithFormat:@"alter table %@ add aaaaa varchar",tableName];
        //        [mDb executeUpdate:add];
        
        if (!isok)
        {
            NSLog(@"error");
            return NO;
        }
        else
        {
            NSLog(@"ok");
            //            select columns from table_name where expression
            //            NSLog(@"======%d",[s columnCount]);
            [self addColumn:tempClass];
        }
        //[mDb close];
        
        return YES;
    }
    
}
//数据库已经打开
-(void)addColumn:(Class) tempClass
{
    @synchronized (self)
    {
        id obj = class_createInstance(tempClass, 0);
        NSString *tableName = [self getTableName:tempClass];
        FMResultSet *s = [mDb executeQuery:[NSString stringWithFormat:@"select * from %@ limit 1",tableName]];
        if (s!= nil)
        {
            NSMutableDictionary *dic = [self getDicFromModelClass:obj];
            NSArray *keys = [dic allKeys];
            if (keys != nil)
            {
                for (NSString *keyName in keys)
                {
                    
                    if ([s columnIndexForName:keyName] == -1)
                    {
                        NSString *add = [NSString stringWithFormat:@"alter table %@ add %@ varchar",tableName,keyName];
                        NSLog(@"++%@",add);
                        [mDb executeUpdate:add];
                    }
                }
            }
            
        }
    }
    
}

-(BOOL)addClassWidthObj:(id) obj
{
    @synchronized (self)
    {
        if(obj == nil)
        {
            return NO;
        }
            
        NSString *tableName = [self getTableName:obj];
        NSMutableDictionary *dic = [self getDicFromModelClass:obj];
        
        NSArray *keys = [dic allKeys];
        //    NSString *value = nil;
        NSString *keyName = @"";
        NSString *keyValue = @"";
        int num = 0;
        
        for (NSString *key in keys)
        {
            //        value = [dic objectForKey:key];
            num ++;
            if (num == [keys count])
            {
                keyName = [keyName stringByAppendingFormat:@"%@) ",key];
                //            keyValue = [keyValue stringByAppendingFormat:@"'%@'); ",value];
                keyValue = [keyValue stringByAppendingFormat:@"?)"];
            }
            else
            {
                keyName = [keyName stringByAppendingFormat:@"%@, ",key];
                //            keyValue = [keyValue stringByAppendingFormat:@"'%@', ",value];
                keyValue = [keyValue stringByAppendingFormat:@"?,"];
            }
            
        }
        //UPDATE SUser SET name = 'Aa', description = 'mmm' WHERE uid = '2'
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@ VALUES (%@",tableName,keyName,keyValue];
        
        NSLog(@"%@", sql);
        
        BOOL isok = [mDb executeUpdate:sql withArgumentsInArray:[dic allValues]];
        //        [mDb executeUpdate:￼ withParameterDictionary:￼]
        //[mDb close];
        if (!isok)
        {
            NSLog(@"error");
            return NO;
        }
        else
        {
            NSLog(@"ok=====");
        }
        
        return YES;
    }
    
}
-(BOOL)addManyClassWidthObj:(NSArray *) array
{
    @synchronized (self)
    {
        NSString *tableName = nil;
        NSMutableDictionary *dic = nil;
        NSArray *keys = nil;
        @try
        {
            [mDb beginTransaction];
            for (id obj in array)
            {
                tableName = [self getTableName:obj];
                dic = [self getDicFromModelClass:obj];
                keys = [dic allKeys];
                //    NSString *value = nil;
                NSString *keyName = @"";
                NSString *keyValue = @"";
                int num = 0;
                
                for (NSString *key in keys)
                {
                    //        value = [dic objectForKey:key];
                    num ++;
                    if (num == [keys count])
                    {
                        keyName = [keyName stringByAppendingFormat:@"%@) ",key];
                        //            keyValue = [keyValue stringByAppendingFormat:@"'%@'); ",value];
                        keyValue = [keyValue stringByAppendingFormat:@"?)"];
                    }
                    else
                    {
                        keyName = [keyName stringByAppendingFormat:@"%@, ",key];
                        //            keyValue = [keyValue stringByAppendingFormat:@"'%@', ",value];
                        keyValue = [keyValue stringByAppendingFormat:@"?,"];
                    }
                    
                }
                //UPDATE SUser SET name = 'Aa', description = 'mmm' WHERE uid = '2'
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@ VALUES (%@",tableName,keyName,keyValue];
                
                NSLog(@"%@", sql);
                [mDb executeUpdate:sql withArgumentsInArray:[dic allValues]];
            }

        }
        @catch (NSException *exception) {
            [mDb rollback];
             NSLog(@"error");
            return NO;
        }
        @finally {
            [mDb commit];
            
        }
                //[mDb close];
        return YES;
    }
    
}


-(NSString *) getTableName:(id)obj
{
    NSString *tableName = [NSString stringWithUTF8String:object_getClassName(obj)];
    tableName = [NSString stringWithFormat:@"s_%@",tableName];
    return tableName;
}
-(NSString *) getTableNameFrom:(Class)tempClass
{
    NSString *tableName = [tempClass description];
    tableName = [NSString stringWithFormat:@"s_%@",tableName];
    return tableName;
}
//更新某一表的一个对象的某些个字段
-(BOOL)updateTableWidthDictionary:(NSMutableDictionary *)dic searchKey:(NSString *)searchKey searchValue:(NSString *)searchValue tableClass:(Class) tempClass
{
    @synchronized (self)
    {
        if (searchValue == nil)
        {
            return NO;
        }
        NSArray *keys = [dic allKeys];
        
        NSString *value = nil;
        NSString *update = @"";
        int num = 0;
        
        for (NSString *key in keys)
        {
            num++;
            value = [dic objectForKey:key];
            if (num == 1)
            {
                update = [update stringByAppendingFormat:@"%@ = '%@'",key,value];
                //update = [NSString stringWithFormat:@"%@ %@ = '%@'",update,keys,value];
            }
            else
            {
                update = [update stringByAppendingFormat:@", %@ = '%@'",key,value];
                //update = [NSString stringWithFormat:@"%@, %@ = '%@'",update,keys,value];
            }
            
        }
        NSString *tableName = [self getTableName:tempClass];
        //UPDATE SUser SET name = 'Aa', description = 'mmm' WHERE uid = '2'
        update = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = '%@'",tableName,update,searchKey,searchValue];
        
        NSLog(@"%@",update);
        BOOL isok = [mDb executeUpdate:update];
        if (!isok)
        {
            NSLog(@"error");
        }
        //[mDb close];
        return isok;
    }
    
    
}
//NSString *sql = [NSString stringWithFormat:@"UPDATE %@ WHERE %@",tableName,limit];
-(BOOL)updateObjsByClass:(Class)tempClass limit:(NSString *)limit dictionary:(NSMutableDictionary *)dic
{
    @synchronized (self)
    {
        NSArray *keys = [dic allKeys];
        
        NSString *value = nil;
        NSString *update = @"";
        int num = 0;
        
        for (NSString *key in keys)
        {
            num++;
            value = [dic objectForKey:key];
            if (num == 1)
            {
                update = [update stringByAppendingFormat:@"%@ = '%@'",key,value];
            }
            else
            {
                update = [update stringByAppendingFormat:@", %@ = '%@'",key,value];
            }
            
        }
        NSString *tableName = [self getTableName:tempClass];
        update = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,update,limit];
        
        NSLog(@"%@",update);
        BOOL isok = [mDb executeUpdate:update];
        if (!isok)
        {
            NSLog(@"error");
        }
        //[mDb close];
        return isok;
    }
    
}
-(BOOL) isValueableString:(NSString *)content
{
    if (content != nil && (NSNull *)content != [NSNull null] && ![@"" isEqualToString:content] && ![content isEqualToString:[[NSNull null] description]])
    {
        return YES;
    }
    return NO;
}
-(BOOL)updateClassWidthObj:(id) obj searchKey:(NSString *)searchKey searchValue:(NSString *)searchValue
{
    @synchronized (self)
    {
        if (searchKey == nil)
        {
            return NO;
        }
        //如果数据库中有才更新，没有则插入
        if (searchValue != nil && [self findObjBySearchKey:searchKey searchValue:searchValue class:[obj class]]!= nil)
        {
            //表的名字和对象的名字一样
            NSString *tableName = [self getTableName:obj];
            NSMutableDictionary *dic = [self getDicFromModelClass:obj];
            NSArray *keys = [dic allKeys];
            NSString *value = nil;
            NSString *update = @"";
            //        int num = 0;
            for (NSString *key in keys)
            {
                
                value = [dic objectForKey:key];
                if (![self isValueableString:value] && ![@"" isEqualToString:value])
                {
                    continue;
                }
                //            num++;
                if ([update isEqualToString:@""])
                {
                    update = [update stringByAppendingFormat:@"%@ = '%@'",key,value];
                    //update = [NSString stringWithFormat:@"%@ %@ = '%@'",update,keys,value];
                }
                else
                {
                    update = [update stringByAppendingFormat:@", %@ = '%@'",key,value];
                    //update = [NSString stringWithFormat:@"%@, %@ = '%@'",update,keys,value];
                }
                
            }
            //UPDATE SUser SET name = 'Aa', description = 'mmm' WHERE uid = '2'
            update = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = '%@'",tableName,update,searchKey,searchValue];
            
            NSLog(@"%@",update);
            
            BOOL isok = [mDb executeUpdate:update];
            if (!isok)
            {
                NSLog(@"error");
            }
            else
            {
                NSLog(@"ok=========");
            }
            //[mDb close];
            return isok;
            
        }
        else
        {
            return [self addClassWidthObj:obj];
        }
    }
}

-(BOOL)resetClassWidthObj:(id) obj searchKey:(NSString *)searchKey searchValue:(NSString *)searchValue
{
    @synchronized (self)
    {
        if (searchKey == nil)
        {
            return NO;
        }
        //如果数据库中有才更新，没有则插入
        if (searchValue != nil && [self findObjBySearchKey:searchKey searchValue:searchValue class:[obj class]]!= nil)
        {
            //表的名字和对象的名字一样
            NSString *tableName = [self getTableName:obj];
            NSMutableDictionary *dic = [self getDicFromModelClass:obj];
            NSArray *keys = [dic allKeys];
            NSString *value = nil;
            NSString *update = @"";
            for (NSString *key in keys)
            {
                
                value = [dic objectForKey:key];
                //            if (![NomalUtil isValueableString:value] && ![@"" isEqualToString:value])
                //            {
                //                continue;
                //            }
                if ([update isEqualToString:@""])
                {
                    update = [update stringByAppendingFormat:@"%@ = '%@'",key,value];
                    //update = [NSString stringWithFormat:@"%@ %@ = '%@'",update,keys,value];
                }
                else
                {
                    update = [update stringByAppendingFormat:@", %@ = '%@'",key,value];
                    //update = [NSString stringWithFormat:@"%@, %@ = '%@'",update,keys,value];
                }
                
            }
            //UPDATE SUser SET name = 'Aa', description = 'mmm' WHERE uid = '2'
            update = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = '%@'",tableName,update,searchKey,searchValue];
            
            NSLog(@"%@",update);
            BOOL isok = [mDb executeUpdate:update];
            if (!isok)
            {
                NSLog(@"error");
            }
            else
            {
                NSLog(@"ok=========");
            }
            //[mDb close];
            return isok;
            
        }
        else
        {
            return [self addClassWidthObj:obj];
        }
    }
    
}


//一般取第一个
-(id)findObjBySearchKey:(NSString *) searchKey searchValue:(NSString *)searchValue class:(Class)tempClass
{
    @synchronized (self)
    {
        //    [Register class]
        //    id tempClass = objc_getClass([objName UTF8String]);
        id obj = class_createInstance(tempClass, 0);
        NSString *tableName = [self getTableName:obj];
        NSMutableDictionary *dic = [self getDicFromModelClass:obj];
        NSArray *keys = [dic allKeys];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ='%@'",tableName,searchKey,searchValue];
        NSLog(@"%@", sql);
        
        FMResultSet *s = [mDb executeQuery:sql];
        if ([s next])
        {
            for (NSString *propertyName in keys)
            {
                if ([propertyName isEqualToString:@"objId"])
                {
                    int keyId = [s intForColumn:@"_id"];
                    [obj setValue:[NSString stringWithFormat:@"%d",keyId] forKey:propertyName];
                }
                else
                {
                    [obj setValue:[s stringForColumn:propertyName] forKey:propertyName];
                }
                //                object_setInstanceVariable(obj, propertyName, [s stringForColumn:propertyName]);
            }
            
            //retrieve values for each record
        }
        else
        {
            obj = nil;
        }
        //[mDb close];
        return obj;
    }
    
}

//- (int) countItemByClass:(Class)tempClass limit:(NSString *)limit isSelfOpen:(BOOL)isSelfOpen
//{
//    id obj = class_createInstance(tempClass, 0);
//    NSString *tableName = [self getTableName:obj];
//    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@ where %@", tableName,limit];
//    if (limit == nil)
//    {
//        sql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
//    }
//    NSLog(@"%@", sql);
//    if (![mDb open])
//    {
//        NSLog(@"Could not open db.");
//    }
//    else
//    {
//        FMResultSet *s = [mDb executeQuery:sql];
//        while ([s next])
//        {
//            NSInteger count = [s intForColumn:@"count"];
//            return count;
//            //retrieve values for each record
//        }
////        //[mDb close];
//    }
//
//    return 0;
//}

// 获得表的数据条数
- (int) countItemByClass:(Class)tempClass limit:(NSString *)limit
{
    @synchronized (self)
    {
        id obj = class_createInstance(tempClass, 0);
        NSString *tableName = [self getTableName:obj];
        NSString *sql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@ where %@", tableName,limit];
        if (limit == nil)
        {
            sql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
        }
        NSLog(@"%@", sql);
        
        FMResultSet *s = [mDb executeQuery:sql];
        while ([s next])
        {
            NSInteger count = [s intForColumn:@"count"];
            return (int)count;
            //retrieve values for each record
        }
        //        //[mDb close];
        
        return 0;
    }
    
}

// 获得表的数据条数
- (int) countItemByClass:(Class)tempClass count:(NSString *)count limit:(NSString *)limit
{
    @synchronized (self)
    {
        id obj = class_createInstance(tempClass, 0);
        NSString *tableName = [self getTableName:obj];
        NSString *sql = [NSString stringWithFormat:@"SELECT %@ as 'count' FROM %@ where %@",count,tableName,limit];
        if (limit == nil)
        {
            sql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
        }
        NSLog(@"%@", sql);
        
        FMResultSet *s = [mDb executeQuery:sql];
        while ([s next])
        {
            NSInteger count = [s intForColumn:@"count"];
            return (int)count;
            //retrieve values for each record
        }
        //        //[mDb close];
        
        return 0;
    }
    
}


-(NSMutableArray *)findManyObjsByClass:(Class)tempClass limit:(NSString *)limit
{
    @synchronized (self)
    {
        //    [Register class]
        //    id tempClass = objc_getClass([objName UTF8String]);
        id obj = class_createInstance(tempClass, 0);
        NSString *tableName = [self getTableName:obj];
        NSMutableDictionary *dic = [self getDicFromModelClass:obj];
        NSArray *keys = [dic allKeys];
        NSString *sql = nil;
        if (limit == nil)
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        }
        else
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",tableName,limit];
        }
        NSMutableArray *lists =[NSMutableArray arrayWithCapacity:1];
        NSLog(@"%@", sql);
        FMResultSet *s = [mDb executeQuery:sql];
        while ([s next])
        {
            obj = class_createInstance(tempClass, 0);
            for (NSString *propertyName in keys)
            {
                if ([propertyName isEqualToString:@"objId"])
                {
                    int keyId = [s intForColumn:@"_id"];
                    [obj setValue:[NSString stringWithFormat:@"%d",keyId] forKey:propertyName];
                }
                else
                {
                    [obj setValue:[s stringForColumn:propertyName] forKey:propertyName];
                }
                //                object_setInstanceVariable(obj, propertyName, [s stringForColumn:propertyName]);
                
            }
            [lists addObject:obj];
            //retrieve values for each record
        }
        //[mDb close];
        
        return lists;
    }
    
}

-(NSMutableArray *)findAllObjsByClass:(Class)tempClass
{
    @synchronized (self)
    {
        id obj = class_createInstance(tempClass, 0);
        NSString *tableName = [self getTableName:obj];
        NSMutableDictionary *dic = [self getDicFromModelClass:obj];
        //    free(obj);
        NSArray *keys = [dic allKeys];
        
        NSMutableArray *lists = [NSMutableArray arrayWithCapacity:1];
        
        FMResultSet *s = [mDb executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
        while ([s next])
        {
            obj = class_createInstance(tempClass, 0);
            for (NSString *propertyName in keys)
            {
                
                if ([propertyName isEqualToString:@"objId"])
                {
                    int keyId = [s intForColumn:@"_id"];
                    [obj setValue:[NSString stringWithFormat:@"%d",keyId] forKey:propertyName];
                }
                else
                {
                    [obj setValue:[s stringForColumn:propertyName] forKey:propertyName];
                }
                //                object_setInstanceVariable(obj, propertyName, [s stringForColumn:propertyName]);
            }
            [lists addObject:obj];
            //            free(obj);
            //retrieve values for each record
        }
        //[mDb close];
        
        return lists;
    }
    
}
-(BOOL)deleteObjWithClass:(Class)tempClass searchKey:(NSString *) searchKey searchValue:(NSString *)searchValue
{
    @synchronized (self)
    {
        BOOL isOk = YES;
        NSString *tableName = [self getTableNameFrom:tempClass];
        NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",tableName,searchKey,searchValue];
        
        isOk = [mDb executeUpdate:query];
        
        if (isOk)
        {
            NSLog(@"ok");
        }
        else
        {
            NSLog(@"error");
        }
        //[mDb close];
        return isOk;
        
    }
}

-(BOOL)deleteObjWithClass:(Class)tempClass
{
    return [self deleteObjWithClass:tempClass limit:nil];
}

-(BOOL)deleteObjWithClass:(Class)tempClass limit:(NSString *)limit
{
    @synchronized (self)
    {
        BOOL isOk = YES;
        NSString *tableName = [self getTableNameFrom:tempClass];
        NSString * query = nil;
        //DELETE FROM XX where type != '1' and type != '2'
        //DELETE FROM XX where type == '1' or type == '2'
        if (limit != nil)
        {
            query = [NSString stringWithFormat:@"DELETE FROM %@ where %@",tableName,limit];
        }
        else
        {
            query = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        }
        isOk = [mDb executeUpdate:query];
        NSLog(@"%@",query);
        if (isOk)
        {
            NSLog(@"ok");
        }
        else
        {
            NSLog(@"error");
        }
        //[mDb close];
        return isOk;
    }
    
}

-(void)closeDataBase
{
    @synchronized (self)
    {
        if (mDb != nil)
        {
            [mDb close];
        }
    }
    
}

-(void)openDataBase
{
    @synchronized (self)
    {
        if (mDb != nil)
        {
            [mDb open];
        }
    }
    
}
//创建和更新表
-(void)createAndUpdateAllTable
{
    
    //每个版本做一次表的检查是否有新增的字段
    NSString *appVersion = AppVersion;
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"dataBase_AppVersion"];
    if (![appVersion isEqualToString:temp])
    {
        [[DataBaseUtil instance] createTabaleWidthClassArray:[NSMutableArray arrayWithObjects:NSClassFromString(@"VersionModel"),NSClassFromString(@"UserInfoModel"),nil]];
        
        //NewsInfoMode
        //NSClassFromString(@"DeviceRegister"),
        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"dataBase_AppVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
}

@end

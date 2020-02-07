
//
//  GSSaveDBService.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/22.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSSaveDBService.h"

@implementation GSSaveDBService

+ (instancetype)sharedInstance
{
    static GSSaveDBService *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      _sharedClient = [[self alloc] init];
                      [_sharedClient creatDatabase];
                  });
    return _sharedClient;
}

- (void)creatDatabase
{
    NSArray*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths safeObjectAtIndex:0];
    NSString *filepath = [path stringByAppendingPathComponent:@"savetxt.db"];
    NSLog(@"DB PAHT %@",filepath);
    self.database = [FMDatabase databaseWithPath:filepath];
    if ( ![self.database open] ){
        return;
    }
    [self.database executeUpdate:@"create table if not exists record(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,author TEXT,content TEXT NOT NULL UNIQUE)"];
    [self.database executeUpdate:@"create table if not exists saveinfo(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,author TEXT,content TEXT NOT NULL UNIQUE)"];
}

- (BOOL)insertRecordWithModel:(GSTxtModel * )model
{
    if ( ![self.database open] ){
        [self.database open];
    }
    NSString *author = model.author;
    NSString *title = model.title;
    NSString *content = model.content;
    BOOL result = [self.database executeUpdate:@"insert into record (title,author,content) values(?,?,?)", title,author,content];
    return result;
}


- (BOOL)insertSaveWithModel:(GSTxtModel * )model
{
    if ( ![self.database open] ){
        [self.database open];
    }
    NSString *author = model.author;
    NSString *title = model.title;
    NSString *content = model.content;
    BOOL result = [self.database executeUpdate:@"insert into saveinfo (title,author,content) values(?,?,?)", title,author,content];
    return result;
}

- (NSArray *)getAllRecord
{
    NSString *phoneSQL = [NSString stringWithFormat:@"SELECT * FROM record ORDER BY id DESC"];
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([resultSet next]) {
        GSTxtModel *model =  [[GSTxtModel alloc]init];
        NSString *author = [resultSet stringForColumn:@"author"];
        NSString *title = [resultSet stringForColumn:@"title"];
        NSString *content = [resultSet stringForColumn:@"content"];
        NSUInteger did = [resultSet intForColumn:@"id"];

        model.author = author;
        model.title = title;
        model.content = content;
        model.did = did;

        [resultArray safeAddObject:model];
    }
    return resultArray;
}


- (NSArray *)getAllSave
{
    NSString *phoneSQL = [NSString stringWithFormat:@"SELECT * FROM saveinfo ORDER BY id DESC"];
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([resultSet next]) {
        GSTxtModel *model =  [[GSTxtModel alloc]init];
        NSString *author = [resultSet stringForColumn:@"author"];
        NSString *title = [resultSet stringForColumn:@"title"];
        NSString *content = [resultSet stringForColumn:@"content"];
        NSUInteger did = [resultSet intForColumn:@"id"];

        model.author = author;
        model.title = title;
        model.content = content;
        model.did = did;

        [resultArray safeAddObject:model];
    }
    return resultArray;
}

- (GSTxtModel *)getSaveItemById:(NSUInteger)did
{
    NSString *phoneSQL = @"";
    phoneSQL = [NSString stringWithFormat:@"select * from saveinfo where id = %d",did];
    if ( ![self.database open] ){
        [self.database open];
    }
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    GSTxtModel *model =  [[GSTxtModel alloc]init];
    if ([resultSet next]) {
        NSString *author = [resultSet stringForColumn:@"author"];
        NSString *title = [resultSet stringForColumn:@"title"];
        NSString *content = [resultSet stringForColumn:@"content"];
        NSUInteger did = [resultSet intForColumn:@"id"];
        
        model.author = author;
        model.title = title;
        model.content = content;
        model.did = did;
    }
    return model;
}

- (GSTxtModel *)getrecordItemById:(NSUInteger)did
{
    NSString *phoneSQL = @"";
    phoneSQL = [NSString stringWithFormat:@"select * from record where id = %d",did];
    if ( ![self.database open] ){
        [self.database open];
    }
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    GSTxtModel *model =  [[GSTxtModel alloc]init];
    if ([resultSet next]) {
        NSString *author = [resultSet stringForColumn:@"author"];
        NSString *title = [resultSet stringForColumn:@"title"];
        NSString *content = [resultSet stringForColumn:@"content"];
        NSUInteger did = [resultSet intForColumn:@"id"];
        
        model.author = author;
        model.title = title;
        model.content = content;
        model.did = did;
    }
    return model;
}

@end

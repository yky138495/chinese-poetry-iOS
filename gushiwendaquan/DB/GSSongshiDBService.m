//
//  GSSongshiDBService.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSSongshiDBService.h"


@implementation GSSongshiDBService

+ (instancetype)sharedInstance
{
    static GSSongshiDBService *_sharedClient = nil;
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
    NSString *sishuStr = @"songshi.db";
    NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
    
    NSLog(@"DB PAHT %@",sishuStrPath);
    self.database = [FMDatabase databaseWithPath:sishuStrPath];
    if ( ![self.database open] ){
        return;
    }
}

//shi  id  author content strains  title
//author  id  name long_desc short_desc

- (BOOL)insertColumnBookid:(NSString *)bookid chapterid:(NSString *)chapterid path:(NSString *)path
{
    BOOL result = [self.database executeUpdate:@"insert into chapter values(?,?,?)", bookid,chapterid,path];
    return result;
}


- (NSArray *)getSongshiByName:(NSString *)name
{
    NSString *phoneSQL = @"";
    if (CHECK_VALID_STRING(name)) {
        phoneSQL = [NSString stringWithFormat:@"SELECT * FROM shi WHERE author = '%@' OR author = '%@'",name,[name fg_reversed]];

//        phoneSQL = [NSString stringWithFormat:@"SELECT * FROM shi WHERE author = '%@'",name];
    }
    
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([resultSet next]) {
        TangShi *tangShi =  [[TangShi alloc]init];
        NSString *author = [resultSet stringForColumn:@"author"];
        NSString *content = [resultSet stringForColumn:@"content"];
        NSString *strains = [resultSet stringForColumn:@"strains"];
        NSString *title = [resultSet stringForColumn:@"title"];

        tangShi.author = author;
        tangShi.title = title;
        tangShi.strains = strains;
        tangShi.content = content;
        [resultArray safeAddObject:tangShi];
    }
    return [resultArray copy];
}


- (NSArray *)getSongshiByKey:(NSString *)key
{
    NSString *phoneSQL = @"";
    NSString *key_fu = [key fg_reversed];
    NSString *realKey = [NSString stringWithFormat:@"[%@|%@]",key,key_fu];
    if (CHECK_VALID_STRING(realKey)) {
        
        phoneSQL = [NSString stringWithFormat:@"SELECT * FROM shi WHERE content like '%%%@%%' or title like '%%%@%%' or author like '%%%@%%'",key,key,key];
    }
    
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([resultSet next]) {
        TangShi *tangShi =  [[TangShi alloc]init];
        NSString *author = [resultSet stringForColumn:@"author"];
        NSString *content = [resultSet stringForColumn:@"content"];
        NSString *strains = [resultSet stringForColumn:@"strains"];
        NSString *title = [resultSet stringForColumn:@"title"];
        
        tangShi.author = author;
        tangShi.title = title;
        tangShi.strains = strains;
        tangShi.content = content;
        [resultArray safeAddObject:tangShi];
    }
    return [resultArray copy];
}


- (Author *)getAuthorByName:(NSString *)name
{
    NSString *phoneSQL = @"";
    if (CHECK_VALID_STRING(name)) {
        phoneSQL = [NSString stringWithFormat:@"SELECT * FROM author WHERE name = '%@'",name];
    }
    
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    Author *author =  [[Author alloc]init];

    while ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *long_desc = [resultSet stringForColumn:@"long_desc"];
        
        author.name = name;
        author.desc = long_desc;
        break;
    }
    return author;
}


- (NSArray *)getAllAuthor
{
    NSString *phoneSQL = @"";
    phoneSQL = [NSString stringWithFormat:@"SELECT * FROM author"];

    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([resultSet next]) {
        Author *author =  [[Author alloc]init];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *long_desc = [resultSet stringForColumn:@"long_desc"];
        
        author.name = name;
        author.desc = long_desc;
        
        [resultArray safeAddObject:author];
    }
    return [resultArray copy];
}



@end

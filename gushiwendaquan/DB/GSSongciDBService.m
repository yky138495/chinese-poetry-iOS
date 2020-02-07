//
//  GSSongciDBService.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSSongciDBService.h"

@implementation GSSongciDBService

+ (instancetype)sharedInstance
{
    static GSSongciDBService *_sharedClient = nil;
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
    NSString *sishuStr = @"ci.db";
    NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
    
    NSLog(@"DB PAHT %@",sishuStrPath);
    self.database = [FMDatabase databaseWithPath:sishuStrPath];
    if ( ![self.database open] ){
        return;
    }
}

//ci rhythmic  author content
//ciauthor name long_desc short_desc

- (NSArray *)getSongciByName:(NSString *)name
{
    NSString *phoneSQL = @"";
    if (CHECK_VALID_STRING(name)) {
        phoneSQL = [NSString stringWithFormat:@"SELECT * FROM ci WHERE author = '%@'",name];
    }
    
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([resultSet next]) {
        Songci *songci =  [[Songci alloc]init];
        
        NSString *author = [resultSet stringForColumn:@"author"];
        NSString *content = [resultSet stringForColumn:@"content"];
        NSString *rhythmic = [resultSet stringForColumn:@"rhythmic"];
        
        songci.author = author;
        songci.rhythmic = rhythmic;
        songci.content = content;
        [resultArray safeAddObject:songci];
    }
    return [resultArray copy];
}


- (NSArray *)getSongciByKey:(NSString *)key
{
    NSString *phoneSQL = @"";
    NSString *key_fu = [key fg_reversed];
    NSString *realKey = [NSString stringWithFormat:@"[%@|%@]",key,key_fu];
    if (CHECK_VALID_STRING(realKey)) {
        phoneSQL = [NSString stringWithFormat:@"SELECT * FROM ci WHERE content like '%%%@%%' or rhythmic like '%%%@%%' or author like '%%%@%%'",realKey,realKey,realKey];

//        phoneSQL = [NSString stringWithFormat:@"SELECT * FROM ci WHERE content like '%@'",key];
    }
    
    FMResultSet *resultSet = [self.database executeQuery:phoneSQL];
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([resultSet next]) {
        Songci *songci =  [[Songci alloc]init];
        
        NSString *author = [resultSet stringForColumn:@"author"];
        NSString *content = [resultSet stringForColumn:@"content"];
        NSString *rhythmic = [resultSet stringForColumn:@"rhythmic"];
        
        songci.author = author;
        songci.rhythmic = rhythmic;
        songci.content = content;
        [resultArray safeAddObject:songci];
    }
    return [resultArray copy];
}


- (Author *)getAuthorByName:(NSString *)name
{
    NSString *phoneSQL = @"";
    if (CHECK_VALID_STRING(name)) {
        phoneSQL = [NSString stringWithFormat:@"SELECT * FROM ciauthor WHERE name = '%@'",name];
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
    phoneSQL = [NSString stringWithFormat:@"SELECT * FROM ciauthor"];
    
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

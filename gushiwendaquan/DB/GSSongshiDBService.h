//
//  GSSongshiDBService.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "TangShi.h"
#import "Author.h"

@interface GSSongshiDBService : NSObject

@property(nonatomic, strong) FMDatabase *database;
+ (instancetype)sharedInstance;

- (NSArray *)getSongshiByName:(NSString *)name;
- (NSArray *)getSongshiByKey:(NSString *)key;
- (Author *)getAuthorByName:(NSString *)name;
- (NSArray *)getAllAuthor;

@end


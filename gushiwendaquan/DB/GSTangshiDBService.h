//
//  GSTangshiDBService.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>
#import "TangShi.h"
#import "Author.h"

@interface GSTangshiDBService : NSObject

@property(nonatomic, strong) FMDatabase *database;
+ (instancetype)sharedInstance;

- (NSArray *)getTangshiByName:(NSString *)name;
- (NSArray *)getTangshiByKey:(NSString *)key;
- (Author *)getAuthorByName:(NSString *)name;
- (NSArray *)getAllAuthor;
@end


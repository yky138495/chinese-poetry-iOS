//
//  GSSongciDBService.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>
#import "Author.h"
#import "Songci.h"

@interface GSSongciDBService : NSObject

@property(nonatomic, strong) FMDatabase *database;
+ (instancetype)sharedInstance;

- (NSArray *)getSongciByName:(NSString *)name;
- (NSArray *)getSongciByKey:(NSString *)key;
- (Author *)getAuthorByName:(NSString *)name;
- (NSArray *)getAllAuthor;
@end


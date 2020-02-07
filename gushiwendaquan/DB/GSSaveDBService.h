//
//  GSSaveDBService.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/22.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "GSTxtModel.h"

@interface GSSaveDBService : NSObject

@property(nonatomic, strong) FMDatabase *database;

+ (instancetype)sharedInstance;

- (BOOL)insertRecordWithModel:(GSTxtModel * )model;
- (BOOL)insertSaveWithModel:(GSTxtModel * )model;
- (NSArray *)getAllRecord;
- (NSArray *)getAllSave;
- (GSTxtModel *)getSaveItemById:(NSUInteger)did;
- (GSTxtModel *)getrecordItemById:(NSUInteger)did;

@end


//
//  GSTxtModel.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/22.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSTxtModel : NSObject

@property (assign, nonatomic) NSUInteger did;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;

@end


//
//  Shijing.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Shijing : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *chapter;
@property (copy, nonatomic) NSString *section;

@property (copy, nonatomic) NSArray *paragraphs;

@end


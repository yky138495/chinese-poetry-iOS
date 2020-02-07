//
//  TangShi.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TangShi : NSObject

@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *strains;
@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSArray *paragraphs;
@property (copy, nonatomic) NSArray *strainsArray;


@end


//
//  chinesepoetryUtil.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface chinesepoetryUtil : NSObject

DEF_SINGLETON(chinesepoetryUtil);

@property (nonatomic, copy) NSString *authorssong;
@property (nonatomic, copy) NSString *authorstang;
@property (nonatomic, copy) NSString *songciauthor;


//全唐诗
@property (nonatomic, copy) NSArray *tangArray;
//全宋诗
@property (nonatomic, copy) NSArray *songArray;
//全宋词
@property (nonatomic, copy) NSArray *ciArray;
//五代·@"花间集
@property (nonatomic, copy) NSArray *huajianArray;
//五代·南唐二主词
@property (nonatomic, copy) NSArray *erzhuArray;
//论语
@property (nonatomic, copy) NSString *luyuStr;
//诗经
@property (nonatomic, copy) NSString *shijingStr;
//幽梦影
@property (nonatomic, copy) NSString *youmengyingStr;
//四书五经
@property (nonatomic, copy) NSString *sishuStr;



@end


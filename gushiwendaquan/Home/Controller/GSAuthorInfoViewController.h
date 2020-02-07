//
//  GSAuthorInfoViewController.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQBaseViewController.h"

typedef NS_ENUM(NSUInteger,GSAuthorInfoViewControllerType)
{
    GSAuthorInfoViewControllerTypeTang = 0,
    GSAuthorInfoViewControllerTypeSongshi = 1,
    GSAuthorInfoViewControllerTypeSong = 2,
};

@interface GSAuthorInfoViewController : MQBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *txt;
@property (copy, nonatomic)  NSString *name;

@property (nonatomic, assign) GSAuthorInfoViewControllerType type;

@end


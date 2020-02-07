//
//  GSAuthViewViewController.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQBaseViewController.h"

typedef NS_ENUM(NSUInteger,GSAuthViewViewControllerType)
{
    GSAuthViewViewControllerTypeTang = 0,
    GSAuthViewViewControllerTypeSongshi = 1,
    GSAuthViewViewControllerTypeSong = 2,
};

@interface GSAuthViewViewController : MQBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) GSAuthViewViewControllerType type;

@end


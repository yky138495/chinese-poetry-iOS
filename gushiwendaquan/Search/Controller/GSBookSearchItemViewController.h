//
//  GSBookSearchItemViewController.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQBaseViewController.h"
#import "PYSearch.h"

typedef NS_ENUM(NSUInteger, GSBookSearchItemViewControllerType) {
    GSBookSearchItemViewControllerTypeTang = 1,
    GSBookSearchItemViewControllerTypeSongShi  = 2,
    GSBookSearchItemViewControllerTypeSong  = 3,
};


@interface GSBookSearchItemViewController : PYSearchViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) GSBookSearchItemViewControllerType type;

@end


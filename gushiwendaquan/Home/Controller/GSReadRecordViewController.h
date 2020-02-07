//
//  GSReadRecordViewController.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/22.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQBaseViewController.h"

typedef NS_ENUM(NSUInteger,GSReadRecordViewControllerType)
{
    GSReadRecordViewControllerTypeRead = 0,
    GSReadRecordViewControllerTypeSave = 1,
};

@interface GSReadRecordViewController : MQBaseViewController<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) GSReadRecordViewControllerType type;

@end


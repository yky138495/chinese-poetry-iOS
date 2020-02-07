//
//  MQMeCenterCell.h
//  MQReader
//
//  Created by yangmengge on 2019/1/8.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQMeCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *info;

@end

NS_ASSUME_NONNULL_END

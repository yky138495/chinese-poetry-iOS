//
//  MQMeCenterCell.m
//  MQReader
//
//  Created by yangmengge on 2019/1/8.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQMeCenterCell.h"

@implementation MQMeCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

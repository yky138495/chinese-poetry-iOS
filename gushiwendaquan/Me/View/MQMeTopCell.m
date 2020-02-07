//
//  MQMeTopCell.m
//  MQReader
//
//  Created by yangmengge on 2019/1/8.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQMeTopCell.h"

@implementation MQMeTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

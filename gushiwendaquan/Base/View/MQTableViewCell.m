//
//  MQTableViewCell.m
//  MQReader
//
//  Created by yangmengge on 2019/1/9.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQTableViewCell.h"

@implementation MQTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

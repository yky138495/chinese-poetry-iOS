//
//  MQNoDataView.m
//  MQKeep
//
//  Created by yangmengge on 2018/6/12.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import "MQNoDataView.h"

@interface MQNoDataView()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong)  UILabel *titleLabel;

@end


@implementation MQNoDataView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.containerView = [UIView new];
    [self addSubview:self.containerView];
    
    @weakify(self);
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.edges.equalTo(self);
    }];
    
    _wImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata1.png"]];
    
    [self.containerView addSubview:_wImageView];
    [_wImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.containerView).with.offset(-2);
        make.centerY.equalTo(self.containerView.mas_centerY).multipliedBy(0.7f); // 偏向上部
        make.width.equalTo(@100);
        make.height.equalTo(@120);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"空空如也～";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.numberOfLines = 0;
    [self.containerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.wImageView.mas_bottom).with.offset(30);
        make.left.equalTo(self.containerView).with.offset(50);
        make.right.equalTo(self.containerView).with.offset(-50);
    }];
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        self.titleLabel.text = title;
    }
}

@end

//
//  GSTxtViewViewController.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQBaseViewController.h"
#import "GSTxtModel.h"

@interface GSTxtViewViewController : MQBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *autho;
@property (weak, nonatomic) IBOutlet UITextView *txt;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *fanButton;
@property (weak, nonatomic) IBOutlet UIButton *cidianbutton;

@property (copy, nonatomic)  NSArray *TangshiArray;
@property (copy, nonatomic)  NSArray *SongciArray;
@property (nonatomic, strong) GSTxtModel *txtModel;

@property (copy, nonatomic) NSString *seachText;

@end


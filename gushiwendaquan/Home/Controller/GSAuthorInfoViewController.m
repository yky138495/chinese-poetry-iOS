//
//  GSAuthorInfoViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSAuthorInfoViewController.h"
#import "GSBookSearchViewController.h"
#import "Author.h"
#import "GSSongshiDBService.h"
#import "GSTangshiDBService.h"
#import "GSSongciDBService.h"
#import "GSTxtModel.h"

@interface GSAuthorInfoViewController ()

@property (nonatomic, assign) BOOL isFan;
@property (nonatomic, strong) Author *author;
@property (nonatomic, assign) NSUInteger tagType;
@property (nonatomic, copy) NSString *labelFan;
@property (nonatomic, copy) NSString *textFan;
@property (nonatomic, copy) NSString *labelsimple;
@property (nonatomic, copy) NSString *textsimple;
@property (weak, nonatomic) IBOutlet UIButton *fanButton;

@end

@implementation GSAuthorInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txt.editable = NO;
    self.txt.userInteractionEnabled = YES;
    self.txt.showsVerticalScrollIndicator = NO;
    self.txt.scrollEnabled = YES;
    CGPoint offset = self.txt.contentOffset;
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        [self.txt setContentOffset:offset];
    }];
    
    self.fanButton.layer.masksToBounds = YES;
    self.fanButton.layer.cornerRadius = 3.f;
    self.fanButton.layer.borderColor = [UIColor colorWithHexString:@"#75BDF3"].CGColor;
    self.fanButton.layer.borderWidth = 1.f;
    
    self.isFan = NO;
    
//    self.navigationItem.rightBarButtonItem = [self searchButtonItem];
}

- (IBAction)fanAction:(id)sender {
    self.isFan = !self.isFan;
}

-(void)setIsFan:(BOOL)isFan
{
    _isFan = isFan;
    if (isFan) {
        self.label.text = self.labelFan;
        self.txt.text = self.textFan;
        [self.fanButton setTitle:@"简体" forState:UIControlStateNormal];

    }else{
        self.label.text = self.labelsimple;
        self.txt.text = self.textsimple;
        [self.fanButton setTitle:@"繁体" forState:UIControlStateNormal];
    }
}

- (UIBarButtonItem *)searchButtonItem
{
    UIButton *wBarBtn = [[UIButton alloc] init];
    [wBarBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [wBarBtn setTitleColor:[UIColor colorWithHexString:@"#01A8C2"] forState:UIControlStateNormal];
    wBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [wBarBtn addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [wBarBtn sizeToFit];
    UIBarButtonItem * wBarItem = [[UIBarButtonItem alloc] initWithCustomView:wBarBtn];
    return wBarItem;
}

- (void)searchButtonClicked:(id)sender
{
    GSBookSearchViewController *bookSearchViewController = [[GSBookSearchViewController alloc]init];
    [self.navigationController pushViewController:bookSearchViewController animated:YES];
}

- (void)setName:(NSString *)name
{
    _name = name;
    if (CHECK_VALID_STRING(name)) {
        [self auth:name];
        self.isFan = NO;
    }
}

- (void)auth:(NSString *)keyWord
{
    Author * author;
    author = [[GSTangshiDBService sharedInstance]getAuthorByName:keyWord];
    NSMutableArray *modelArray = [NSMutableArray array];

    if (CHECK_VALID_STRING(author.name)) {
        _tagType = 0;
    }else{
        author = [[GSSongshiDBService sharedInstance]getAuthorByName:keyWord];
        if (CHECK_VALID_STRING(author.name)) {
            _tagType = 1;
        }else{
            author = [[GSSongciDBService sharedInstance]getAuthorByName:keyWord];
            if (CHECK_VALID_STRING(author.name)) {
                _tagType = 2;
            }else{
                
            }
        }
    }
    
    if (CHECK_VALID_STRING(author.name)) {
        NSString *strName = MQ_SAFE_STRING(author.name);
        self.labelsimple = [strName fg_reversed];
        self.labelFan = strName;

        NSString *strAuthor = MQ_SAFE_STRING(author.desc);
        self.textsimple = [strAuthor fg_reversed];
        self.textFan = strAuthor;
        
        self.label.text = self.labelsimple;
        self.txt.text = self.textsimple;
    }
    
}

@end

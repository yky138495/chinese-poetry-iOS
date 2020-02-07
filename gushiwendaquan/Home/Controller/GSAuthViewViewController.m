//
//  GSAuthViewViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSAuthViewViewController.h"
#import "Author.h"
#import "GSTxtViewViewController.h"
#import "TangShi.h"
#import "Songci.h"
#import "chinesepoetryUtil.h"
#import "GSBookSearchViewController.h"
#import "GSSongshiDBService.h"
#import "GSTangshiDBService.h"
#import "GSSongciDBService.h"

@interface GSAuthViewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cDataArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL hasData;
@property (nonatomic, strong) Author *author;

@end

@implementation GSAuthViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F3F5F7"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cDataArray = [NSMutableArray array];
    self.currentPage = 1;
    self.hasData = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.hasData) {
            self.currentPage ++;
            [self requestData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData]; //无更多数据
        }
    }];
    self.navigationItem.rightBarButtonItem = [self searchButtonItem];
    [self.cDataArray removeAllObjects];
    [self.cDataArray addObjectsFromArray:_dataArray];
    [self.tableView reloadData];
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentPage = 1;
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.cDataArray removeAllObjects];
    [self.cDataArray addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return self.cDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellReuseId = @"cityCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = MQ_COLORWITHCODE(@"#F3F5F7");
        [cell addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell);
            make.left.right.equalTo(cell);
            make.height.equalTo(@1);
        }];
        cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:14];
    }
    self.author = [self.cDataArray safeObjectAtIndex:indexPath.section];
    NSString *name = [MQ_SAFE_STRING(self.author.name) fg_reversed];
    cell.textLabel.text = name;
    return  cell;
}

/*
 NSArray *familyNames = [UIFont familyNames];
 for( NSString *familyName in familyNames ){
 printf( "Family: %s \n", [familyName UTF8String] );
 NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
 for( NSString *fontName in fontNames ){
 printf( "\tFont: %s \n", [fontName UTF8String] );
 }
 }
 
 */

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray* tile = [NSMutableArray array];
    NSString* tileStr = nil;
    for (Author *item in self.cDataArray) {
        tileStr =  [item.name substringWithRange:NSMakeRange(0, 1)];
        [tile addObject:tileStr];
    }
    return tile;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    self.author = [self.cDataArray safeObjectAtIndex:indexPath.section];
    NSArray *array =  [self searchName:MQ_SAFE_STRING(self.author.name)];
    GSTxtViewViewController *txtViewViewController = [[GSTxtViewViewController alloc]init];
//    txtViewViewController.view.backgroundColor = [UIColor whiteColor];
    
//    txtViewViewController.title = @"唐诗";
    if (self.type == GSAuthViewViewControllerTypeSong) {
        txtViewViewController.SongciArray = array;
    }else{
        txtViewViewController.TangshiArray = array;
    }
    [self.navigationController pushViewController:txtViewViewController animated:YES];
}

- (void)requestIndex
{
    [self requestData];
}

- (void)requestData
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

- (NSArray *)searchName:(NSString *)name
{
    if (!CHECK_VALID_STRING(name)) {
        return @[];
    }
    //0-57000  1000步进
    if (self.type == GSAuthViewViewControllerTypeTang) {
        NSArray *array =  [[GSTangshiDBService sharedInstance] getTangshiByName:name];
        return array;
//        NSMutableArray *tangArray = [NSMutableArray array];
//        BOOL hasData = NO;
//        for (NSUInteger i = 0; i<= 57 ; i++) {
//            NSString *sishuStr = [NSString stringWithFormat:@"poet.tang.%d.json",i*1000];
//            NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
//            NSError *error;
//            NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
//            NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
//            NSArray *arry = [TangShi mj_objectArrayWithKeyValuesArray:json];
//            for (TangShi *tang in arry) {
//                if ([name isEqualToString:tang.author]) {
//                    [tangArray addObject:tang];
//                    hasData = YES;
//                }else{
//                    if (hasData) {
//                        return [tangArray copy];
//                        break;
//                    }
//                }
//            }
//
//        }
      
        
        //0-254000  1000步进
    }else if (self.type == GSAuthViewViewControllerTypeSongshi) {
        NSArray *array =  [[GSSongshiDBService sharedInstance] getSongshiByName:name];
        return array;
//        NSMutableArray *tangArray = [NSMutableArray array];
//        BOOL hasData = NO;
//        for (NSUInteger i = 0; i<= 254 ; i++) {
//            NSString *sishuStr = [NSString stringWithFormat:@"poet.song.%d.json",i*1000];
//            NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
//            NSError *error;
//            NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
//            NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
//            NSArray *arry = [TangShi mj_objectArrayWithKeyValuesArray:json];
//            for (TangShi *tang in arry) {
//                if ([name isEqualToString:tang.author]) {
//                    [tangArray addObject:tang];
//                    hasData = YES;
//                }else{
//                    if (hasData) {
//                        return [tangArray copy];
//                        break;
//                    }
//                }
//            }
//
//        }
        
        //0-21000  1000步进
    }else if (self.type == GSAuthViewViewControllerTypeSong) {
        NSArray *array =  [[GSSongciDBService sharedInstance] getSongciByName:name];
        return array;
//        NSMutableArray *tangArray = [NSMutableArray array];
//        BOOL hasData = NO;
//        for (NSUInteger i = 0; i<= 21; i++) {
//            NSString *sishuStr = [NSString stringWithFormat:@"ci.song.%d.json",i*1000];
//            NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
//            NSError *error;
//            NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
//            NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
//            NSArray *arry = [Songci mj_objectArrayWithKeyValuesArray:json];
//            for (Songci *tang in arry) {
//                if ([name isEqualToString:tang.author]) {
//                    [tangArray addObject:tang];
//                    hasData = YES;
//                }else{
//                    if (hasData) {
//                        return [tangArray copy];
//                        break;
//                    }
//                }
//            }
//        }
    }
    return @[];
}


@end

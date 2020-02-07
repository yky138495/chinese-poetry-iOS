//
//  GSBookSearchItemViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSBookSearchItemViewController.h"

@interface GSBookSearchItemViewController ()

@property (nonatomic, strong) NSMutableArray *cDataArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL hasData;

@property (nonatomic, copy) NSArray *keyWordArray;
@property (nonatomic, copy) NSArray *pullDownArray;
@property (nonatomic, copy) NSString *seachText;

@end

@implementation GSBookSearchItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cDataArray = [NSMutableArray array];
    self.currentPage = 1;
    self.tableView.hidden = YES;
    self.hasData = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.hasData) {
            self.currentPage ++;
            [self requestData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData]; //无更多数据
        }
    }];
}

- (void)initKeyWordData
{
    NSMutableArray *hotSeaches = [NSMutableArray array];
    for (NSUInteger i= 0 ; i< 20 ;i ++) {
        [hotSeaches addObject:@"作者"];
    }
    self.searchTextField.placeholder = @"内容、作者";
    self.searchHistoryTitle = @"搜索记录";
    self.hotSearchTitle = @"推荐";
    self.hotSearches = hotSeaches;
    self.hotSearchStyle = PYHotSearchStyleColorfulTag;
    self.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
}

- (void)refeshSearchDidClick
{
    [self requestData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *text = searchBar.text;
    self.seachText = text;
    self.tableView.hidden = NO;
    self.hidden = YES;
    [self requestSearch:text];
    if (!CHECK_VALID_STRING(text)) {
        self.tableView.hidden = YES;
        self.hidden = NO;
    }
    [super searchBarSearchButtonClicked:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *text = searchBar.text;
    self.seachText = text;
    self.tableView.hidden = YES;
    self.hidden = NO;
    [self requestSearchKey:text];
    if (!CHECK_VALID_STRING(text)) {
        self.tableView.hidden = YES;
        self.hidden = NO;
    }
    [super searchBar:searchBar textDidChange:searchText];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    BOOL result = YES;
    NSString *text = MQ_SAFE_STRING(searchBar.text);
    if ([searchBar isFirstResponder] && [text isEqualToString:self.seachText]) {
        result = NO;
    }else{
        result = [super searchBarShouldBeginEditing:searchBar];
    }
    return result;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!CHECK_VALID_STRING(self.searchTextField.text)) {
        self.tableView.hidden = YES;
        self.hidden = NO;
    }else{
        self.tableView.hidden = NO;
        self.hidden = YES;
    }
    self.currentPage = 1;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        return [UITableViewCell new];
        
    }else{
        return [UITableViewCell new];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableView){
        return self.cDataArray.count;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        return 100.f;
    }
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView == self.tableView){
     
    }
    
}

- (void)requestIndex
{
    [self requestData];
}

- (void)requestData
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];

    [self initKeyWordData];
    [self.tableView reloadData];
}


- (void)requestSearchKey:(NSString *)keyWord
{
    if (!CHECK_VALID_STRING(keyWord)) {
        return;
    }
    
}

- (void)requestSearch:(NSString *)keyWord
{
    if (!CHECK_VALID_STRING(keyWord)) {
        return;
    }
    
}

@end

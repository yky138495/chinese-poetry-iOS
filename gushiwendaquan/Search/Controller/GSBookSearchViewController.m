//
//  GSBookSearchViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSBookSearchViewController.h"
#import "LLSegmentBarVC.h"
#import "GSSongshiDBService.h"
#import "GSTangshiDBService.h"
#import "GSSongciDBService.h"
#import "GSTxtModel.h"
#import "GSTxtViewViewController.h"

@interface GSBookSearchViewController ()

@property (nonatomic, strong) NSMutableArray *cDataArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL hasData;

@property (nonatomic, copy) NSArray *keyWordArray;
@property (nonatomic, copy) NSArray *pullDownArray;
@property (nonatomic, copy) NSString *seachText;

@property (nonatomic, strong) GSTxtModel *readItem;
@property (nonatomic, assign) NSUInteger tagType;

@end

@implementation GSBookSearchViewController

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
}

//获取一个随机整数，范围在[from,to）
-(NSUInteger)getRandomNumber:(NSUInteger)from to:(NSUInteger)to
{
    return (NSUInteger)(from + (arc4random() % (to - from + 1)));
}

- (void)initKeyWordData
{
    NSUInteger tag = [self getRandomNumber:0 to:3];
    _tagType = tag;
    NSArray *array;
    if (tag == 0) {
        array = [GSTangshiDBService sharedInstance].getAllAuthor;
    }else if (tag == 1) {
        array = [GSSongshiDBService sharedInstance].getAllAuthor;
    }else{
        array = [GSSongciDBService sharedInstance].getAllAuthor;
    }
    
    NSMutableArray *hotSeaches = [NSMutableArray array];
    for (NSUInteger i= 0 ; i< 30 ;i ++) {
        NSUInteger tag = [self getRandomNumber:0 to:(array.count -1)];
        Author *author = [array safeObjectAtIndex:tag];
        if (CHECK_VALID_STRING(author.name)) {
            [hotSeaches addObject:author.name];
        }
    }
    self.searchTextField.placeholder = @"关键词、作者";
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
//    [self requestSearchKey:text];
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
    if (self.tableView.hidden == NO && CHECK_VALID_STRING(text)) {
        return YES;
    }
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
        static NSString *cellID = @"PYReadRecordCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }
        
        self.readItem = [self.cDataArray safeObjectAtIndex:indexPath.section];
        cell.textLabel.text = self.readItem.title;
        cell.detailTextLabel.text = self.readItem.author;
        return cell;
        
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
        return 50.f;
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
        GSTxtModel *readItem = [self.cDataArray safeObjectAtIndex:indexPath.section];
        GSTxtViewViewController *txtViewViewController = [[GSTxtViewViewController alloc]init];
        txtViewViewController.txtModel = readItem;
        txtViewViewController.seachText = self.seachText;
        [self.navigationController pushViewController:txtViewViewController animated:YES];
       
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

- (BOOL)boolIsAuthor:(NSString *)keyWord
{
    BOOL isAuthor = NO;
    Author * author;
    NSMutableArray *modelArray = [NSMutableArray array];
    if (_tagType == 0) {
        author = [[GSTangshiDBService sharedInstance]getAuthorByName:keyWord];
    }else if (_tagType == 1) {
        author = [[GSSongshiDBService sharedInstance]getAuthorByName:keyWord];
    }else if (_tagType == 2) {
        author = [[GSSongciDBService sharedInstance]getAuthorByName:keyWord];
    }
    if (CHECK_VALID_STRING(author.name)) {
        [modelArray addObjectsFromArray:[self searchName:keyWord]];
        [self.cDataArray removeAllObjects];
        [self.cDataArray addObjectsFromArray:[modelArray copy]];
        [SVProgressHUD dismiss];

        [self.tableView reloadData];
        isAuthor = YES;
    }
    return isAuthor;
}

- (void)requestSearch:(NSString *)keyWord
{
    if (!CHECK_VALID_STRING(keyWord)) {
        return;
    }
    [SVProgressHUD show];

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    NSArray *array;
    NSMutableArray *modelArray = [NSMutableArray array];
    if ([self boolIsAuthor:keyWord]) {
        return;
    }
    
    Author * author;
    author = [[GSTangshiDBService sharedInstance]getAuthorByName:keyWord];

    if (CHECK_VALID_STRING(author.name)) {
        _tagType = 0;
        [modelArray addObjectsFromArray:[self searchName:keyWord]];
    }else{
        author = [[GSSongshiDBService sharedInstance]getAuthorByName:keyWord];
        if (CHECK_VALID_STRING(author.name)) {
            _tagType = 1;
            [modelArray addObjectsFromArray:[self searchName:keyWord]];
        }else{
            author = [[GSSongciDBService sharedInstance]getAuthorByName:keyWord];
            if (CHECK_VALID_STRING(author.name)) {
                _tagType = 2;
                [modelArray addObjectsFromArray:[self searchName:keyWord]];
            }else{
                
            }
        }
    }
    
    if (CHECK_VALID_STRING(author.name)) {
        [self.cDataArray removeAllObjects];
        [self.cDataArray addObjectsFromArray:[modelArray copy]];
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        return;
    }
   
    array = [[GSTangshiDBService sharedInstance]getTangshiByKey:keyWord];
    if CHECK_VALID_ARRAY(array){
        _tagType = 0;
        for (TangShi *tangShi in array) {
            GSTxtModel *modle = [GSTxtModel new];
            modle.title = tangShi.title;
            modle.author = tangShi.author;
            modle.content = tangShi.content;
            [modelArray addObject:modle];
        }
    }else{
        array = [[GSSongshiDBService sharedInstance]getSongshiByKey:keyWord];
        if CHECK_VALID_ARRAY(array){
            _tagType = 1;
            for (TangShi *tangShi in array) {
                GSTxtModel *modle = [GSTxtModel new];
                modle.title = tangShi.title;
                modle.author = tangShi.author;
                modle.content = tangShi.content;
                [modelArray addObject:modle];
            }
        }else{
            array = [[GSSongciDBService sharedInstance]getSongciByKey:keyWord];
            if CHECK_VALID_ARRAY(array){
                _tagType = 2;
                for (Songci *songci in array) {
                    GSTxtModel *modle = [GSTxtModel new];
                    modle.title = songci.rhythmic;
                    modle.author = songci.author;
                    modle.content = songci.content;
                    [modelArray addObject:modle];
                }
            }
        }
    }

    [self.cDataArray removeAllObjects];
    [self.cDataArray addObjectsFromArray:[modelArray copy]];
 
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

- (NSArray *)searchName:(NSString *)name
{
    if (!CHECK_VALID_STRING(name)) {
        return @[];
    }
    //0-57000  1000步进
    NSMutableArray *modelArray = [NSMutableArray array];
    if (_tagType == 0) {
        NSArray *array =  [[GSTangshiDBService sharedInstance] getTangshiByName:name];
        for (TangShi *tangShi in array) {
            GSTxtModel *modle = [GSTxtModel new];
            modle.title = tangShi.title;
            modle.author = tangShi.author;
            modle.content = tangShi.content;
            [modelArray addObject:modle];
        }
        return modelArray;
        //0-254000  1000步进
    }else if (_tagType == 1) {
        NSArray *array =  [[GSSongshiDBService sharedInstance] getSongshiByName:name];
        for (TangShi *tangShi in array) {
            GSTxtModel *modle = [GSTxtModel new];
            modle.title = tangShi.title;
            modle.author = tangShi.author;
            modle.content = tangShi.content;
            [modelArray addObject:modle];
        }
        return modelArray;
        //0-21000  1000步进
    }else {
        NSArray *array =  [[GSSongciDBService sharedInstance] getSongciByName:name];
        for (Songci *songci in array) {
            GSTxtModel *modle = [GSTxtModel new];
            modle.title = songci.rhythmic;
            modle.author = songci.author;
            modle.content = songci.content;
            [modelArray addObject:modle];
        }
        return modelArray;
    }
    return @[];
}

@end


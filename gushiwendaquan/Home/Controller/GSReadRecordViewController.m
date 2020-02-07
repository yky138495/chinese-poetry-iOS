//
//  GSReadRecordViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/22.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSReadRecordViewController.h"
#import "GSSaveDBService.h"
#import "GSTxtViewViewController.h"

#import "GSTxtModel.h"

@interface GSReadRecordViewController ()

@property (nonatomic, strong) NSMutableArray *cDataArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL hasData;

@property (nonatomic, strong) GSTxtModel *readItem;

@end

@implementation GSReadRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.type == GSReadRecordViewControllerTypeRead){
        self.title = @"阅读记录";
    }else{
        self.title = @"我的收藏";
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cDataArray = [NSMutableArray array];
    self.currentPage = 1;
    self.hasData = YES;
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self requestIndex];
    }];
    
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        if (self.hasData) {
    //            self.currentPage ++;
    //            [self requestIndex];
    //        }else{
    //            [self.tableView.mj_footer endRefreshingWithNoMoreData]; //无更多数据
    //        }
    //    }];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    static NSString *cellID = @"PYReadRecordCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:15];
        cell.detailTextLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:12];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = MQ_COLORWITHCODE(@"#F3F5F7");
        [cell addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell);
            make.left.right.equalTo(cell);
            make.height.equalTo(@1);
        }];
    }
    
    self.readItem = [self.cDataArray safeObjectAtIndex:indexPath.section];
    cell.textLabel.text = self.readItem.title;
    cell.detailTextLabel.text = self.readItem.author;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
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
    GSTxtModel *readItem = [self.cDataArray safeObjectAtIndex:indexPath.section];
    
    GSTxtViewViewController *txtViewViewController = [[GSTxtViewViewController alloc]init];
    txtViewViewController.txtModel = readItem;
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
    if(self.type == GSReadRecordViewControllerTypeRead){
       NSArray *array = [[GSSaveDBService sharedInstance]getAllRecord];
        self.cDataArray = [array copy];
    }else{
        NSArray *array = [[GSSaveDBService sharedInstance]getAllSave];
        self.cDataArray = [array copy];
    }
    if (!CHECK_VALID_ARRAY(self.cDataArray)) {
        self.tableView.tableFooterView = [self creatNoDataScreenView];
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
    [self setRefreshed];
    [self.tableView reloadData];
}

@end

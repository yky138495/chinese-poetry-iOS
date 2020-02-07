//
//  GSMeViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSMeViewController.h"

#import "MQMeTopCell.h"
#import "MQMeCenterCell.h"
#import "GSReadRecordViewController.h"

@interface GSMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GSMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static  NSString  *cellIdentiferId = @"MQMeTopCellIdentifer";
        MQMeTopCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferId];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MQMeTopCell" owner:nil options:nil];
            cell = (MQMeTopCell *)[nibs lastObject];
        };
        
        return cell;
    }else {
        static  NSString  *cellIdentiferId = @"MQMeCenterCellIdentifer";
        MQMeCenterCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferId];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MQMeCenterCell" owner:nil options:nil];
            cell = (MQMeCenterCell *)[nibs lastObject];
            cell.title.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:15];
        };
        if (indexPath.row == 0) {
            cell.vImageView.image = [UIImage imageNamed:@"read_information.png"];
            cell.title.text = @"阅读记录";
        }else if (indexPath.row == 1) {
            cell.vImageView.image = [UIImage imageNamed:@"read_information2.png"];
            cell.vImageView.size = CGSizeMake(18, 18);
            cell.title.text = @"我的收藏";
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70.f ;
    }else if (indexPath.section == 1) {
        return 60.f;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
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
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GSReadRecordViewController *readRecordViewController = [[GSReadRecordViewController alloc]init];
            readRecordViewController.type = GSReadRecordViewControllerTypeRead;
            [self.navigationController pushViewController:readRecordViewController animated:YES];
        }else if (indexPath.row == 1) {
            GSReadRecordViewController *readRecordViewController = [[GSReadRecordViewController alloc]init];
            readRecordViewController.type = GSReadRecordViewControllerTypeSave;
            [self.navigationController pushViewController:readRecordViewController animated:YES];
        }
    }else if (indexPath.section == 2) {
        
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
    
}


@end

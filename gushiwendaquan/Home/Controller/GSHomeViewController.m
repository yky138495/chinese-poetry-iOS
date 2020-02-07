//
//  GSHomeViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSHomeViewController.h"
#import "GSTxtViewViewController.h"
#import "GSAuthViewViewController.h"
#import "GSBookSearchViewController.h"
#import "GSTxtViewOneViewController.h"

#import "chinesepoetryUtil.h"
#import "Daxue.h"
#import "Author.h"
#import "Shijing.h"


@interface GSHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation GSHomeViewController

/*
POPSpringAnimation (弹簧效果)
POPDecayAnimation (衰减效果)
POPBasicAnimation (基本动画)
POPAnimatableProperty (自定义属性动画)
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.title = @"古诗文";
    self.dataArray = @[
                       @"唐诗",
                       @"宋诗",
                       @"宋词",
                       @"论语",
                       @"诗经",
                       @"大学",
                       @"其他",
                       ];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewIdentifier"];
    self.navigationItem.rightBarButtonItem = [self searchButtonItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addAnimInCollection];
}

- (void)addAnimInCollection
{
    UICollectionView *collectionView  = self.collectionView;
//    self.view.userInteractionEnabled = NO;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x - 10, collectionView.center.y)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, collectionView.center.y)];
    anim.springSpeed = 3.f;
    anim.springBounciness = 8.f;
    anim.dynamicsMass = 5;
    anim.beginTime = CACurrentMediaTime() + 0.1f;
//    [anim setCompletionBlock:^(POPAnimation * animation, BOOL flag) {
//        self.view.userInteractionEnabled = true;
//    }];
    [collectionView pop_addAnimation:anim forKey:@"ScaleX"];
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


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewIdentifier" forIndexPath:indexPath];
    if (cell){
        
    }
    
    // 设置圆角
    cell.layer.cornerRadius = 3.0;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = MQ_COLOR_FONT_DARK.CGColor;
    cell.layer.borderWidth = 1.f;
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = GSRandomColor;
    UILabel *topLabel = [UILabel new];
    topLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:38.f];

    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.text = [self.dataArray safeObjectAtIndex:indexPath.row];
    topLabel.numberOfLines = 1;
    [cell addSubview:topLabel];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell);
    }];

    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        GSAuthViewViewController *authViewViewController = [[GSAuthViewViewController alloc]init];
        
        authViewViewController.type = GSAuthViewViewControllerTypeTang;
        NSString *sishuStr = [chinesepoetryUtil sharedInstance].authorstang;
        NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
        NSArray *riskArry = [Author mj_objectArrayWithKeyValuesArray:json];
        authViewViewController.title = @"唐诗";
        authViewViewController.dataArray = riskArry;
        [self.navigationController pushViewController:authViewViewController animated:YES];
    }else if (indexPath.row == 1) {
        GSAuthViewViewController *authViewViewController = [[GSAuthViewViewController alloc]init];
        authViewViewController.type = GSAuthViewViewControllerTypeSongshi;
        NSString *sishuStr = [chinesepoetryUtil sharedInstance].authorssong;
        NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
        NSArray *riskArry = [Author mj_objectArrayWithKeyValuesArray:json];
        authViewViewController.title = @"宋诗";
        authViewViewController.dataArray = riskArry;

        [self.navigationController pushViewController:authViewViewController animated:YES];
        
    }else if (indexPath.row == 2) {
        GSAuthViewViewController *authViewViewController = [[GSAuthViewViewController alloc]init];
        authViewViewController.type = GSAuthViewViewControllerTypeSong;
        
        NSString *sishuStr = [chinesepoetryUtil sharedInstance].songciauthor;
        NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
        NSArray *riskArry = [Author mj_objectArrayWithKeyValuesArray:json];
        authViewViewController.title = @"宋词";
        authViewViewController.dataArray = riskArry;
        [self.navigationController pushViewController:authViewViewController animated:YES];
    }
    else if (indexPath.row == 3) {
        GSTxtViewOneViewController *txtViewViewController = [[GSTxtViewOneViewController alloc]init];
        
        NSString *sishuStr = [chinesepoetryUtil sharedInstance].luyuStr;
        NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
        NSArray *riskArry = [Daxue mj_objectArrayWithKeyValuesArray:json];
        txtViewViewController.title = @"论语";
        txtViewViewController.lunyuArray = riskArry;
        [self.navigationController pushViewController:txtViewViewController animated:YES];
    }
    
    else if (indexPath.row == 4) {
        GSTxtViewOneViewController *txtViewViewController = [[GSTxtViewOneViewController alloc]init];
        
        NSString *sishuStr = [chinesepoetryUtil sharedInstance].shijingStr;
        NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
        NSArray *riskArry = [Shijing mj_objectArrayWithKeyValuesArray:json];
        txtViewViewController.title = @"诗经";
        txtViewViewController.shijingArray= riskArry;
        [self.navigationController pushViewController:txtViewViewController animated:YES];
    }
    
    else if (indexPath.row == 5) {
        GSTxtViewOneViewController *txtViewViewController = [[GSTxtViewOneViewController alloc]init];
        
        NSString *sishuStr = [chinesepoetryUtil sharedInstance].sishuStr;
        NSString *sishuStrPath = [[NSBundle mainBundle] pathForResource:sishuStr ofType:nil];
         NSError *error;
         NSString *jsonString = [NSString stringWithContentsOfFile:sishuStrPath encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *json = [NSDictionary dictionaryWithJsonString:jsonString];
        Daxue *riskArry = [Daxue mj_objectWithKeyValues:json];
        txtViewViewController.title = @"大学";

        txtViewViewController.daxueReal = riskArry;
        [self.navigationController pushViewController:txtViewViewController animated:YES];
    }
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREEN_WIDTH - 40)/2,(SCREEN_HEIGHT - MQ_NavBarHeight - BottomSafeHeight - TabbarHeight - 80)/3};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 0, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


@end

//
//  GSChaCiDianViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/22.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSChaCiDianViewController.h"
#import "AXWebViewController.h"

@interface GSChaCiDianViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@end


@implementation GSChaCiDianViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.delegate = self;
    self.title = @"词典";
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewIdentifier"];
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
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x - 6, collectionView.center.y)];
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

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewIdentifier" forIndexPath:indexPath];
    if (cell) {
        [cell removeAllSubviews];
    }
    // 设置圆角
    cell.layer.cornerRadius = 3.0;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = MQ_COLOR_FONT_DARK.CGColor;
    cell.layer.borderWidth = 1.f;
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = GSRandomColor;
  
    UILabel *topLabel = [UILabel new];
    topLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:38];

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
    NSString *word = [self.dataArray safeObjectAtIndex:indexPath.row];
    NSString *string2 =  [NSString stringWithFormat:@"https://dict.baidu.com/s?wd=%@",word];
    NSString* urlStr = [string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *urlStr = [string2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:urlStr];
    webVC.showsToolBar = YES;
    //用微信样式导航
//    webVC.navigationType = AXWebViewControllerNavigationBarItem;

    webVC.navigationController.navigationBar.translucent = NO;
    [self.navigationController pushViewController:webVC animated:YES];
    
//    MQWebViewController *wController = [[MQWebViewController alloc] init];
//    wController.url = @"";
//    [self.navigationController pushViewController:wController animated:YES];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREEN_WIDTH - 10)/5,(SCREEN_WIDTH - 10)/5};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}



@end

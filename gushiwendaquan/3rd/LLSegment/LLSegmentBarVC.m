
#import "LLSegmentBarVC.h"
#import "UIView+LLSegmentBar.h"

@interface LLSegmentBarVC ()<LLSegmentBarDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,assign) BOOL use;

@end

@implementation LLSegmentBarVC

- (LLSegmentBar *)segmentBar{
    if (!_segmentBar) {
        LLSegmentBar *segmentBar = [LLSegmentBar segmentBarWithFrame:self.view.bounds];
        segmentBar.delegate = self;
        segmentBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:segmentBar];
        _segmentBar = segmentBar;
    }
    return _segmentBar;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.delegate = self;
        contentView.pagingEnabled = YES;
        contentView.showsHorizontalScrollIndicator = NO;
        [self.view insertSubview:contentView belowSubview:self.segmentBar];
        _contentView = contentView;
    }
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs isUseBarHeight:(BOOL)use
{
    NSAssert(items.count != 0 || items.count == childVCs.count, @"个数不一致, 请自己检查");
    self.use = use;
    self.segmentBar.items = items;
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    for (UIViewController *vc in childVCs) {
        [self addChildViewController:vc];
    }
    self.contentView.contentSize = CGSizeMake(items.count * self.view.width, 0);
    self.segmentBar.selectIndex = 0;
}

- (void)setUpWithItems:(NSArray<NSString *> *)items childVCs:(NSArray<UIViewController *> *)childVCs{
    [self setUpWithItems:items childVCs:childVCs isUseBarHeight:NO];
}

- (void)showChildVCViewAtIndex:(NSInteger)index{
    if (self.childViewControllers.count == 0 || index < 0 || index > self.childViewControllers.count - 1) {
        return;
    }
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index * self.contentView.width, 0, self.contentView.width, self.contentView.height);
    [self.contentView addSubview:vc.view];
    // 滑动到对应位置
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.width, 0) animated:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (self.segmentBar.superview == self.view) {
        self.segmentBar.frame = CGRectMake(0, 0, self.contentView.width, 50);
        CGFloat contentViewY = self.segmentBar.y + self.segmentBar.height;
        if (self.use) {
            contentViewY = 0;
        }
        CGRect contentFrame = CGRectMake(0, contentViewY, self.view.width, self.view.height - contentViewY);
        self.contentView.frame = contentFrame;
        self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
        return;
    }
    CGRect contentFrame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.contentView.frame = contentFrame;
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    self.segmentBar.selectIndex = self.segmentBar.selectIndex;
}
#pragma mark - LLSegmentBarDelegate
- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex{
    if (self.segmentBarVCIndex) {
        self.segmentBarVCIndex (toIndex);
    }
    [self showChildVCViewAtIndex:toIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = self.contentView.contentOffset.x/self.contentView.width;
    self.segmentBar.selectIndex = index;
}


@end

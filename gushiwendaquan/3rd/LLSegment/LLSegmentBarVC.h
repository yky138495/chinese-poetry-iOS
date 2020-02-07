

#import <UIKit/UIKit.h>
#import "LLSegmentBar.h"

@interface LLSegmentBarVC : UIViewController

typedef void(^LLSegmentBarVCIndex)(NSInteger index);

@property (nonatomic,weak) LLSegmentBar * segmentBar;
@property (nonatomic,copy) LLSegmentBarVCIndex segmentBarVCIndex;

- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs;

- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs isUseBarHeight:(BOOL)use;

@end

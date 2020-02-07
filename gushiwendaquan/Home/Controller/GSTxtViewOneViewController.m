//
//  GSTxtViewViewController.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "GSTxtViewOneViewController.h"
#import "TangShi.h"
#import "Songci.h"
#import "Daxue.h"
#import "Shijing.h"
#import "GSBookSearchViewController.h"
#import "GSAuthorInfoViewController.h"
#import "GSChaCiDianViewController.h"
#import "GSSaveDBService.h"
#import "GSTxtModel.h"
#import<StoreKit/StoreKit.h>

@interface GSTxtViewOneViewController ()<UIActionSheetDelegate>

@property (nonatomic, copy) NSString *simpleCh;
@property (nonatomic, copy) NSString *fanCh;

@property (nonatomic, copy) NSString *titlesimple;
@property (nonatomic, copy) NSString *titleFan;

@property (nonatomic, copy) NSString *authorimple;
@property (nonatomic, copy) NSString *authorFan;

@property (nonatomic, assign) BOOL isFan;
@property (nonatomic, strong) TangShi *tangShi;
@property (nonatomic, strong) Songci *songCi;
@property (nonatomic, strong) Daxue *daxue;
@property (nonatomic, strong) Shijing *shijing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;


@end

@implementation GSTxtViewOneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txt.editable = NO;
   
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 3.f;
    self.saveButton.layer.borderColor = [UIColor colorWithHexString:@"#75BDF3"].CGColor;
    self.saveButton.layer.borderWidth = 1.f;
    
    self.fanButton.layer.masksToBounds = YES;
    self.fanButton.layer.cornerRadius = 3.f;
    self.fanButton.layer.borderColor = [UIColor colorWithHexString:@"#75BDF3"].CGColor;
    self.fanButton.layer.borderWidth = 1.f;
    
    self.cidianbutton.layer.masksToBounds = YES;
    self.cidianbutton.layer.cornerRadius = 3.f;
    self.cidianbutton.layer.borderColor = [UIColor colorWithHexString:@"#75BDF3"].CGColor;
    self.cidianbutton.layer.borderWidth = 1.f;
    
//    self.txt.userInteractionEnabled = NO;
    self.txt.scrollEnabled = YES;
//    [self.txt setContentOffset:CGPointZero animated:NO];
    CGPoint offset = self.txt.contentOffset;
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        [self.txt setContentOffset:offset];
    }];
    
    self.txt.showsVerticalScrollIndicator = NO;
    self.navigationItem.rightBarButtonItem = [self searchButtonItem];
    self.isFan = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
//    [self.txt addGestureRecognizer:tap];

    
    UITapGestureRecognizer *authorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorTapAction)];
    [self.autho addGestureRecognizer:authorTap];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown)];
//
    [self.view addGestureRecognizer:recognizer];
  
}

-(void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (IS_PhoneXAll) {
        _bottom.constant = 20;
    }else{
        _bottom.constant = 20;
    }
    [self addAnimIn];
}

- (void)addAnimIn
{
    [self addAnimInTitleLabel];
    [self addAnimInAuthorLabel];
    [self addAnimInTextLabel];
}

- (void)addAnimInTitleLabel
{
    UILabel *titleLabel  = self.titleLabel;

    /*
     kCAMediaTimingFunctionLinear －－－ 线性动画
     kCAMediaTimingFunctionEaseIn －－－ 淡入
     kCAMediaTimingFunctionEaseOut －－－ 淡出
     kCAMediaTimingFunctionEaseInEaseOut －－－ 先淡入再淡出
     */
    //    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    //    anBasic.fromValue = @(0);
    //    anBasic.toValue = @(titleLabel.frame.origin.x);
    //    anBasic.beginTime = CACurrentMediaTime() + 0.5f;
    //    anBasic.duration = 0.4f;
    //    anBasic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    self.view.userInteractionEnabled = NO;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    // 2.设置初始值和变化后的值
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x - 30, titleLabel.center.y)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, titleLabel.center.y)];
    //    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 150)];
    // 速度 可以设置的范围是0-20，默认为12.值越大速度越快，结束的越快
    anim.springSpeed = 3.f;
    // 振幅 可以设置的范围是0-20，默认为4。值越大振动的幅度越大
    anim.springBounciness = 8.f;
    // 拉力 拉力越大，动画的速度越快，结束的越快。 接下来的三个值一般不用设置，可以分别放开注释查看效果
    //  anim.dynamicsTension = 250;
    // 摩擦力 摩擦力越大，动画的速度越慢，振动的幅度越小。
    //      anim.dynamicsFriction = 100.0;
    // 质量 质量越大，动画的速度越慢，振动的幅度越大，结束的越慢
    anim.dynamicsMass = 5;
    anim.beginTime = CACurrentMediaTime() ;
    // 3.添加到view上
//    [anim setCompletionBlock:^(POPAnimation * animation, BOOL flag) {
//        self.view.userInteractionEnabled = true;
//    }];
    [titleLabel pop_addAnimation:anim forKey:@"ScaleX"];
}

- (void)addAnimInAuthorLabel
{
    UILabel *authoLabel  = self.autho;
//    self.view.userInteractionEnabled = NO;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x - 15, authoLabel.center.y)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, authoLabel.center.y)];
    anim.springSpeed = 3.f;
    anim.springBounciness = 8.f;
    anim.dynamicsMass = 5;
    anim.beginTime = CACurrentMediaTime() + 0.2f;
//    [anim setCompletionBlock:^(POPAnimation * animation, BOOL flag) {
//        self.view.userInteractionEnabled = true;
//    }];
    [authoLabel pop_addAnimation:anim forKey:@"ScaleX"];
}

- (void)addAnimInTextLabel
{
    UITextView *textView  = self.txt;
//    self.view.userInteractionEnabled = NO;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x - 10, textView.center.y)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, textView.center.y)];
    anim.springSpeed = 3.f;
    anim.springBounciness = 8.f;
    anim.dynamicsMass = 5;
    anim.beginTime = CACurrentMediaTime() + 0.1f;
//    [anim setCompletionBlock:^(POPAnimation * animation, BOOL flag) {
//        self.view.userInteractionEnabled = true;
//    }];
    [textView pop_addAnimation:anim forKey:@"ScaleX"];
}

- (void)addAnimOut
{
    return;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self randDataAll];
    //如果往左滑
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)tapAction
{
    [self addAnimOut];
    [self randDataAll];
    [self addAnimIn];
}

- (void)authorTapAction
{
    GSAuthorInfoViewController *authorInfoViewController = [[GSAuthorInfoViewController alloc]init];
    authorInfoViewController.title = self.authorFan;
    [self.navigationController pushViewController:authorInfoViewController animated:YES];
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

- (IBAction)fanButtonAction:(id)sender
{
    self.isFan = !self.isFan;
}

-(void)setIsFan:(BOOL)isFan
{
    _isFan = isFan;
    if (isFan) {
        self.txt.text = [self.fanCh copy];
        self.titleLabel.text = self.titleFan;
        self.autho.text = self.authorFan;
        [self.fanButton setTitle:@"简体" forState:UIControlStateNormal];
        CGFloat height = self.txt.contentSize.height;
        if (self.txt.frame.size.height < height) {
            self.txt.userInteractionEnabled = YES;
        }else{
            self.txt.userInteractionEnabled = NO;
        }
    }else{

        self.txt.text = [self.simpleCh copy];
        self.titleLabel.text = self.titlesimple;
        self.autho.text = self.authorimple;
        [self.fanButton setTitle:@"繁体" forState:UIControlStateNormal];
        GSTxtModel *txtModel = [[GSTxtModel alloc]init];
        txtModel.title = self.titlesimple;
        txtModel.author = self.authorimple;
        txtModel.content = self.simpleCh;
        
        [[GSSaveDBService sharedInstance]insertRecordWithModel:txtModel];
        [self addAppReview];
        CGFloat height = self.txt.contentSize.height;
        if (self.txt.frame.size.height < height) {
            self.txt.userInteractionEnabled = YES;
        }else{
            self.txt.userInteractionEnabled = NO;
        }
    }
}



- (IBAction)saveAction:(id)sender
{
    [self actionClick];
}

-(NSArray *)getSubString:(NSString*)str
{
    NSMutableArray *textArray = [NSMutableArray array];
    for (NSInteger i = 0; i < str.length; i++) {
        NSRange range =  NSMakeRange(i, 1);
        NSString *subStr = [str substringWithRange:range];
        if ([MQStringUtil isChinese:subStr]) {
            [textArray addObject:subStr];
        }
    }
    return textArray;
}

- (IBAction)cidianAction:(id)sender
{
    NSString *title =  MQ_SAFE_STRING(self.titlesimple);
    NSString *content =  MQ_SAFE_STRING(self.simpleCh);
    NSString *author =  MQ_SAFE_STRING(self.authorimple);
    
    NSArray  *titleArray = [self getSubString:title];
    NSArray  *contentArray = [self getSubString:content];
    NSArray  *authorArray = [self getSubString:author];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:titleArray];
    [array addObjectsFromArray:authorArray];
    [array addObjectsFromArray:contentArray];
    
    GSChaCiDianViewController *chaCiDianViewController = [[GSChaCiDianViewController alloc]init];
    chaCiDianViewController.dataArray = [array copy];
    [self.navigationController pushViewController:chaCiDianViewController animated:YES];
}

-(void)setTxtModel:(GSTxtModel *)txtModel
{
    _txtModel = txtModel;
    self.simpleCh = txtModel.content;
    self.fanCh = [self.simpleCh fg_reversed];
    
    self.titlesimple = MQ_SAFE_STRING(txtModel.title);
    self.titleFan = [self.titlesimple fg_reversed];
    
    self.authorimple = MQ_SAFE_STRING(txtModel.author);
    self.authorFan = [self.authorimple fg_reversed];
    self.isFan = NO;
    
}

-(void)setDaxueReal:(Daxue *)daxueReal
{
    _daxueReal = daxueReal;
    NSMutableString *mutalbleStr = [NSMutableString string];
    for (NSString *str in daxueReal.paragraphs) {
        [mutalbleStr appendString:str];
        [mutalbleStr appendString:@"\n"];
        [mutalbleStr appendString:@"\n"];
    }
    NSString *simpleCh = [mutalbleStr fg_reversed];
    self.simpleCh = simpleCh;
    self.fanCh = mutalbleStr;
    self.titlesimple = @"大学";
    self.titleFan = [MQ_SAFE_STRING(self.titlesimple) fg_reversed];
    
    self.authorimple = @"";
    self.authorFan = [MQ_SAFE_STRING(self.authorimple) fg_reversed];
    self.isFan = NO;
}


- (void)setLunyuArray:(NSArray *)lunyuArray
{
    _lunyuArray = lunyuArray;
    if (CHECK_VALID_ARRAY(lunyuArray)){
        [self randLunyuData];
    }
}

-(void)setShijingArray:(NSArray *)shijingArray
{
    _shijingArray = shijingArray;
    if (CHECK_VALID_ARRAY(shijingArray)){
        [self randShijingData];
    }
}

- (void)randDataAll
{
    [self addAnimOut];
    
    if (CHECK_VALID_ARRAY(_shijingArray)){
        [self randShijingData];
    }
    if (CHECK_VALID_ARRAY(_lunyuArray)){
        [self randLunyuData];
    }
   
    [self addAnimIn];
}


- (void)randLunyuData
{
    NSUInteger tag = [self getRandomNumber:0 to:(_lunyuArray.count - 1)];
    self.daxue = [_lunyuArray safeObjectAtIndex:tag];
    self.titleLabel.text = self.daxue.chapter;
    NSMutableString *mutalbleStr = [NSMutableString string];
    for (NSString *str in self.daxue.paragraphs) {
        [mutalbleStr appendString:str];
        [mutalbleStr appendString:@"\n"];
        [mutalbleStr appendString:@"\n"];
    }
    NSString *simpleCh = [mutalbleStr fg_reversed];
    self.simpleCh = simpleCh;
    self.fanCh = mutalbleStr;
    
    self.titleFan = self.daxue.chapter;
    self.titlesimple = [MQ_SAFE_STRING(self.daxue.chapter) fg_reversed];
    
    self.authorFan = @"";
    self.authorimple = @"";
    self.isFan = NO;
    
}

- (void)randShijingData
{
    NSUInteger tag = [self getRandomNumber:0 to:(_shijingArray.count - 1)];
    self.shijing = [_shijingArray safeObjectAtIndex:tag];
    self.titleLabel.text = self.shijing.title;
    NSMutableString *mutalbleStr = [NSMutableString string];
    for (NSString *str in self.shijing.paragraphs) {
        [mutalbleStr appendString:str];
        [mutalbleStr appendString:@"\n"];
        [mutalbleStr appendString:@"\n"];
    }
    NSString *simpleCh = [mutalbleStr fg_reversed];
    self.fanCh = simpleCh;
    self.simpleCh = mutalbleStr;
    
    self.titleFan = self.shijing.title;
    self.titlesimple = [MQ_SAFE_STRING(self.shijing.title) fg_reversed];
    
    NSString *autho = [NSString stringWithFormat:@"%@-%@",MQ_SAFE_STRING(self.shijing.chapter),MQ_SAFE_STRING(self.shijing.section)];
    self.authorimple = autho;
    self.authorFan = [MQ_SAFE_STRING(autho) fg_reversed];
    self.isFan = NO;
    
}
//获取一个随机整数，范围在[from,to），包括from，不包括to
-(NSUInteger)getRandomNumber:(NSUInteger)from to:(NSUInteger)to
{
    return (NSUInteger)(from + (arc4random() % (to - from + 1)));
}

- (void)actionClick
{
    UIActionSheet *tradeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
    tradeSheet.tag = 1000;
    [tradeSheet showInView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        switch (buttonIndex) {
            case 0: {
                [self savePhoto];
                [self.view makeToast:@"保存相册成功" duration:1.f position:CSToastPositionCenter];
            }
                break;
            default:
                break;
        }
    
}

- (void)saveDB
{
    GSTxtModel *txtModel = [[GSTxtModel alloc]init];
    txtModel.title = self.titlesimple;
    txtModel.author = self.authorimple;
    txtModel.content = self.simpleCh;
    
    [[GSSaveDBService sharedInstance]insertSaveWithModel:txtModel];
}

// 保存图片到相册功能，ALAssetsLibraryiOS9.0 以后用photoliabary 替代，
-(void)savePhoto
{
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;

    UIImage * image = [self screenShotWithFrame:CGSizeMake(w, h)];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);//把图片保存在本地
}

- (UIImage *)screenShot
{
    return [self screenShotWithFrame:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
}

////截图功能 清晰
- (UIImage *)screenShotWithFrame:(CGSize)imageRect
{
    UIGraphicsBeginImageContextWithOptions(imageRect, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}

//截图功能 模糊
-(UIImage *)captureImageFromView:(UIView *)view
{
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSData *)screenClip:(UIImage *)image
{
    NSData *imageViewData = UIImagePNGRepresentation(image);
    return imageViewData;
}


- (void)addAppReview
{
    NSString *strisAppReview =  [[NSUserDefaults standardUserDefaults] objectForKey:@"isAppReview"];
    if (!strisAppReview) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isAppReview"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (strisAppReview.integerValue == 1) {
        return;
    }
    //存储第一次触发saas
    NSString *str =  [[NSUserDefaults standardUserDefaults] objectForKey:@"addAppReview"];
    NSUInteger ttTag = str.integerValue;
    if (!str) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"addAppReview"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSArray *array = [[GSSaveDBService sharedInstance]getAllRecord];
    if (array.count != ttTag * 30) {
        return;
    }
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"喜欢APP么?给个五星好评吧亲!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //跳转APPStore 中应用的撰写评价页面
    UIAlertAction *review = [UIAlertAction actionWithTitle:@"我要吐槽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isAppReview"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"APPID"]];//换成你应用的 APPID
        CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
        if (version >= 10.0) {
            /// 大于等于10.0系统使用此openURL方法
            [[UIApplication sharedApplication] openURL:appReviewUrl options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:appReviewUrl];
        }
    }];
    __block NSUInteger aaT = ttTag;
    //不做任何操作
    UIAlertAction *noReview = [UIAlertAction actionWithTitle:@"用用再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        aaT = aaT + 1;
        NSString *sAt = [NSString stringWithFormat:@"%d",aaT];
        [[NSUserDefaults standardUserDefaults] setValue:sAt forKey:@"addAppReview"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [alertVC removeFromParentViewController];
    }];
    
    [alertVC addAction:review];
    [alertVC addAction:noReview];
    //判断系统,是否添加五星好评的入口
    if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
        UIAlertAction *fiveStar = [UIAlertAction actionWithTitle:@"五星好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isAppReview"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }];
        [alertVC addAction:fiveStar];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}

@end

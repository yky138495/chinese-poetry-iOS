//
//  GSChaCiDianViewController.h
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/22.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQBaseViewController.h"

@interface GSChaCiDianViewController : MQBaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *dataArray;

@end


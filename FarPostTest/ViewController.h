//
//  ViewController.h
//  FarPostTest
//
//  Created by Роман Есин on 29.01.2021.
//

#import <UIKit/UIKit.h>
#import "CellData.h"

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSCache<NSURL*, NSData*> *cache;
@property (strong, nonatomic) NSMutableArray<CellData *> *data;
@property (nonatomic) BOOL shouldUpdate;
@property (strong, nonatomic) UICollectionView *collectionView;

@end


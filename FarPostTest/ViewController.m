//
//  ViewController.m
//  FarPostTest
//
//  Created by Роман Есин on 29.01.2021.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self createURLs];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: [[UICollectionViewFlowLayout alloc] init]];
    [self.collectionView setAllowsSelection:YES];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.collectionView setBackgroundColor:UIColor.clearColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"reuseCell"];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshItems) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        [self.collectionView setRefreshControl: refresh];
    }

    [self.view addSubview:self.collectionView];

    [[self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    if (@available(iOS 11.0, *)) {
        [[self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor] setActive:YES];
        [[self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor] setActive:YES];
    } else {
        [[self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
        [[self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    }
    [[self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
}

- (void) clearAllData {
    // Clear cache
    [NSURLCache.sharedURLCache removeAllCachedResponses];
    // Clear collection view
    [self.data removeAllObjects];
    [self.collectionView reloadData];
}

/// Creates urls
- (void) createURLs {
    NSArray<NSString*> *urls = @[
        @"https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/golden-retriever-royalty-free-image-506756303-1560962726.jpg?crop=0.672xw:1.00xh;0.166xw,0&resize=640:*",
        @"https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=1.00xw:0.669xh;0,0.190xh&resize=1200:*",
        @"https://www.thesprucepets.com/thmb/sfuyyLvyUx636_Oq3Fw5_mt-PIc=/3760x2820/smart/filters:no_upscale()/adorable-white-pomeranian-puppy-spitz-921029690-5c8be25d46e0fb000172effe.jpg",
        @"https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/dog_cool_summer_slideshow/1800x1200_dog_cool_summer_other.jpg",
        @"https://media.nature.com/lw800/magazine-assets/d41586-020-01430-5/d41586-020-01430-5_17977552.jpg",
        @"https://s3.amazonaws.com/cdn-origin-etr.akc.org/wp-content/uploads/2017/11/20113314/Carolina-Dog-standing-outdoors.jpg",
    ];

    for (NSString *url in urls) {
        [self.data addObject:[[CellData alloc] initWithURL:url]];
    }

}

/// Refreshes al items
- (void) refreshItems {

    // Reload collection view
    [self clearAllData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [self createURLs];
        [self.collectionView reloadData];

        if (@available(iOS 10.0, *)) {
            [self.collectionView.refreshControl endRefreshing];
        }
    });
}

#pragma mark Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitle:@"FarPost"];

        self.data = [[NSMutableArray alloc] init];
        self.shouldUpdate = YES;

        if (@available(iOS 13.0, *)) {
            [[self view] setBackgroundColor:UIColor.systemBackgroundColor];
        } else {
            [[self view] setBackgroundColor:UIColor.whiteColor];
        }
    }
    return self;
}

#pragma mark CollectionView Delegate + DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"reuseCell" forIndexPath:indexPath];
    // Check if we already downloaded the image
    CellData *item = [self.data objectAtIndex:indexPath.row];
    UIImage *image = item.image;
    [cell.imageView setImage:image];

    if (image == nil && self.shouldUpdate) {
        // Download the image async in bg
        [cell.activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
            [cell downloadImage:item.url completion:^(UIImage *img) {
                item.image = img;

                // Animate image change
                [cell.imageView setImage:img];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.4f;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;

                [cell.imageView.layer addAnimation:transition forKey:nil];

                NSLog(@"Image Loaded! %@", img);
                [cell.activityIndicator stopAnimating];
            }];
        });
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat dimension = (self.view.frame.size.width > self.view.frame.size.height ? self.view.frame.size.height : self.view.frame.size.width) - 20;
    return CGSizeMake(dimension, dimension);
}

#pragma mark Remove cell

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];

    CollectionViewCell *cell = (CollectionViewCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil || cell.imageView.image == nil) {
        return;
    }

    // Animate the cell to the right
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.transform = CGAffineTransformTranslate(cell.transform, self.view.frame.size.width, 0);
        cell.alpha = 0;
    } completion: ^(BOOL finished) {
        NSLog(@"%@", [self.data objectAtIndex:indexPath.row].url);
        [self.data removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        cell.transform = CGAffineTransformTranslate(cell.transform, self.view.frame.size.width, 0);
    }];

}

@end

//
//  CollectionViewCell.h
//  FarPostTest
//
//  Created by Роман Есин on 29.01.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic, nullable) NSURL *URL;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

- (void) downloadImage: (NSURL *) url completion: (void (^)(UIImage* img)) completion;

@end

NS_ASSUME_NONNULL_END

//
//  CellData.h
//  FarPostTest
//
//  Created by Роман Есин on 29.01.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellData : NSObject

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic, nullable) UIImage *image;

- (instancetype)initWithURL: (NSString*) url;

@end

NS_ASSUME_NONNULL_END

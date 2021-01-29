//
//  CollectionViewCell.m
//  FarPostTest
//
//  Created by Роман Есин on 29.01.2021.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

#pragma mark Image loading
/// Loads an image from url and sets it to the cell
/// @param url Url to the image
- (void) downloadImage: (NSURL *) url completion: (void (^)(UIImage* img)) completion {
    // This already uses the cached data because `NSURLRequestReturnCacheDataElseLoad` is specified
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:8];
    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error occured loading the request. %@", error);
            [self downloadImage:url completion:completion];
            return;
        }
        if (data == nil) {
            NSLog(@"No data recieved :(");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [UIImage imageWithData:data];
            completion(img);
        });
    }];
    [dataTask resume];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Cell init");

        // Init cell
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor.grayColor colorWithAlphaComponent:0.1]];
        [self.layer setCornerRadius:16.0];

        // Init image view
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.imageView];
        [[self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
        [[self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
        [[self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];

        // Create activity indicator to see when the image is loading
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        //    [self.activityIndicator setHidesWhenStopped:NO];
        //    [self.activityIndicator setBackgroundColor:UIColor.redColor];
        [self addSubview:self.activityIndicator];
        [[self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];

        [self.activityIndicator startAnimating];
    }
    return self;
}

@end

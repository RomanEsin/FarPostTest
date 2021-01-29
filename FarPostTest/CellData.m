//
//  CellData.m
//  FarPostTest
//
//  Created by Роман Есин on 29.01.2021.
//

#import "CellData.h"

@implementation CellData

- (instancetype)initWithURL:(NSString *)urlString {
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:urlString];
    }
    return self;
}

@end

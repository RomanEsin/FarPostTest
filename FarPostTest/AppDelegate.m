//
//  AppDelegate.m
//  FarPostTest
//
//  Created by Роман Есин on 29.01.2021.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    if (@available(iOS 11.0, *)) {
        [[nav navigationBar] setPrefersLargeTitles:YES];
    }
    [[self window] setRootViewController:nav];
    [[self window] makeKeyAndVisible];

    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    
    return YES;
}


@end

//
//  AppDelegate.m
//  CubeEngineDemo
//
//  Created by jianchengpan on 2018/8/27.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "AppDelegate.h"
#import "CDTabBarController.h"
#import "CubeWare.h"

#import "CDLoginViewController.h"
#import <UMCommon/UMCommon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UMConfigure initWithAppkey:@"5bcedc17b465f5d62d000197" channel:@"GitHub_iOS"];
    NSDictionary *loginInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLogin"];
    if (loginInfoDic) {
        
        CubeConfig *config = [CubeConfig configWithAppId:APPID AppKey:APPKey];
        config.licenseServer = GetLicenseUrl;
        config.videoCodec = @"VP8"; // H264
        [[CubeWare sharedSingleton] startWithcubeConfig:config];
        
        CDTabBarController *tabBarVC  = [[CDTabBarController alloc] init];
        self.window.rootViewController = tabBarVC;
    }
    else{
        CDLoginViewController *loginVc = [[CDLoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
        self.window.rootViewController = nav;
    }

	[self.window makeKeyAndVisible];
    
    
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[CubeWare sharedSingleton] sleep];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	[[CubeWare sharedSingleton] wakeup];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - orientation
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
@end

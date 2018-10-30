//
//  CubeWareGlobalMacro.h
//  CubeWare
//
//  Created by Mario on 17/1/16.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#ifndef CubeWareGlobalMacro_h
#define CubeWareGlobalMacro_h

#define CW_VALIDATION_ASSISTANT_ID @"10000"
#define CW_ME_CHAT_ID @"me-"

#define CW_SECRET_CHAT_ID @"me-secretchat"

#define CubeWare_Message_TimeOut 3 * 60 * 1000 + 5 * 1000  //消息超时处理，引擎为180s，终端185s，不与之冲突

#ifdef DEBUG
#define MR_LOGGING_DISABLED 0
#else
#define MR_LOGGING_DISABLED 1
#endif

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define IOS11 [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0
#define iOS9_1 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.1f)
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define iPhone_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIBubbleTop 9.f
#define UINameHeight 20.f
#define UISreenWidthScale   UIScreenWidth / 320
#define UISCREENSIZE [UIScreen mainScreen].bounds.size
#define RatioWidth  UIScreenWidth / 375
#define RatioHeight  UIScreenHeight / 667
#define ATNUM 10
#define UNREADNUM 10

#define SecretMessageDefaultTime 30

#define UICommonTableBkgColor UIColorFromRGB(0xe4e7ec)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#pragma mark - UIColor 宏定义

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define CWRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define CWRGBColorOpaque(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define CW_SEARCH_KEYWORDS UIColorFromRGB(0xefb747a)

#define KRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:b/(255.0) alpha:1.0]
#define KArcColor  KRGB(arc4random_uniform(265), arc4random_uniform(265), arc4random_uniform(265)) //随机色，慎用
#define CWSessionBackground UIColorFromRGB (0xf1f2f7)

#pragma mark - MainThread 主线程

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

// APP_STATUSBAR_HEIGHT=SYS_STATUSBAR_HEIGHT+[HOTSPOT_STATUSBAR_HEIGHT]
#define APP_STATUSBAR_HEIGHT             (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

// 根据APP_STATUSBAR_HEIGHT判断是否存在热点栏
#define IS_HOTSPOT_CONNECTED             (APP_STATUSBAR_HEIGHT==(SYSStatusBarHeight+HotspotStatusBarHeight)?YES:NO)
// 无热点栏时，标准系统状态栏高度+导航栏高度
#define NORMAL_STATUS_AND_NAV_BAR_HEIGHT (SYSStatusBarHeight+NavigationBarHeight)
// 实时系统状态栏高度+导航栏高度，如有热点栏，其高度包含在APP_STATUSBAR_HEIGHT中。通过APP_STATUSBAR_HEIGHT计算实际上tableview y多了20 所以写死
#define STATUS_AND_NAV_BAR_HEIGHT        (20.f+44.f)

#define APP_STATUS_AND_NAV_BAR_HEIGHT  (APP_STATUSBAR_HEIGHT+CWavigationBarHeight)

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define CUBE_WARE_EMOJ_REGULAR @"\\[([\u4e00-\u9fa5|OK|NO]+)\\]";
#define CUBE_WARE_AT_REGULAR @"@\\{cube:[^,]*,name:[^\\}]*\\}";
#define CUBE_WARE_ATALL_REGULAR @"@\\{group:[^,]*,name:[^\\}]*\\}";
#define CUBE_WARE_FACIAL_REGULAR @"\\[cube_emoji:[a-fA-F0-9]{32}\]{1}";
// 最大音频时长 60s
#define CW_RECORD_AUDIO_MAX 60

//iPhoneX底部安全高度
#define X_HOME_INDICATOR_HEIGHT 34.f

//导航栏高度
#define X_NAV_HEIGHT 88.f

#define CWCurrentNavHeight APP_STATUS_AND_NAV_BAR_HEIGHT

#define CWBootomSafeHeight (UIScreenHeight >= 812.0 ? X_HOME_INDICATOR_HEIGHT : 0)

#define CWTopSafeHeight (UIScreenHeight >= 812.0 ? X_NAV_HEIGHT : STATUS_AND_NAV_BAR_HEIGHT)

#endif /* CubeWareGlobalMacro_h */


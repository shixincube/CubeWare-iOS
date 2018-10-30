//
//  JGPhotoBrowser.h
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for JGPhotoBrowser.
FOUNDATION_EXPORT double JGPhotoBrowserVersionNumber;

//! Project version string for JGPhotoBrowser.
FOUNDATION_EXPORT const unsigned char JGPhotoBrowserVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JGPhotoBrowser/PublicHeader.h>

#if __has_include(<JGPhotoBrowser/JGPhotoBrowserImpl.h>)
#import <JGPhotoBrowser/JGPhotoBrowserImpl.h>
#import <JGPhotoBrowser/JGPhoto.h>
#else
#import "JGPhotoBrowserImpl.h"
#import "JGPhoto.h"
#endif

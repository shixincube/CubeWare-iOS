//
//  CWColorUtil.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWColorUtil.h"

@implementation CWColorUtil

+ (UIColor *)colorWithRGB:(int)rgbValue andAlpha:(CGFloat)alpha{
    UIColor * rgbColor =  [UIColor
                           colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0x00FF00) >> 8))/255.0
                           blue:((float)(rgbValue & 0x0000FF))/255.0
                           alpha:alpha];
    return rgbColor;
    
}

+(UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha{
	if (hexString.length == 0) {
		return nil;
	}
	
	// Check for hash and add the missing hash
	if('#' != [hexString characterAtIndex:0])
	{
		hexString = [NSString stringWithFormat:@"#%@", hexString];
	}
	
	// check for string length
	if (7 != hexString.length && 4 != hexString.length) {
		NSString *defaultHex    = [NSString stringWithFormat:@"0xff"];
		unsigned defaultInt = [[self class] hexValueToUnsigned:defaultHex];
		
		UIColor *color = [self colorWith8BitRed:defaultInt green:defaultInt blue:defaultInt alpha:1.0];
		return color;
	}
	
	// check for 3 character HexStrings
	hexString = [[self class] hexStringTransformFromThreeCharacters:hexString];
	
	NSString *redHex    = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(1, 2)]];
	unsigned redInt = [self hexValueToUnsigned:redHex];
	
	NSString *greenHex  = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(3, 2)]];
	unsigned greenInt = [self hexValueToUnsigned:greenHex];
	
	NSString *blueHex   = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(5, 2)]];
	unsigned blueInt = [self hexValueToUnsigned:blueHex];
	UIColor *color = [self colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
	
	return color;
}

+ (NSString *)hexStringTransformFromThreeCharacters:(NSString *)hexString
{
	if(hexString.length == 4)
	{
		hexString = [NSString stringWithFormat:@"#%1$c%1$c%2$c%2$c%3$c%3$c",
					 [hexString characterAtIndex:1],
					 [hexString characterAtIndex:2],
					 [hexString characterAtIndex:3]];
		
	}
	
	return hexString;
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
	UIColor *color = nil;
	color = [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
	return color;
}

+ (unsigned)hexValueToUnsigned:(NSString *)hexValue
{
	unsigned value = 0;
	
	NSScanner *hexValueScanner = [NSScanner scannerWithString:hexValue];
	[hexValueScanner scanHexInt:&value];
	
	return value;
}

@end

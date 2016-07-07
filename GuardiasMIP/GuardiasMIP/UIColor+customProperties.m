//
//  UIColor+customProperties.m
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 07/08/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import "UIColor+customProperties.h"

@implementation UIColor (customProperties)
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIColor *)containerViewColor
{
    return [self colorWithHexString:@"4BC9E6"];
}

+(UIColor *)contrastingRed
{
    return [self colorWithHexString:@"FF2A68"];
}
+(UIColor *)contrastingBlue
{
    return [self colorWithHexString:@"5AC8FB"];
}
+(UIColor *)contrastingGrey
{
    return [self colorWithHexString:@"8E8E93"];
}
+(UIColor *)contrastingGreen
{
    return [self colorWithHexString:@"0BD318"];
}
+(UIColor *)contrastingOrange
{
    return [self colorWithHexString:@"FF5E3A"];
}
+(UIColor *)contrastingPurple
{
    return [self colorWithHexString:@"C86EDF"];
}

+(NSString *)stringFromColor:(UIColor *)color {
    if (color == [UIColor contrastingRed]) {
         return @"FF2A68";
    }
    
    if (color == [UIColor containerViewColor]) {
         return @"4BC9E6";
    }
    
    if (color == [UIColor contrastingBlue]) {
         return @"5AC8FB";
    }
    
    if (color == [UIColor contrastingGrey]) {
         return @"8E8E93";
    }
    
    if (color == [UIColor contrastingGreen]) {
         return @"0BD318";
    }
    
    if (color == [UIColor contrastingOrange]) {
         return @"FF5E3A";
    }
    
    if (color == [UIColor contrastingPurple]) {
         return @"C86EDF";
    }
    
    return @"4BC9E6";
}


@end

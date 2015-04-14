//
//  UIColor+Colors.m
//  cardalot
//
//  Created by Jason Noah Choi on 3/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)

+ (UIColor *)customDarkPurpleColor {
    return [UIColor colorWithHue:246.0/360 saturation:.9 brightness:1.0 alpha:1.0];
}

+ (UIColor *)customMenuColor {
    return [UIColor colorWithHue:51.0/360 saturation:.45 brightness:.7 alpha:1.0];
}

+ (UIColor *)customOrangeColor {
    return [UIColor colorWithHue:15.0/360 saturation:.83 brightness:1.0 alpha:1];
}

+ (UIColor *)customGrayColor {
    return [UIColor colorWithHue:1.0 saturation:0 brightness:.93 alpha:1];
}

+ (UIColor *)backgroundGrayColor {
    return [UIColor colorWithHue:0.0 saturation:0.0 brightness:.91 alpha:1];
}

+ (UIColor *)customBlueColor {
    return [UIColor colorWithHue:199.0/365 saturation:.7 brightness:.94 alpha:1];
}

+ (UIColor *)customGreenColor {
    return [UIColor colorWithHue:167.0/360 saturation:.65 brightness:.89 alpha:1];
}

+ (UIColor *)customPurpleColor {
    return [UIColor colorWithHue:246.0/360 saturation:.25 brightness:1.0 alpha:1.0];
}

+ (UIColor *)customSwitchPurpleColor {
    return [UIColor colorWithHue:247.0/360 saturation:.55 brightness:1.0 alpha:1.0];
}

+ (UIColor *)customTextColor {
    return [UIColor colorWithHue:0 saturation:0 brightness:.1 alpha:1];
}

@end

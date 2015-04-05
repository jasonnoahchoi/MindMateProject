//
//  UIColor+Colors.m
//  cardalot
//
//  Created by Jason Noah Choi on 3/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)

+ (UIColor *)customPurpleColor {
    return [UIColor colorWithHue:246.0/360 saturation:.25 brightness:1.0 alpha:1.0];
}

+ (UIColor *)customOrangeColor {
    return [UIColor colorWithHue:15.0/360 saturation:.83 brightness:1.0 alpha:1];
}

+ (UIColor *)customGreenColor {
    return [UIColor colorWithHue:167.0/360 saturation:.65 brightness:.89 alpha:1];
}

+ (UIColor *)customGrayColor {
    return [UIColor colorWithRed:110.0/255 green:110.0/255 blue:110.0/255 alpha:1];
}

+ (UIColor *)backgroundGrayColor {
    return [UIColor colorWithHue:0.0 saturation:0.0 brightness:.91 alpha:1];
}
@end

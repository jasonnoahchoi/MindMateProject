//
//  MenuView.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/29/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "MenuView.h"
#import "UIColor+Colors.h"
@import QuartzCore;

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.menuButton.backgroundColor = [UIColor customGrayColor];
        self.menuButton.layer.masksToBounds = YES;
        self.menuButton.layer.cornerRadius = 5;
        [self addSubview:self.menuButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

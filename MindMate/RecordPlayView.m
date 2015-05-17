//
//  RecordPlayView.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 5/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "RecordPlayView.h"

@implementation RecordPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playgreen"]];
        self.recordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recordred"]];
        [self addSubview:self.playImageView];
        [self addSubview:self.recordImageView];
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

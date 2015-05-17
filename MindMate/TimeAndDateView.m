//
//  TimeAndDateView.m
//  MindMate
//
//  Created by Jason Noah Choi on 4/6/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "TimeAndDateView.h"

@implementation TimeAndDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.timeLabel = [[UILabel alloc] initWithFrame:self.frame];
        self.dateLabel = [[UILabel alloc] initWithFrame:self.frame];
        self.dateLabel.text = @"";
        self.dateLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
        self.timeLabel.text = @"";
        self.timeLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
        self.dateLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.dateLabel.numberOfLines = 0;
        self.timeLabel.numberOfLines = 0;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        [self addSubview:self.dateLabel];
        [self.dateLabel setNeedsLayout];
        [self.timeLabel setNeedsLayout];
        
        [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        NSDictionary *buttonsDictionary = NSDictionaryOfVariableBindings(_timeLabel, _dateLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_timeLabel]-[_dateLabel]-|" options:0 metrics:nil views:buttonsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_timeLabel]|" options:0 metrics:nil views:buttonsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dateLabel]|" options:0 metrics:nil views:buttonsDictionary]];
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

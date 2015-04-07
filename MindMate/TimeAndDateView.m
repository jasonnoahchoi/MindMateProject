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
        self.backgroundColor = [UIColor blueColor];
        self.timeLabel = [[UILabel alloc] initWithFrame:self.frame];
        self.dateLabel = [[UILabel alloc] initWithFrame:self.frame];
        self.dateLabel.text = @"ASDDFDS";
        self.timeLabel.text = @"TEST TIME";
        self.dateLabel.numberOfLines = 0;
        self.timeLabel.numberOfLines = 0;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        [self addSubview:self.dateLabel];
        self.timeLabel.backgroundColor = [UIColor greenColor];
        self.dateLabel.backgroundColor = [UIColor cyanColor];

        
        [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

//        NSDictionary *labelDictionary = NSDictionaryOfVariableBindings(_timeLabel);
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-200-[_timeLabel]-20-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:labelDictionary]];

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

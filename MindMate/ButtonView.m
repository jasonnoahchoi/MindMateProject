//
//  ButtonView.m
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "ButtonView.h"
#import "CategoryContainerView.h"
#import "UIColor+Colors.h"

@interface ButtonView ()

@property (nonatomic, strong) UIView *recordButtonContainerView;
@property (nonatomic, assign) BOOL recordingComplete;

@end

@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.recordingComplete = NO;
        self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.recordButton.backgroundColor = [UIColor customGreenColor];
//        [self.recordButton performSelector:@selector(longPress) withObject:nil];
        //[self.recordButton targetForAction:@selector(longPress:) withSender:self];

        //[self.recordButton addTarget:self action:@selector(longPress:) forControlEvents:(UIControlEventTouchDown)];
        //[self.recordButton addTarget:self action:@selector(buttonMethod1:forEvent:controlEvent:) forControlEvents:UIControlEventTouchCancel];


        [self addSubview:self.recordButton];
        [self.recordButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *buttonDictionary = NSDictionaryOfVariableBindings(_recordButton);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_recordButton]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:buttonDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_recordButton]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:buttonDictionary]];

        self.recordButton.layer.cornerRadius = frame.size.height/2;
        self.recordButton.layer.masksToBounds = YES;
        self.recordButton.layer.shouldRasterize = YES;

        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.playButton];
        self.playButton.hidden = YES;
        self.playButton.backgroundColor = [UIColor customBlueColor];
        self.playButton.layer.cornerRadius = frame.size.height/2;
        self.playButton.layer.masksToBounds = YES;
        self.playButton.layer.shouldRasterize = YES;

        self.longPressGestureForPlayButton = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForPlay:)];
        self.longPressGestureForPlayButton.minimumPressDuration = .2;

        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        self.longPressGesture.allowableMovement = 1000.0;
        self.longPressGesture.minimumPressDuration = .0001;
        [self.recordButton addGestureRecognizer:self.longPressGesture];
        [self.playButton addGestureRecognizer:self.longPressGestureForPlayButton];

        self.recordCompleteLabel = [[UILabel alloc] init];
        self.recordCompleteLabel.text = @"Recording Complete";
        self.recordCompleteLabel.textAlignment = NSTextAlignmentCenter;
        self.recordCompleteLabel.layer.shouldRasterize = YES;
        self.recordCompleteLabel.font = [UIFont boldSystemFontOfSize:24];
        self.recordCompleteLabel.textColor = [UIColor whiteColor];
        [self.recordButton addSubview:self.recordCompleteLabel];
        self.recordCompleteLabel.hidden = YES;

        [self.recordCompleteLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *labelDictionary = NSDictionaryOfVariableBindings(_recordCompleteLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_recordCompleteLabel]-20-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:labelDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_recordCompleteLabel]-30-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:labelDictionary]];
    }
    return self;
}

- (void)longPressForPlay:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didTryToPlayWithPlayButton:withGesture:)]) {
        [self.delegate didTryToPlayWithPlayButton:self.playButton withGesture:gesture];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didTryToZoom:withGesture:)]) {
        [self.delegate didTryToZoom:self.recordButton withGesture:gesture];
    }
    if ([self.delegate respondsToSelector:@selector(didTryToPlay:withGesture:)]) {
        [self.delegate didTryToPlay:self.recordButton withGesture:gesture];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

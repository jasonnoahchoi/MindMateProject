//
//  ButtonView.m
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "ButtonView.h"
#import "CategoryContainerView.h"

@interface ButtonView ()

@property (nonatomic, strong) UIView *recordButtonContainerView;
@property (nonatomic, assign) BOOL recordingComplete;

@property (nonatomic, strong) CategoryContainerView *containerView;

@end

@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.recordingComplete = NO;
        self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.recordButton.backgroundColor = [UIColor blueColor];
//        [self.recordButton performSelector:@selector(longPress) withObject:nil];
        //[self.recordButton targetForAction:@selector(longPress:) withSender:self];

        [self.recordButton addTarget:self action:@selector(longPress:) forControlEvents:(UIControlEventTouchDown)];
        //[self.recordButton addTarget:self action:@selector(buttonMethod1:forEvent:controlEvent:) forControlEvents:UIControlEventTouchCancel];


        [self addSubview:self.recordButton];
        [self.recordButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *buttonDictionary = NSDictionaryOfVariableBindings(_recordButton);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_recordButton]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:buttonDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_recordButton]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:buttonDictionary]];

        self.recordButton.layer.cornerRadius = frame.size.height/2;
        self.recordButton.layer.masksToBounds = YES;
        self.recordButton.layer.shouldRasterize = YES;
        [self setNeedsLayout];

        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.playButton];
        self.playButton.enabled = NO;
        self.playButton.hidden = YES;
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        //self.delegate = self;
        self.longPressGesture.allowableMovement = 100.0;
        self.longPressGesture.numberOfTouchesRequired = 1;
        [self.recordButton addGestureRecognizer:self.longPressGesture];

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


//        self.recordButton.layer.mask = self.shapeLayer;
//        [self.recordButton.layer.mask setValue: @(0) forKeyPath: @"transform.scale"];
    }
    return self;
}

- (void)buttonMethod1:(UIButton *)sender forEvent:(UIEvent *)event controlEvent:(UIControlEvents)controlEvent {
//        if ([self.delegate respondsToSelector:@selector(recordButtonReleased:withButton:)]) {
//            [self.delegate recordButtonReleased:self withButton:sender];

//        }
}

- (void)buttonMethod:(UIButton *)sender forEvent:(UIEvent *)event controlEvent:(UIControlEvents)controlEvent {
//        if ([self.delegate respondsToSelector:@selector(recordButtonPressed:withButton:)]) {
//            [self.delegate recordButtonPressed:self withButton:sender];
//        }
}


//- (void)recordPressed:(id)sender {
//    if (
//    if ([self.delegate respondsToSelector:@selector(recordButtonPressed:withButton:)]) {
//        [self.delegate recordButtonPressed:self withButton:self.recordButton];
//    }
//}

- (void)longPress {
//    [self longPress:self.longPressGesture];
}

- (void)longPress:(UILongPressGestureRecognizer *)gr {

    if ([self.delegate respondsToSelector:@selector(buttonView:didTryToZoom:)]) {
        [self.delegate buttonView:self didTryToZoom:self.recordButton];
    }
       if ([self.delegate respondsToSelector:@selector(buttonView:didTryToShake:)]) {
        [self.delegate buttonView:self didTryToShake:self.recordButton];
    }
    if ([self.delegate respondsToSelector:@selector(recordButtonPressedWithGesture:)]) {
        [self.delegate recordButtonPressedWithGesture:(UIGestureRecognizerStateBegan)];
    }

    if ([self.delegate respondsToSelector:@selector(recordButtonReleasedWithGesture:)]) {
        [self.delegate recordButtonReleasedWithGesture:(UIGestureRecognizerStateEnded)];
    }
}
//    if ([self.delegate respondsToSelector:@selector(recordButtonPressed:withButton:)]) {
//    [self.delegate recordButtonPressed:self withButton:self.recordButton];
//    }
//    if ([self.delegate respondsToSelector:@selector(recordButtonReleased:withButton:)]) {
//        [self.delegate recordButtonReleased:self withButton:self.recordButton];
//    }

//        if (gr.state == UIGestureRecognizerStateBegan) {
//            [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                self.recordButton.transform = CGAffineTransformScale(self.recordButton.transform, 3, 3);
//                self.recordButton.alpha = .7;
//            } completion:nil];
//        } else if (gr.state == UIGestureRecognizerStateEnded) {
//            [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut animations:^{
//                self.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
//                self.recordButton.alpha = 1;
//
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                    self.recordButton.transform = CGAffineTransformScale(self.recordButton.transform, .9, .9);
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                        self.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
//                    } completion:^(BOOL finished) {
//                        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                            self.recordButton.transform = CGAffineTransformIdentity;
//                        } completion:^(BOOL finished) {
//                            self.recordCompleteLabel.hidden = NO;
//                            self.recordingComplete = YES;
//                            [NSTimer scheduledTimerWithTimeInterval:.8
//                                                             target:self
//                                                           selector:@selector(hideLabel)
//                                                           userInfo:nil
//                                                            repeats:NO];
//
//                        }];
//                    }];
//                }];
//            }];
//        }
//    }


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
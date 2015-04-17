//
//  ButtonView.h
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuartzCore;
@class ButtonView;

@protocol ButtonViewDelegate <NSObject>

- (void)didTryToZoom:(UIButton *)button withGesture:(UIGestureRecognizer *)sender;
- (void)didTryToPlayWithPlayButton:(UIButton *)button withGesture:(UIGestureRecognizer *)sender;

@optional
- (void)didTryToPlay:(UIButton *)button withGesture:(UIGestureRecognizer *)sender;
- (void)recordButtonPressed:(UIButton *)button withGesture:(UIGestureRecognizerState)state;
- (void)recordButtonReleased:(UIButton *)button withGesture:(UIGestureRecognizerState)state;

@end

@interface ButtonView : UIView

@property (weak, nonatomic) id <ButtonViewDelegate> delegate;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureForPlayButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *recordCompleteLabel;
- (void)longPress:(UILongPressGestureRecognizer *)gr;
//- (UIGestureRecognizer *)otherGestureRecognizer;

@end

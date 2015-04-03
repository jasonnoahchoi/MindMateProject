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
- (void)didTryToShake:(UIButton *)button withGesture:(UIGestureRecognizer *)sender;
- (void)recordingWithButton:(UIButton *)button;
- (void)stopRecordingWithButton:(UIButton *)button;

@optional
- (void)recordButtonPressed:(UIButton *)button withGesture:(UIGestureRecognizerState)state;
- (void)recordButtonReleased:(UIButton *)button withGesture:(UIGestureRecognizerState)state;
//- (void)recordButtonPressed:(ButtonView *)view withButton:(UIButton *)sender;
//- (void)recordButtonReleased:(ButtonView *)view withButton:(UIButton *)sender;

@end

@interface ButtonView : UIView

@property (weak, nonatomic) id <ButtonViewDelegate> delegate;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *recordCompleteLabel;
- (void)longPress:(UILongPressGestureRecognizer *)gr;
- (void)recordPressed:(id)sender;
//- (UIGestureRecognizer *)otherGestureRecognizer;

@end

//
//  CategoryContainerView.m
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "CategoryContainerView.h"
#import "ButtonView.h"
@import QuartzCore;

@interface CategoryContainerView ()

@end

@implementation CategoryContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutButtons];
        [self animateLayoutButtons];
    }
    return self;
}

- (void)setState:(ButtonState)state {
    if (_state == state) {
        return;
    }
    _state = state;

//    switch (state) {
//        case ButtonStateNone:
//            [self.delegate noneState:ButtonStateNone];
//            break;
//        case ButtonStateFocus:
//                self.focusButton.layer.borderColor = [UIColor greenColor].CGColor;
//            [self.delegate focusState:ButtonStateFocus];
//                [self.focusButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//
//            break;
//        case ButtonStateCourage:
//
//                self.courageButton.layer.borderColor = [UIColor redColor].CGColor;
//            [self.delegate courageState:ButtonStateCourage];
//                [self.courageButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//
//            break;
//        case ButtonStateAmbition:
//
//            break;
//
//        default:
//            break;
////    }
//    if (state == ButtonStateLaunch) {
//        [self.delegate focusState:ButtonStateLaunch];
//        return;
//    }
    if (state == ButtonStateNone || state == ButtonStateZero) {
        switch (state) {
            case ButtonStateNone:
                [self.delegate focusState:ButtonStateNone];
                break;
            case ButtonStateZero:
                [self.delegate zeroState:ButtonStateZero];
                break;
            default:
                break;
        }
        
        self.focusButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.focusButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.courageButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.courageButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.ambitionButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.ambitionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.imaginationButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.imaginationButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.funButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.funButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.presenceButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.presenceButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

//        ButtonView *view = [[ButtonView alloc] init];
//        [view gestureRecognizer:view.longPressGesture shouldRequireFailureOfGestureRecognizer:view.longPressGesture];
    }
    if (state == ButtonStateFocus) {
        self.focusButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.focusButton.backgroundColor = [UIColor greenColor];
        [self.delegate focusState:ButtonStateFocus];
        [self.focusButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else {
        self.focusButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.focusButton.backgroundColor = [UIColor clearColor];
        [self.focusButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStateCourage) {
        self.courageButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.courageButton.backgroundColor = [UIColor redColor];
        [self.delegate courageState:ButtonStateCourage];
        [self.courageButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else {
        self.courageButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.courageButton.backgroundColor = [UIColor clearColor];
        [self.courageButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStateAmbition) {
        self.ambitionButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.ambitionButton.backgroundColor = [UIColor orangeColor];
        [self.delegate ambitionState:ButtonStateAmbition];
        [self.ambitionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else {
        self.ambitionButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.ambitionButton.backgroundColor = [UIColor clearColor];
        [self.ambitionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStateImagination) {
        self.imaginationButton.layer.borderColor = [UIColor purpleColor].CGColor;
        [self.delegate imaginationState:ButtonStateImagination];
        [self.imaginationButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    } else {
        self.imaginationButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.imaginationButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStateFun) {
        self.funButton.layer.borderColor = [UIColor cyanColor].CGColor;
        [self.delegate funState:ButtonStateFun];
        [self.funButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    } else {
        self.funButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.funButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStatePresence) {
        self.presenceButton.layer.borderColor = [UIColor yellowColor].CGColor;
        [self.delegate presenceState:ButtonStatePresence];
        [self.presenceButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    } else {
        self.presenceButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.presenceButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}

- (void)animateLayoutButtons {
    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.focusButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.presenceButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.focusButton.transform = CGAffineTransformIdentity;
            self.presenceButton.transform = CGAffineTransformIdentity;
            self.courageButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            self.funButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.funButton.transform = CGAffineTransformIdentity;
                self.courageButton.transform = CGAffineTransformIdentity;
                self.ambitionButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                self.imaginationButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.ambitionButton.transform = CGAffineTransformIdentity;
                    self.imaginationButton.transform = CGAffineTransformIdentity;
                } completion:nil];
            }];
        }];
    }];
}

- (void)layoutButtons {

    self.focusButton = [[UIButton alloc] init];
    [self.focusButton setTitle:@"Focus" forState:UIControlStateNormal];
    self.focusButton.titleLabel.text = @"Focus";
    [self.focusButton addTarget:self action:@selector(focusPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.focusButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.focusButton.layer.borderWidth = 2;
    self.focusButton.layer.cornerRadius = 6;

    self.courageButton = [[UIButton alloc] init];
    [self.courageButton setTitle:@"Courage" forState:UIControlStateNormal];
    [self.courageButton addTarget:self action:@selector(couragePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.courageButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.courageButton.layer.borderWidth = 2;
    self.courageButton.layer.cornerRadius = 6;

    self.ambitionButton = [[UIButton alloc] init];
    [self.ambitionButton setTitle:@"Ambition" forState:UIControlStateNormal];
    [self.ambitionButton addTarget:self action:@selector(ambitionPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.ambitionButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.ambitionButton.layer.borderWidth = 2;
    self.ambitionButton.layer.cornerRadius = 6;

    self.imaginationButton = [[UIButton alloc] init];
    [self.imaginationButton setTitle:@"Imagination" forState:UIControlStateNormal];
    [self.imaginationButton addTarget:self action:@selector(imaginationPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.imaginationButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.imaginationButton.layer.borderWidth = 2;
    self.imaginationButton.layer.cornerRadius = 6;

    self.funButton = [[UIButton alloc] init];
    [self.funButton setTitle:@"Fun" forState:UIControlStateNormal];
    [self.funButton addTarget:self action:@selector(funPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.funButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.funButton.layer.borderWidth = 2;
    self.funButton.layer.cornerRadius = 6;

    self.presenceButton = [[UIButton alloc] init];
    [self.presenceButton setTitle:@"Presence" forState:UIControlStateNormal];
    [self.presenceButton addTarget:self action:@selector(presencePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.presenceButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.presenceButton.layer.borderWidth = 2;
    self.presenceButton.layer.cornerRadius = 6;

    [self addSubview:self.focusButton];
    [self addSubview:self.courageButton];
    [self addSubview:self.ambitionButton];
    [self addSubview:self.imaginationButton];
    [self addSubview:self.funButton];
    [self addSubview:self.presenceButton];
}

- (void)layoutSubviews {
    [self.focusButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.courageButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.ambitionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.imaginationButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.funButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.presenceButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSDictionary *buttonsDictionary = NSDictionaryOfVariableBindings(_focusButton, _courageButton, _ambitionButton, _imaginationButton, _funButton, _presenceButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_focusButton]-[_courageButton(==_focusButton)]-[_ambitionButton(==_focusButton)]-|" options:0 metrics:nil views:buttonsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_imaginationButton]-[_funButton(==_imaginationButton)]-[_presenceButton(==_imaginationButton)]-|"  options:0 metrics:nil views:buttonsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_focusButton]-[_imaginationButton(==_focusButton)]-|" options:0 metrics:nil views:buttonsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_courageButton]-[_funButton(==_courageButton)]-|" options:0 metrics:nil views:buttonsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_ambitionButton]-[_presenceButton(==_ambitionButton)]-|" options:0 metrics:nil views:buttonsDictionary]];
}

- (void)focusPressed:(id)sender {
    self.state = ButtonStateFocus;
}

- (void)couragePressed:(id)sender {
    self.state = ButtonStateCourage;
}

- (void)ambitionPressed:(id)sender {
    self.state = ButtonStateAmbition;
}

- (void)imaginationPressed:(id)sender {
    self.state = ButtonStateImagination;
}

- (void)funPressed:(id)sender {
    self.state = ButtonStateFun;
}

- (void)presencePressed:(id)sender {
    self.state = ButtonStatePresence;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

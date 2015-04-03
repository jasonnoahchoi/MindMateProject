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

@property (nonatomic, strong)ButtonView *buttonView;
@end

@implementation CategoryContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutButtons];
        //self.state = ButtonStateLaunch;
        //self.state = ButtonStateNone;
        self.noneOn = NO;
        self.focusOn = NO;
        self.courageOn = NO;
        self.ambitionOn = NO;
        self.imaginationOn = NO;
        self.funOn = NO;
        self.presenceOn = NO;

        self.buttonView = [[ButtonView alloc] init];
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
    if (state == ButtonStateNone) {
        self.noneOn = YES;
        self.focusOn = NO;
        self.courageOn = NO;
        self.ambitionOn = NO;
        self.imaginationOn = NO;
        self.funOn = NO;
        self.presenceOn = NO;
        [self.delegate focusState:ButtonStateNone];
        self.buttonView.recordButton.backgroundColor = [UIColor blueColor];
        self.focusButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.courageButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.courageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.ambitionButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.ambitionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.imaginationButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.imaginationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.funButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.funButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.presenceButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.presenceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

//        ButtonView *view = [[ButtonView alloc] init];
//        [view gestureRecognizer:view.longPressGesture shouldRequireFailureOfGestureRecognizer:view.longPressGesture];
    }
    if (state == ButtonStateFocus) {
        self.noneOn = NO;
        self.focusOn = YES;
        self.courageOn = NO;
        self.ambitionOn = NO;
        self.imaginationOn = NO;
        self.funOn = NO;
        self.presenceOn = NO;
        self.focusButton.layer.borderColor = [UIColor greenColor].CGColor;
        [self.delegate focusState:ButtonStateFocus];
        [self.focusButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
      } else {
        self.focusOn = NO;
        self.focusButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStateCourage) {
        self.noneOn = NO;
        self.focusOn = NO;
        self.courageOn = YES;
        self.ambitionOn = NO;
        self.imaginationOn = NO;
        self.funOn = NO;
        self.presenceOn = NO;
        self.courageButton.layer.borderColor = [UIColor redColor].CGColor;
        [self.delegate courageState:ButtonStateCourage];
        [self.courageButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        //    if (state != ButtonStateCourage) {
        self.courageOn = NO;
        self.courageButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.courageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStateAmbition) {
        self.noneOn = NO;
        self.focusOn = NO;
        self.courageOn = NO;
        self.ambitionOn = YES;
        self.imaginationOn = NO;
        self.funOn = NO;
        self.presenceOn = NO;
        self.ambitionButton.layer.borderColor = [UIColor orangeColor].CGColor;
        [self.delegate ambitionState:ButtonStateAmbition];
        [self.ambitionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        } else {
        self.ambitionOn = NO;
        self.ambitionButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.ambitionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStateImagination) {
        self.noneOn = NO;
        self.focusOn = NO;
        self.courageOn = NO;
        self.ambitionOn = NO;
        self.imaginationOn = YES;
        self.funOn = NO;
        self.presenceOn = NO;
        self.imaginationButton.layer.borderColor = [UIColor purpleColor].CGColor;
        [self.delegate imaginationState:ButtonStateImagination];
        [self.imaginationButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    } else {
        //    if (state != ButtonStateImagination) {
        self.imaginationButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.imaginationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.imaginationOn = NO;
    }
    if (state == ButtonStateFun) {
        self.noneOn = NO;
        self.focusOn = NO;
        self.courageOn = NO;
        self.ambitionOn = NO;
        self.imaginationOn = NO;
        self.funOn = YES;
        self.presenceOn = NO;
        self.funButton.layer.borderColor = [UIColor cyanColor].CGColor;
        [self.delegate funState:ButtonStateFun];
        [self.funButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    } else {
        //    if (state != ButtonStateFun) {
        self.funOn = NO;
        self.funButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.funButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (state == ButtonStatePresence) {
        self.noneOn = NO;
        self.focusOn = NO;
        self.courageOn = NO;
        self.ambitionOn = NO;
        self.imaginationOn = NO;
        self.funOn = NO;
        self.presenceOn = YES;
        self.presenceButton.layer.borderColor = [UIColor yellowColor].CGColor;
        [self.delegate presenceState:ButtonStatePresence];
        [self.presenceButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    } else {
//    if (state != ButtonStatePresence) {
        self.presenceOn = NO;
        self.presenceButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.presenceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}



- (void)layoutButtons {

    self.focusButton = [[UIButton alloc] init];
    [self.focusButton setTitle:@"Focus" forState:UIControlStateNormal];
    self.focusButton.titleLabel.text = @"Focus";
    [self.focusButton addTarget:self action:@selector(focusPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.focusButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.focusButton.layer.borderWidth = 2;
    self.focusButton.layer.cornerRadius = 6;

    self.courageButton = [[UIButton alloc] init];
    [self.courageButton setTitle:@"Courage" forState:UIControlStateNormal];
    [self.courageButton addTarget:self action:@selector(couragePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.courageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.courageButton.layer.borderWidth = 2;
    self.courageButton.layer.cornerRadius = 6;

    self.ambitionButton = [[UIButton alloc] init];
    [self.ambitionButton setTitle:@"Ambition" forState:UIControlStateNormal];
    [self.ambitionButton addTarget:self action:@selector(ambitionPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.ambitionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ambitionButton.layer.borderWidth = 2;
    self.ambitionButton.layer.cornerRadius = 6;

    self.imaginationButton = [[UIButton alloc] init];
    [self.imaginationButton setTitle:@"Imagination" forState:UIControlStateNormal];
    [self.imaginationButton addTarget:self action:@selector(imaginationPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.imaginationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imaginationButton.layer.borderWidth = 2;
    self.imaginationButton.layer.cornerRadius = 6;

    self.funButton = [[UIButton alloc] init];
    [self.funButton setTitle:@"Fun" forState:UIControlStateNormal];
    [self.funButton addTarget:self action:@selector(funPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.funButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.funButton.layer.borderWidth = 2;
    self.funButton.layer.cornerRadius = 6;

    self.presenceButton = [[UIButton alloc] init];
    [self.presenceButton setTitle:@"Presence" forState:UIControlStateNormal];
    [self.presenceButton addTarget:self action:@selector(presencePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.presenceButton.layer.borderColor = [UIColor whiteColor].CGColor;
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
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_imaginationButton]-[_funButton(==_imaginationButton)]-[_presenceButton(_imaginationButton)]-|"  options:0 metrics:nil views:buttonsDictionary]];
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

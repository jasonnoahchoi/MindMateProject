//
//  CategoryContainerView.h
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ButtonStateNone,
    ButtonStateFocus,
    ButtonStateCourage,
    ButtonStateAmbition,
    ButtonStateImagination,
    ButtonStateFun,
    ButtonStatePresence,
    ButtonStateZero,
} ButtonState;

@protocol CategoryContainerViewDelegate <NSObject>

- (void)noneState:(ButtonState)state;
- (void)focusState:(ButtonState)state;
- (void)courageState:(ButtonState)state;
- (void)ambitionState:(ButtonState)state;
- (void)imaginationState:(ButtonState)state;
- (void)funState:(ButtonState)state;
- (void)presenceState:(ButtonState)state;

@end

@interface CategoryContainerView : UIView

@property (nonatomic, weak) id <CategoryContainerViewDelegate> delegate;
@property (nonatomic) ButtonState state;
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIButton *courageButton;
@property (nonatomic, strong) UIButton *ambitionButton;
@property (nonatomic, strong) UIButton *imaginationButton;
@property (nonatomic, strong) UIButton *funButton;
@property (nonatomic, strong) UIButton *presenceButton;

- (void)setState:(ButtonState)state;

@end

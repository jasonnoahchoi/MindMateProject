//
//  PlayCollectionViewCell.h
//  MindMate
//
//  Created by Jason Noah Choi on 4/5/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Recording;

@interface PlayCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, strong) UIButton *invisiblePlayButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) Recording *recording;
@property (nonatomic, assign) NSInteger index;

@end

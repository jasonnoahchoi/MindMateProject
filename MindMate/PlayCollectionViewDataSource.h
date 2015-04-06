//
//  PlayCollectionViewDataSource.h
//  MindMate
//
//  Created by Jason Noah Choi on 4/5/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class Recording;
@class PlayCollectionViewController;

@interface PlayCollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) Recording *recording;

- (void)registerCollectionView:(UICollectionView *)collectionView;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

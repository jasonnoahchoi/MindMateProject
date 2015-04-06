//
//  PlayCollectionViewDataSource.m
//  MindMate
//
//  Created by Jason Noah Choi on 4/5/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "PlayCollectionViewDataSource.h"
#import "RecordingController.h"
#import "Recording.h"
#import "PlayCollectionViewCell.h"

@implementation PlayCollectionViewDataSource

- (void)registerCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[PlayCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [RecordingController sharedInstance].memos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.index = indexPath.item;
    Recording *recording = [RecordingController sharedInstance].memos[indexPath.item];

    if ([recording.groupID isEqual:@1]) {
        cell.backgroundColor = [UIColor blueColor];
    }
    if ([recording.groupID isEqual:@2]) {
        cell.backgroundColor = [UIColor greenColor];
    }
    if ([recording.groupID isEqual:@3]) {
        cell.backgroundColor = [UIColor redColor];
    }
    if ([recording.groupID isEqual:@4]) {
        cell.backgroundColor = [UIColor cyanColor];
    }
    if ([recording.groupID isEqual:@5]) {
        cell.backgroundColor = [UIColor orangeColor];
    }
    if ([recording.groupID isEqual:@6]) {
        cell.backgroundColor = [UIColor yellowColor];
    }

    //cell.timeLabel.text = @"Test Time";
   // cell.groupNameLabel.text = @"Focus";

    return cell;
}

@end

//
//  PlayCollectionViewController.m
//  MindMate
//
//  Created by Jason Noah Choi on 4/5/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "PlayCollectionViewController.h"
#import "UIColor+Colors.h"
#import "PlayCollectionViewDataSource.h"
#import "RecordingController.h"
#import "AudioController.h"
#import "Recording.h"
@import AVFoundation;

@interface PlayCollectionViewController () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PlayCollectionViewDataSource *dataSource;

@end

@implementation PlayCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customGreenColor];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 1;
   // flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButton:)];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
    self.dataSource = [[PlayCollectionViewDataSource alloc] init];
    self.collectionView.dataSource = self.dataSource;
    [self.dataSource registerCollectionView:self.collectionView];
    self.collectionView.delegate = self;
    [self.collectionView reloadData];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (void)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    Recording *recording = [RecordingController sharedInstance].memos[indexPath.item];
////    NSURL *url = [NSURL URLWithString:recording.urlPath];
//    NSData *data = recording.memo;
////    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
////    [player play];
//    //AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//   // [player play];
//    //AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
//    //[player play];
//
//
//    [[AudioController sharedInstance] playAudioWithURLPath:data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

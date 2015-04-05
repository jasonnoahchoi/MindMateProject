//
//  PlayCollectionViewController.m
//  MindMate
//
//  Created by Jason Noah Choi on 4/5/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "PlayCollectionViewController.h"
#import "UIColor+Colors.h"

@interface PlayCollectionViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PlayCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customGreenColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButton:)];
    //self.collectionView = [[UICollectionView alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

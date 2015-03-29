//
//  ViewController.m
//  MindMate
//
//  Created by Jason Noah Choi on 3/26/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "ViewController.h"
#import "AudioRecorderViewController.h"


@interface ViewController ()
@property (nonatomic, strong) AudioRecorderViewController *audioVC;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2 - 100, CGRectGetHeight(self.view.bounds)/2 - 50, 200, 100)];
    self.button.backgroundColor = [UIColor redColor];
    self.audioVC = [[AudioRecorderViewController alloc] init];
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buttonPressed:(id)sender {
    //CGAffineTransform scaleTransform = CGAffineTransformMakeScale(3, 2);
    //scaleTransform = CGAffineTransformScale(rotationTransform, 9., 9.);
    //self.button.transform = scaleTransform;
    self.button.alpha = 1;
    [UIView animateWithDuration:3
                     animations:^{
                         self.button.transform = CGAffineTransformScale(self.button.transform, 3, 8);
                         self.button.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self presentViewController:self.audioVC animated:YES completion:^{
                             self.button.alpha = 1;
                             CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.5, 1.5);
                             self.button.transform = scaleTransform;
                         }];
                     }];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

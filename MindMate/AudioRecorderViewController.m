//
//  AudioRecorderViewController.m
//  AudioWithWave
//
//  Created by Jason Noah Choi on 3/28/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "AudioRecorderViewController.h"
#import "UIImage+BlurredFrame.h"
#import "RecordingController.h"
#import "AudioController.h"
//#import "GroupViewController.h"

@interface AudioRecorderViewController ()
#pragma mark - UI Extras
@property (nonatomic,weak) IBOutlet UILabel *microphoneTextLabel;

@property (nonatomic, strong) UIImageView *background;

@property (nonatomic, strong) UIButton *play;
@property (nonatomic, strong) UIButton *record;
@property (nonatomic, strong) UILabel *recordLengthLabel;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *recordingTimer;
@property (nonatomic, strong) UIView *controlsBackground;

@end


@implementation AudioRecorderViewController
@synthesize audioPlot;
@synthesize microphone;
#pragma mark - Initialization
-(id)init {
    self = [super init];
    if(self){
        [self initializeViewController];

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initializeViewController];
    }
    return self;
}

+ (instancetype)showRecorderMasterViewController:(UIViewController *)masterViewController withFinishedBlock:(AudioNoteRecorderFinishBlock)finishedBlock {
    AudioRecorderViewController *avc = [[AudioRecorderViewController alloc] initWithMasterViewController:masterViewController];
    avc.finishedBlock = finishedBlock;
    [masterViewController presentViewController:avc animated:YES completion:nil];
    return avc;
}
+ (instancetype)showRecorderWithMasterViewController:(UIViewController *)masterViewController withDelegate:(id<AudioNoteRecorderDelegate>)delegate {
    AudioRecorderViewController *avc = [[AudioRecorderViewController alloc] initWithMasterViewController:masterViewController];
    avc.delegate = delegate;
    [masterViewController presentViewController:avc animated:YES completion:nil];
    return avc;
}

- (instancetype)initWithMasterViewController:(UIViewController *)masterViewController
{
    self = [super init];
    if (self) {
        // make screenshot
        CGSize imageSize = CGSizeMake(masterViewController.view.window.bounds.size.width, masterViewController.view.window.bounds.size.height);
        UIGraphicsBeginImageContext(imageSize);
        [masterViewController.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        self.background = [[UIImageView alloc] initWithImage:[viewImage applyDarkEffectAtFrame:masterViewController.view.window.frame]];
        [self.view addSubview:self.background];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    }
    return self;
}


#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
}

#pragma mark - Customize the Audio Plot
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.audioPlot = [[EZAudioPlotGL alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/1.5)];
    [self.view addSubview:self.audioPlot];
    //self.view.backgroundColor = [UIColor blackColor];

    /*
     Customizing the audio plot's look
     */
    // Background color
    self.audioPlot.backgroundColor = [UIColor blackColor];
    // self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.569 green: 0.82 blue: 0.478 alpha: 1];
    // Waveform color
    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeBuffer;

    /*
     Start the microphone
     */
    self.microphoneTextLabel.text = @"Microphone On";

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // create the controls
    CGFloat height = 225.0f;
    //CGFloat height = self.view.bounds.size.height - 64;
    CGFloat barHeight = 30.0f;

    self.controlsBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, barHeight)];
    // buttons
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [done sizeToFit];
    [cancel sizeToFit];
    done.frame = CGRectMake(10, 5, done.frame.size.width, barHeight - 2*5);
    cancel.frame = CGRectMake(self.view.frame.size.width - 10 - cancel.frame.size.width, 5, cancel.frame.size.width, barHeight - 2*5);
    [topBar addSubview:done];
    [topBar addSubview:cancel];

    // gray background for the controls
    UIView *backgroundGray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    [backgroundGray setBackgroundColor:[UIColor blackColor]];
    backgroundGray.alpha = 0.3;
    [self.controlsBackground addSubview:backgroundGray];
    [self.controlsBackground addSubview:topBar];

    self.controlsBackground.frame = CGRectMake(0, self.view.frame.size.height - self.controlsBackground.frame.size.height, self.controlsBackground.frame.size.width, self.controlsBackground.frame.size.height);

    [self.view addSubview:self.controlsBackground];


    // recording controls...
    self.recordLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, barHeight + 10, self.view.frame.size.width - 20, 20)];
    [self.controlsBackground addSubview:self.recordLengthLabel];
    self.recordLengthLabel.textAlignment = NSTextAlignmentCenter;

    self.record = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.record setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    self.record.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.record setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
    self.record.frame = CGRectMake(0, 0, 100, 100);
    self.record.center = CGPointMake(100 + self.record.frame.size.width / 2, 0.5 * (height - barHeight) + barHeight);

    self.play = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.play setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.play setImage:nil forState:UIControlStateDisabled];
    //    [_play setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
    self.play.frame = CGRectMake(0, 0, 100, 100);
    self.play.center = CGPointMake(self.view.frame.size.width - 10 - self.play.frame.size.width / 2, 0.5 * (height - barHeight) + barHeight);
    self.play.enabled = NO;
    [self.controlsBackground addSubview:self.record];
    [self.controlsBackground addSubview:self.play];

    // actions
    [self.record addTarget:self action:@selector(recordTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.play addTarget:self action:@selector(playTap:) forControlEvents:UIControlEventTouchUpInside];


    self.controlsBackground.center = CGPointMake(self.controlsBackground.center.x, self.controlsBackground.center.y + self.view.frame.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        self.controlsBackground.center = CGPointMake(self.controlsBackground.center.x, self.controlsBackground.center.y - self.view.frame.size.height);
    }];
}

#pragma mark - actions
- (void)cancel:(UIButton *)sender
{
    if (self.recorder == nil || self.recorder.isRecording == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            self.controlsBackground.center = CGPointMake(self.controlsBackground.center.x, self.controlsBackground.center.y + self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.delegate) {
                    [self.delegate audioNoteRecorderDidCancel:self];
                }
                if (self.finishedBlock) {
                    self.finishedBlock ( NO, nil );
                }
            }];
        }];
//        GroupViewController *groupVC = [[GroupViewController alloc] init];
  //      [self.navigationController pushViewController:groupVC animated:YES];
    }
}
- (void)done:(UIButton *)sender
{
    if (self.recorder && self.recorder.isRecording == NO) {

        [UIView animateWithDuration:0.5 animations:^{
            self.controlsBackground.center = CGPointMake(self.controlsBackground.center.x, self.controlsBackground.center.y + self.view.frame.size.height);
        } completion:^(BOOL finished) {
                        [self dismissViewControllerAnimated:YES completion:^{
                if (self.delegate) {
                    [self.delegate audioNoteRecorderDidTapDone:self withRecordedURL:self.recorder.url];
                }
                if (self.finishedBlock) {
                    self.finishedBlock(YES, self.recorder.url);
                    [self.navigationController popViewControllerAnimated:YES];

                }
            }];
        }];
    }
}
- (void)recordTap:(UIButton *)sender
{
    if (sender.selected) {
        // stop
        [self.recorder stop];
        self.play.enabled = YES;
        [self.recordingTimer invalidate];
        self.recordingTimer = nil;
        NSLog(@"%@", self.recorder.url);
        [self.microphone stopFetchingAudio];

        NSData *data = [NSData dataWithContentsOfURL:self.recorder.url];
        [data writeToFile:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@", [[AudioController sharedInstance] filePath]]] atomically:YES];
        //[data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [self filePath]]] atomically:YES];
        NSLog(@"Data File: %@", data);
       // [[RecordingController sharedInstance] addRecordingWithFile:data];
        [[RecordingController sharedInstance] addRecordingWithURL:[[AudioController sharedInstance] filePath] andIDNumber:[[AudioController sharedInstance] randomIDNumber] andDateCreated:[[AudioController sharedInstance] createdAtDate] andFetchDate:[[AudioController sharedInstance] fetchDate] andGroupName:(Group *)@"TestGroup"];
        NSLog(@"ControllerRecordingPath: %@", [[AudioController sharedInstance] filePath]);
        [[RecordingController sharedInstance] save];
        NSLog(@"Date Created: %@, Fetch Date: %@, IDNUMBER: %@", [[AudioController sharedInstance] createdAtDate], [[AudioController sharedInstance] fetchDate], [[AudioController sharedInstance] randomIDNumber]);

        //[[NSFileManager defaultManager] createFileAtPath:[self filePath] contents:data attributes:nil];

    } else {
        // start
        self.play.enabled = NO;

        self.recorder = [[AudioController sharedInstance] recordAudioToDirectory];

        self.recorder.delegate = self;
        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordingTimerUpdate:) userInfo:nil repeats:YES];
        [self.recordingTimer fire];
        [self.microphone startFetchingAudio];

        // [self initializeViewController];
        [self drawBufferPlot];

    }
    sender.selected = !sender.selected;
}

- (void)playTap:(id)sender
{
    //    [SimpleAudioPlayer playFile:_recorder.url.description];
    NSError *error = nil;

    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:&error];
    self.player.volume = 1.0f;
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    [self.player play];
    NSLog(@"duration: %f", self.player.duration);
    [self.microphone startFetchingAudio];
    if (!self.player) {
        [self.microphone stopFetchingAudio];
    }
}
- (void)recordingTimerUpdate:(id) sender
{
    NSLog(@"%f %@", self.recorder.currentTime, sender);
    self.recordLengthLabel.text = [NSString stringWithFormat:@"%.0f", self.recorder.currentTime];
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"did finish playing %d", flag);
}

#pragma mark - Action Extensions
/*
 Give the visualization of the current buffer (this is almost exactly the openFrameworks audio input eample)
 */
-(void)drawBufferPlot {
    // Change the plot type to the buffer plot
    self.audioPlot.plotType = EZPlotTypeBuffer;
    // Don't mirror over the x-axis
    self.audioPlot.shouldMirror = NO;
    // Don't fill
    self.audioPlot.shouldFill = NO;
}

#pragma mark - EZMicrophoneDelegate
#warning Thread Safety
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.

    // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
    dispatch_async(dispatch_get_main_queue(),^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

-(void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
    // The AudioStreamBasicDescription of the microphone stream. This is useful when configuring the EZRecorder or telling another component what audio format type to expect.
    // Here's a print function to allow you to inspect it a little easier
    [EZAudio printASBD:audioStreamBasicDescription];
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder or EZOutput. Say whattt...
}

@end

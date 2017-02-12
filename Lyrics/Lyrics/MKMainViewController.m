//
//  MKMainViewController.m
//  Lyric2
//
//  Created by Mac on 13/10/15.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKMainViewController.h"
#import "MKLyricsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SYSTEM_INFO.h"

static const NSTimeInterval kRefreshInterval = 0.25;

@interface MKMainViewController ()
{
    NSTimer *lyricsRefreshTimer;
    NSTimeInterval currentPlayTime;
    BOOL isTimeSliderTouchDown;
}

@property (strong, nonatomic) MKLyricsViewController *lyricsViewController;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
- (IBAction)timeSliderTouchDown:(UISlider *)sender;
- (IBAction)timeSliderTouchUpInside:(UISlider *)sender;
- (IBAction)timeSliderValueChanged:(UISlider *)sender;

@end

@implementation MKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.lyricsViewController = [[MKLyricsViewController alloc] initWithNibName:@"MKLyricsViewController" bundle:nil];
    }
    else {
        self.lyricsViewController = [[MKLyricsViewController alloc] initWithNibName:@"MKLyricsViewController_iPad" bundle:nil];
    }
 
    NSError *error = nil;
    NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyrics.lrc"];
    [self.lyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
    
    if (error) {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = @"讀取歌詞資料錯誤";
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.frame = CGRectMake(10, 190, 300, 100);
        textLayer.wrapped = YES;
        textLayer.fontSize = 20;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.view.layer addSublayer:textLayer];
        return;
    }
    
    self.lyricsViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 100);
    [self.view addSubview:self.lyricsViewController.view];
    
    self.timeSlider.value = 0.0;
    self.timeSlider.minimumValue = 0.0;
    self.timeSlider.maximumValue = self.lyricsViewController.duration;
    [self.timeSlider setAccessibilityValue:@""];
    [self.timeSlider setAccessibilityTraits:UIAccessibilityTraitNone];
    self.currentPlayTimeLabel.text = [self _formattedStringForDuration:0.0];
    self.durationLabel.text = [self _formattedStringForDuration:self.lyricsViewController.duration];
    
    [self _startLyricsRefreshTimer];
}

#pragma mark - private function

- (void)_refreshLyricsViewController:(NSTimer *)timer
{
    currentPlayTime += kRefreshInterval;

    [self.lyricsViewController playAtTime:currentPlayTime];
    
    if (currentPlayTime >= self.lyricsViewController.duration) {
        [lyricsRefreshTimer invalidate];
    }
    
    if (!isTimeSliderTouchDown) {
        self.timeSlider.value = currentPlayTime;
        self.currentPlayTimeLabel.text = [self _formattedStringForDuration:currentPlayTime];
        [self.timeSlider setAccessibilityLabel:[@"目前播放時間" stringByAppendingString:[self _formattedAccessibilityStringForDuration:currentPlayTime]]];
    }
}

- (NSString *)_formattedStringForDuration:(NSTimeInterval)duration
{
    NSUInteger minutes = floor(duration / 60);
    NSUInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
}

- (NSString *)_formattedAccessibilityStringForDuration:(NSTimeInterval)duration
{
    NSUInteger minutes = floor(duration / 60);
    NSUInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%lu分%lu秒", (unsigned long)minutes, (unsigned long)seconds];
}

- (void)_startLyricsRefreshTimer
{
    lyricsRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:kRefreshInterval
                                                          target:self
                                                        selector:@selector(_refreshLyricsViewController:)
                                                        userInfo:nil
                                                         repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:lyricsRefreshTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - IBAction

- (IBAction)timeSliderTouchDown:(UISlider *)sender
{
    isTimeSliderTouchDown = YES;
}

- (IBAction)timeSliderTouchUpInside:(UISlider *)sender
{
    isTimeSliderTouchDown = NO;
    currentPlayTime = sender.value;
    [self.lyricsViewController playAtTime:sender.value];
    
    if (!lyricsRefreshTimer.isValid) {
        [self _startLyricsRefreshTimer];
    }
}

- (IBAction)timeSliderValueChanged:(UISlider *)sender
{
    self.currentPlayTimeLabel.text = [self _formattedStringForDuration:sender.value];
}

@end

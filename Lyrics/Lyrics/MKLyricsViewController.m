//
//  ViewController.m
//  Lyric2
//
//  Created by Mac on 13/10/3.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKLyricsViewController.h"
#import "MKLyricsParser.h"
#import "MKLyricsScrollView.h"
#import "SYSTEM_INFO.h"
#import <QuartzCore/QuartzCore.h>

static const NSTimeInterval kCountdownInterval = 3.0;

@interface MKLyricsViewController () <MKLyricScrollViewDatasource>
{
    NSArray *parsedLyricsData;
}

@property (strong, nonatomic) MKLyricsScrollView *mkLyricsScrollView;

@end

@implementation MKLyricsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mkLyricsScrollView = [[MKLyricsScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.mkLyricsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.mkLyricsScrollView.backgroundColor = [UIColor darkGrayColor];
    self.mkLyricsScrollView.dataSoruce = self;
    [self.mkLyricsScrollView reloadData];
    [self.view addSubview:self.mkLyricsScrollView];
}

#pragma mark - public function

- (void)loadLyricsWithFilePath:(NSString *)filePath error:(NSError *__autoreleasing *)inError
{
    NSError *error = nil;
    NSString *readFilePathContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        *inError = error;
        return;
    }
    
    MKLyricsParser *lyricsParser = [[MKLyricsParser alloc] init];
    parsedLyricsData = [lyricsParser parseLyricsWithString:readFilePathContents];
}

- (void)playAtTime:(NSTimeInterval)time
{    
    [self _hintCountdownTextLayer:time];
    
    [self _markPlayingLyrics:time];
        
    [self _scrollLyricsToVisible];
    
    [self _highlightPlayingLyrics];
}

#pragma mark - private function

- (void)_hintCountdownTextLayer:(NSTimeInterval)currentPlayTime
{
    for (int i = 0; i < parsedLyricsData.count; i++) {
        if ([parsedLyricsData[i][@"sec_st"] boolValue]) {
            CATextLayer *countdownTextLayer = self.mkLyricsScrollView.countdownTextLayers[i];
            
            if ([self _isTime:currentPlayTime inIntervalFrom:[parsedLyricsData[i][@"lineStart"] doubleValue] - kCountdownInterval To:[parsedLyricsData[i][@"lineStart"] doubleValue]]) {
                countdownTextLayer.string = [NSString stringWithFormat:@"%d", (int)([parsedLyricsData[i][@"lineStart"] doubleValue] - currentPlayTime) + 1];
            }
            else {
                countdownTextLayer.string = @"";
            }
        }
    }
}

- (void)_markPlayingLyrics:(NSTimeInterval)currentPlayTime
{
    for (int i = 0; i < parsedLyricsData.count; i++) {
        if ([self _isTime:currentPlayTime inIntervalFrom:[parsedLyricsData[i][@"lineStart"] doubleValue] To:[parsedLyricsData[i][@"lineEnd"] doubleValue]]) {
            parsedLyricsData[i][@"playing"] = [NSNumber numberWithBool:YES];
        }
        else {
            parsedLyricsData[i][@"playing"] = [NSNumber numberWithBool:NO];
        }
    }
}

- (void)_scrollLyricsToVisible
{
    for (int i = 0; i < parsedLyricsData.count; i++) {
        CATextLayer *lyricsTextLayer = self.mkLyricsScrollView.lyricsTextLayers[i];
        
        if ([parsedLyricsData[i][@"playing"] boolValue]) {
            CGRect visibleFrame = lyricsTextLayer.frame;
            visibleFrame.size.height = 300.0; // 讓捲動後還可以看到下面歌詞
            visibleFrame.origin.y -= 20.0;    // 避免捲動到與螢幕上半部切齊
            
            if (!self.mkLyricsScrollView.isDragging) {
                [self.mkLyricsScrollView scrollRectToVisible:visibleFrame animated:YES];
                self.mkLyricsScrollView.accessibleElements = nil;
                break;
            }
        }
    }
}

- (void)_highlightPlayingLyrics
{
    for (int i = 0; i < parsedLyricsData.count; i++) {
        CATextLayer *lyricsTextLayer = self.mkLyricsScrollView.lyricsTextLayers[i];
        
        if ([parsedLyricsData[i][@"playing"] boolValue]) {
            switch ([parsedLyricsData[i][@"type"] intValue]) {
                case 0:
                    lyricsTextLayer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.5].CGColor;
                    break;
                case 1:
                    lyricsTextLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5].CGColor;
                    break;
                case 2:
                    lyricsTextLayer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor;
                    break;
                case 3:
                    lyricsTextLayer.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5].CGColor;
                    break;
                default:
                    break;
            }
        }
        else {
            lyricsTextLayer.backgroundColor = [UIColor clearColor].CGColor;
        }
    }
}

- (BOOL)_isTime:(NSTimeInterval)time inIntervalFrom:(NSTimeInterval)fromTime To:(NSTimeInterval)toTime
{
    return (time > fromTime) && (time < toTime);
}

#pragma mark - MKLyricScrollViewDatasource

- (NSArray *)parsedLyricsForLyricsScrollView:(MKLyricsScrollView *)inView
{
    return parsedLyricsData;
}

#pragma mark - readonly

- (NSTimeInterval)duration
{
    return 87.0;
}

@end

#import "MKLyricsViewController.h"
#import "MKLyricsParser.h"
#import "MKLyricsScrollView.h"
#import "SYSTEM_INFO.h"

static const NSTimeInterval kCountdownInterval = 3.0;

@interface MKLyricsViewController () <MKLyricScrollViewDataSource>
{
    NSArray *parsedLyricsData;
}

@property (strong, nonatomic) MKLyricsScrollView *lyricsScrollView;

@end

@implementation MKLyricsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.lyricsScrollView = [[MKLyricsScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.lyricsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.lyricsScrollView.backgroundColor = [UIColor darkGrayColor];
    self.lyricsScrollView.dataSource = self;
    [self.lyricsScrollView reloadData];
    [self.view addSubview:self.lyricsScrollView];
}

#pragma mark - public function

- (void)loadLyricsWithFilePath:(NSString *)filePath error:(NSError *__autoreleasing *)inError
{
    NSError *error = nil;
    NSString *fileContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        *inError = error;
        return;
    }
    
    MKLyricsParser *lyricsParser = [[MKLyricsParser alloc] init];
    parsedLyricsData = [lyricsParser parseLyricsWithString:fileContents];
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
            CATextLayer *countdownTextLayer = self.lyricsScrollView.countdownTextLayers[i];
			double startTime = [parsedLyricsData[i][@"start"] doubleValue];
			
            if ([self _isTime:currentPlayTime inIntervalFrom:startTime - kCountdownInterval To:startTime]) {
                countdownTextLayer.string = [NSString stringWithFormat:@"%d", (int)(startTime - currentPlayTime) + 1];
            }
            else {
                countdownTextLayer.string = @""; // 倒數完後，把字清空
            }
        }
    }
}

- (void)_markPlayingLyrics:(NSTimeInterval)currentPlayTime
{
    for (int i = 0; i < parsedLyricsData.count; i++) {
		double startTime = [parsedLyricsData[i][@"start"] doubleValue];
		double endTime = [parsedLyricsData[i][@"end"] doubleValue];
		
        if ([self _isTime:currentPlayTime inIntervalFrom:startTime To:endTime]) {
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
        CATextLayer *lyricsTextLayer = self.lyricsScrollView.lyricsTextLayers[i];
        
        if ([parsedLyricsData[i][@"playing"] boolValue]) {
            CGRect visibleFrame = lyricsTextLayer.frame;
            visibleFrame.size.height = 300.0; // 讓捲動後還可以看到下面歌詞
            visibleFrame.origin.y -= 20.0;    // 避免捲動到與螢幕上半部切齊
            
            if (!self.lyricsScrollView.isDragging) {
                [self.lyricsScrollView scrollRectToVisible:visibleFrame animated:YES];
                self.lyricsScrollView.accessibleElements = nil;
                break;
            }
        }
    }
}

- (void)_highlightPlayingLyrics
{
    for (int i = 0; i < parsedLyricsData.count; i++) {
        CATextLayer *lyricsTextLayer = self.lyricsScrollView.lyricsTextLayers[i];
        
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

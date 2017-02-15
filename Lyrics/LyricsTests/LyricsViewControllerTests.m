#import <XCTest/XCTest.h>
#import "MKLyricsViewController.h"

@interface LyricsViewControllerTests : XCTestCase

@end

@implementation LyricsViewControllerTests {
	MKLyricsViewController *lyricsViewController;
	NSString *lyricsFilePath;
}

- (void)setUp
{
    [super setUp];
	
	lyricsFilePath = lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
	NSError *error = nil;
	[lyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
	XCTAssertNil(error);

	lyricsViewController = [[MKLyricsViewController alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPlayAtValidTime
{
	[lyricsViewController playAtTime:22.0];
	NSArray *lyrics = [lyricsViewController valueForKey:@"parsedLyricsData"];
	
	int playingLyricsIndex = 1;
	
	for (int i = 0; i < lyrics.count; i++) {
		if (i == playingLyricsIndex) {
			XCTAssertTrue([lyrics[i][@"playing"] boolValue], @"lyrics index %d is playing", playingLyricsIndex);
		}
		else {
			XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"lyrics index %d is not playing", playingLyricsIndex);
		}
	}
}

- (void)testPlayAtNegativeTime
{
	[lyricsViewController playAtTime:-1.0];
	NSArray *lyrics = [lyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

- (void)testPlayAtZeroTime
{
	[lyricsViewController playAtTime:0.0];
	NSArray *lyrics = [lyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

- (void)testPlayAtDurationTime
{
	[lyricsViewController playAtTime:lyricsViewController.duration];
	NSArray *lyrics = [lyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

- (void)testPlayAtMaxTime
{
	[lyricsViewController playAtTime:999999];
	NSArray *lyrics = [lyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

@end

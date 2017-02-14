#import <XCTest/XCTest.h>
#import "MKLyricsViewController.h"

@interface LyricsPlayTests : XCTestCase

@end

@implementation LyricsPlayTests {
	MKLyricsViewController *mkLyricsViewController;
	NSString *lyricsFilePath;
}

- (void)setUp {
    [super setUp];
	
	lyricsFilePath = lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
	NSError *error = nil;
	[mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
	XCTAssertNil(error);

	mkLyricsViewController = [[MKLyricsViewController alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPlayAtValidTime
{
	[mkLyricsViewController playAtTime:22.0];
	NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
	
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
	[mkLyricsViewController playAtTime:-1.0];
	NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

- (void)testPlayAtZeroTime
{
	[mkLyricsViewController playAtTime:0.0];
	NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

- (void)testPlayAtDurationTime
{
	[mkLyricsViewController playAtTime:mkLyricsViewController.duration];
	NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

- (void)testPlayAtMaxTime
{
	[mkLyricsViewController playAtTime:999999];
	NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

@end

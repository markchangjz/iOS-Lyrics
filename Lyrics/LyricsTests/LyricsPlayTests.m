#import <XCTest/XCTest.h>
#import "MKLyricsViewController.h"

@interface LyricsPlayTests : XCTestCase

@end

@implementation LyricsPlayTests {
	MKLyricsViewController *mkLyricsViewController;
}

- (void)setUp {
    [super setUp];

	mkLyricsViewController = [[MKLyricsViewController alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPlayAtTime
{
	NSError *error = nil;
	NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
	[mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
	XCTAssertNil(error);
	
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

- (void)testPlayAtTime_ZeroSecond
{
	NSError *error = nil;
	NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
	[mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
	XCTAssertNil(error);
	
	[mkLyricsViewController playAtTime:0.0];
	
	NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

- (void)testPlayAtTime_NegativeSecond
{
	NSError *error = nil;
	NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
	[mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
	XCTAssertNil(error);
	
	[mkLyricsViewController playAtTime:-1.0];
	
	NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

- (void)testPlayAtTime_DurationSecond
{
	NSError *error = nil;
	NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
	[mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
	XCTAssertNil(error);
	
	[mkLyricsViewController playAtTime:mkLyricsViewController.duration];
	
	NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
	
	for (int i = 0; i < lyrics.count; i++) {
		XCTAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
	}
}

@end

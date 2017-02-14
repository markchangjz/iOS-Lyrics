#import <XCTest/XCTest.h>
#import "MKLyricsParser.h"

@interface LyricsParserTests : XCTestCase

@end

@implementation LyricsParserTests {
	MKLyricsParser *lyricsParser;
	NSArray *parsedLyricsData;
}

- (void)setUp {
    [super setUp];

	lyricsParser = [[MKLyricsParser alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParseValidLyrics
{
	NSString *lyrics = @"[00:26.05 00:31.10]<type=2>她愛她     她愛他";
	parsedLyricsData = [lyricsParser parseLyricsWithString:lyrics];
	
	XCTAssertNotNil(parsedLyricsData, @"parsedLyricData is nil");
	XCTAssertEqual([parsedLyricsData[0][@"lineStart"] doubleValue], 26.05, @"lineStart is incorrect");
	XCTAssertEqual([parsedLyricsData[0][@"lineEnd"] doubleValue], 31.10, @"lineEnd is incorrect");
	XCTAssertEqual([parsedLyricsData[0][@"type"] intValue], 2, @"type is incorrect");
	XCTAssertEqualObjects((NSString *)parsedLyricsData[0][@"lineLyrics"], @"她愛她     她愛他", @"lineLyrics is incorrect");
}

- (void)testParseInvalidLyrics
{
	NSString *lyrics = @"[01:03 幸福 我要的幸福 在不遠處";
	parsedLyricsData = [lyricsParser parseLyricsWithString:lyrics];
	
	XCTAssertEqual(parsedLyricsData.count, (NSUInteger)0, @"parsedLyricData has no data");
}

- (void)testParseEmptyData
{
	NSString *lyrics = @"";
	parsedLyricsData = [lyricsParser parseLyricsWithString:lyrics];
	
	XCTAssertEqual(parsedLyricsData.count, (NSUInteger)0, @"parsedLyricData has no data");
}

- (void)testParseEmptyTime
{
	NSString *lyrics = @"[]<type=0>Test";
	parsedLyricsData = [lyricsParser parseLyricsWithString:lyrics];
	
	XCTAssertEqual(parsedLyricsData.count, (NSUInteger)0, @"parsedLyricData has no data");
}

- (void)testParseEmptyLyricsText
{
	NSString *lyrics = @"[00:00.00 00:00.00]<type=0>";
	parsedLyricsData = [lyricsParser parseLyricsWithString:lyrics];
	
	XCTAssertEqual(parsedLyricsData.count, (NSUInteger)1, @"parsedLyricData must has data");
	XCTAssertEqualObjects((NSString *)parsedLyricsData[0][@"lineLyrics"], @"", @"lineLyrics is incorrect");
}

@end

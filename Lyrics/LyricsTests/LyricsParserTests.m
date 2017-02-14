#import <XCTest/XCTest.h>
#import "MKLyricsParser.h"

@interface LyricsParserTests : XCTestCase

@end

@implementation LyricsParserTests

MKLyricsParser *lyricsParser;

- (void)setUp {
    [super setUp];

	lyricsParser = [[MKLyricsParser alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParsedLyricSuccess
{
	NSArray *parsedLyricData = [lyricsParser parseLyricsWithString:@"[00:26.05 00:31.10]<type=2>她愛她     她愛他"];
	
	XCTAssertNotNil(parsedLyricData, @"parsedLyricData is nil");
	XCTAssertEqual([parsedLyricData[0][@"lineStart"] doubleValue], 26.05, @"lineStart is incorrect");
	XCTAssertEqual([parsedLyricData[0][@"lineEnd"] doubleValue], 31.10, @"lineEnd is incorrect");
	XCTAssertEqual([parsedLyricData[0][@"type"] intValue], 2, @"type is incorrect");
	XCTAssertEqualObjects((NSString *)parsedLyricData[0][@"lineLyrics"], @"她愛她     她愛他", @"lineLyrics is incorrect");
}

- (void)testParsedLyricFail
{
	NSArray *parsedLyricData = [lyricsParser parseLyricsWithString:@"[01:03 幸福 我要的幸福 在不遠處"];
	
	XCTAssertEqual(parsedLyricData.count, (NSUInteger)0, @"parsedLyricData has no data");
}

- (void)testParsingEmptyString
{
	NSArray *parsedLyricData = [lyricsParser parseLyricsWithString:@""];
	
	XCTAssertEqual(parsedLyricData.count, (NSUInteger)0, @"parsedLyricData has no data");
}

- (void)testParsingEmptyTime
{
	NSArray *parsedLyricData = [lyricsParser parseLyricsWithString:@"[]<type=0>Test"];
	
	XCTAssertEqual(parsedLyricData.count, (NSUInteger)0, @"parsedLyricData has no data");
}

- (void)testParsingEmptyLyricsText
{
	NSArray *parsedLyricData = [lyricsParser parseLyricsWithString:@"[00:00.00 00:00.00]<type=0>"];
	
	XCTAssertEqual(parsedLyricData.count, (NSUInteger)1, @"parsedLyricData must has data");
}

@end

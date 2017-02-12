//
//  MKLyric.m
//  Lyric
//
//  Created by Mac on 13/10/1.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKLyricsParser.h"

@implementation MKLyricsParser

- (NSArray *)parseLyricsWithString:(NSString *)lyricsString
{
    NSMutableArray *parsedLyricsData = [NSMutableArray array];
    
    NSString *lrcRegularExpression = @"\\[\\d{2}:\\d{2}.\\d{2} \\d{2}:\\d{2}.\\d{2}\\]<type=[0-3]>(<sec_st>){0,1}.*";
    NSPredicate *lrcFormatTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lrcRegularExpression];
            
    NSRegularExpression *lyricsTimeRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d{2}:\\d{2}.\\d{2}" options:NSRegularExpressionCaseInsensitive error:nil];

    for (NSString *line in [lyricsString componentsSeparatedByString:@"\n"]) {
        
        if ([lrcFormatTest evaluateWithObject:line]) {
            
            NSMutableDictionary *lineMetaData = [[NSMutableDictionary alloc] init];
            NSArray *lyricsTimeMatches = [lyricsTimeRegularExpression matchesInString:line options:0 range:NSMakeRange(0, [line length])];
            
            lineMetaData[@"lineStart"]  = [self _convertTimeStringToSecond:[line substringWithRange:[[lyricsTimeMatches objectAtIndex:0] rangeAtIndex:0]]];
            lineMetaData[@"lineEnd"]    = [self _convertTimeStringToSecond:[line substringWithRange:[[lyricsTimeMatches objectAtIndex:1] rangeAtIndex:0]]];
            lineMetaData[@"type"]       = [NSNumber numberWithInt:[[line substringWithRange:NSMakeRange(25, 1)] intValue]];
            lineMetaData[@"playing"]    = [NSNumber numberWithBool:NO];
            lineMetaData[@"sec_st"]     = [NSNumber numberWithBool:NO];
            lineMetaData[@"lineLyrics"] = [line substringFromIndex:27];
            
            if ([line rangeOfString:@"<sec_st>"].location != NSNotFound) {
                lineMetaData[@"sec_st"]     = [NSNumber numberWithBool:YES];
                lineMetaData[@"lineLyrics"] = [line substringFromIndex:35];
            }

            [parsedLyricsData addObject:lineMetaData];
        }
    }
    
    return parsedLyricsData;
}

- (NSNumber *)_convertTimeStringToSecond:(NSString *)timeString
{    
    NSArray *timeData = [timeString componentsSeparatedByString:@":"];
    
    NSAssert(timeData.count == 2, @"time format is incorrect");
    if (timeData.count != 2) {
        return nil;
    }
        
    return [NSNumber numberWithDouble:[timeData[0] doubleValue] * 60.0 + [timeData[1] doubleValue]];
}

@end

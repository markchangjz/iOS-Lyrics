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
            
            NSMutableDictionary *metaData = [[NSMutableDictionary alloc] init];
            NSArray *lyricsTimeMatches = [lyricsTimeRegularExpression matchesInString:line options:0 range:NSMakeRange(0, [line length])];
            
            metaData[@"start"] = [self _convertTimeStringToSecond:[line substringWithRange:[[lyricsTimeMatches objectAtIndex:0] rangeAtIndex:0]]];
            metaData[@"end"] = [self _convertTimeStringToSecond:[line substringWithRange:[[lyricsTimeMatches objectAtIndex:1] rangeAtIndex:0]]];
            metaData[@"type"] = [NSNumber numberWithInt:[[line substringWithRange:NSMakeRange(25, 1)] intValue]];
            metaData[@"playing"] = [NSNumber numberWithBool:NO];
            metaData[@"sec_st"] = [NSNumber numberWithBool:NO];
            metaData[@"lyrics"] = [line substringFromIndex:27];
            
            if ([line rangeOfString:@"<sec_st>"].location != NSNotFound) {
                metaData[@"sec_st"] = [NSNumber numberWithBool:YES];
                metaData[@"lyrics"] = [line substringFromIndex:35];
            }

            [parsedLyricsData addObject:metaData];
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

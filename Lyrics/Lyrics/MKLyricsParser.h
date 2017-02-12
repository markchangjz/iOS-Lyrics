//
//  MKLyric.h
//  Lyric
//
//  Created by Mac on 13/10/1.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKLyricsParser : NSObject

- (NSArray *)parseLyricsWithString:(NSString *)lyricsString;

@end

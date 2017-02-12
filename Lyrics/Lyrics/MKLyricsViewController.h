//
//  ViewController.h
//  Lyric2
//
//  Created by Mac on 13/10/3.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKLyricsViewController : UIViewController

@property(readonly) NSTimeInterval duration;

- (void)loadLyricsWithFilePath:(NSString *)filePath error:(NSError **)inError;
- (void)playAtTime:(NSTimeInterval)time;

@end

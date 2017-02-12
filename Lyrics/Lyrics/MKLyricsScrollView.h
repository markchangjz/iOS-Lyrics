//
//  MKLyricScrollView.h
//  Lyric2
//
//  Created by Mac on 13/10/14.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKLyricsScrollView;

@protocol MKLyricScrollViewDatasource <NSObject>

- (NSArray *)parsedLyricsForLyricsScrollView:(MKLyricsScrollView *)inView;

@end

@interface MKLyricsScrollView : UIScrollView

- (void)reloadData;

@property (weak, nonatomic) id <MKLyricScrollViewDatasource> dataSoruce;
@property (strong, nonatomic) NSMutableArray *countdownTextLayers;
@property (strong, nonatomic) NSMutableArray *lyricsTextLayers;
@property (nonatomic, strong) NSMutableArray *accessibleElements;

@end
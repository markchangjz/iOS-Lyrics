//
//  MKLyricScrollView.m
//  Lyric2
//
//  Created by Mac on 13/10/14.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKLyricsScrollView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat paddingY = 20.0;
static const CGFloat lyricsPadding = 20.0;

@implementation MKLyricsScrollView

- (void)reloadData
{
    self.lyricsTextLayers = [NSMutableArray array];
    self.countdownTextLayers = [NSMutableArray array];
    
    CGFloat lyricsTextLayerY = lyricsPadding;
    
    for (int i = 0; i < [self.dataSoruce parsedLyricsForLyricsScrollView:self].count; i++) {
        CATextLayer *countdownTextLayer = [CATextLayer layer];
        countdownTextLayer.foregroundColor = [UIColor yellowColor].CGColor;
        countdownTextLayer.fontSize = 16;
        countdownTextLayer.frame = CGRectMake(10, 0, 20, 20);
        
        CATextLayer *lyricsTextLayer = [CATextLayer layer];
        lyricsTextLayer.string = [self.dataSoruce parsedLyricsForLyricsScrollView:self][i][@"lineLyrics"];
		
		CGSize textSize = [lyricsTextLayer.string sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16]}];
		
        CGFloat lyricsTextLayerHeight = MIN(textSize.height, self.frame.size.height);
        
        lyricsTextLayer.frame = CGRectMake(0, lyricsTextLayerY, self.frame.size.width, lyricsTextLayerHeight);
        lyricsTextLayer.backgroundColor = [UIColor clearColor].CGColor;
        lyricsTextLayer.wrapped = YES;
        lyricsTextLayer.fontSize = 16;
        lyricsTextLayer.cornerRadius = 7.0;
        lyricsTextLayer.alignmentMode = kCAAlignmentCenter;
        lyricsTextLayer.contentsScale = [UIScreen mainScreen].scale;
            
        lyricsTextLayerY += lyricsTextLayerHeight + lyricsPadding;
        
        [lyricsTextLayer addSublayer:countdownTextLayer];
        [self.layer addSublayer:lyricsTextLayer];
        [self.lyricsTextLayers addObject:lyricsTextLayer];
        [self.countdownTextLayers addObject:countdownTextLayer];
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, lyricsTextLayerY + paddingY);
}

#pragma mark - lazy loading

- (NSMutableArray *)accessibleElements
{
    if (!_accessibleElements) {
        _accessibleElements = [[NSMutableArray alloc] init];
        
        for (CATextLayer *lyricsTextLayer in self.lyricsTextLayers) {
            UIAccessibilityElement *lyricsElement = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
            CGRect viewFrame = lyricsTextLayer.frame;
            viewFrame = [self convertRect:viewFrame toView:[self window]];
            viewFrame = [[self window] convertRect:viewFrame toWindow:nil];
            lyricsElement.accessibilityFrame = viewFrame;
//            lyricsElement.accessibilityFrame = [self convertRect:lyricsTextLayer.frame toView:nil];
            lyricsElement.accessibilityLabel = lyricsTextLayer.string;
            lyricsElement.accessibilityTraits = UIAccessibilityTraitStaticText;
            [_accessibleElements addObject:lyricsElement];
        }
    }
    
    return _accessibleElements;
}

#pragma mark - accessibility

- (NSInteger)accessibilityElementCount
{
    return self.accessibleElements.count;
}

- (id)accessibilityElementAtIndex:(NSInteger)index
{
    return [[self accessibleElements] objectAtIndex:index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
    return [[self accessibleElements] indexOfObject:element];
}

- (BOOL)isAccessibilityElement
{
    return NO;
}

@end

#import <UIKit/UIKit.h>

@class MKLyricsScrollView;

@protocol MKLyricScrollViewDataSource <NSObject>

- (NSArray *)parsedLyricsForLyricsScrollView:(MKLyricsScrollView *)inView;

@end

@interface MKLyricsScrollView : UIScrollView

- (void)reloadData;

@property (weak, nonatomic) id <MKLyricScrollViewDataSource> dataSource;
@property (strong, nonatomic) NSMutableArray *countdownTextLayers;
@property (strong, nonatomic) NSMutableArray *lyricsTextLayers;
@property (strong, nonatomic) NSMutableArray *accessibleElements;

@end

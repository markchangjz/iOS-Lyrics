#import <UIKit/UIKit.h>

@interface MKLyricsViewController : UIViewController

@property(readonly) NSTimeInterval duration;

- (void)loadLyricsWithFilePath:(NSString *)filePath error:(NSError **)inError;
- (void)playAtTime:(NSTimeInterval)time;

@end

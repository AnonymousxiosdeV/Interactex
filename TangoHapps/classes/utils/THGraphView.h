
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class THGraphViewSegment;
@class THGraphTextView;
@class THGraphViewSegmentGroup;

@interface THGraphView : UIView
{
    
}

- (id)initWithFrame:(CGRect)frame maxAxisY:(float) maxAxisY minAxisY:(float) minAxisY ;

- (void)addX:(float)x;
- (void)addY:(float)y;

@property (nonatomic) float maxAxisY;
@property (nonatomic) float minAxisY;

@property (nonatomic, strong) THGraphViewSegmentGroup * groupX;
@property (nonatomic, strong) THGraphViewSegmentGroup * groupY;

@property (nonatomic) THGraphTextView *text;

@end


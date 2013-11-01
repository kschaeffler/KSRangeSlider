//
//  KSRangeSlider.h
//  Kschaeffler
//
//  Created by Karl Schaeffler on 30/07/13.
//  Copyright (c) 2013 Kschaeffler. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSRangeSliderDelegate;

@interface KSRangeSlider : UIView
{
    UIImageView *_outerView;
    UIImageView *_innerView;
    UIImageView *_leftThumbView;
    UIImageView *_rightThumbView;
    
    NSInteger _maxValue;
    NSInteger _minValue;
    CGFloat _leftValue;
    CGFloat _rightValue;
}

@property (weak, readwrite, nonatomic) id<KSRangeSliderDelegate> delegate;
@property (assign, readwrite, nonatomic) NSInteger length;
@property (assign, readonly, nonatomic) CGFloat leftValue;
@property (assign, readonly, nonatomic) CGFloat rightValue;
@property (assign, readwrite, nonatomic) NSInteger threshold;
@property (assign, readwrite, nonatomic) NSInteger minRange;

- (void)setLeftPanAtValue:(CGFloat)value;
- (void)setRightPanAtValue:(CGFloat)value;
- (void)setLeftPanAtValue:(CGFloat)leftValue rightPanAtValue:(CGFloat)rightValue;

@end

@protocol KSRangeSliderDelegate <NSObject>

- (void)rangeSlider:(KSRangeSlider *)rangeSlider didChangeLeftValue:(NSNumber *)leftValue rightValue:(NSNumber *)rightValue;

@optional;
- (void)rangeSlider:(KSRangeSlider *)rangeSlider didFinishGestureWithLeftPanOrRightPan:(BOOL)left;

@end

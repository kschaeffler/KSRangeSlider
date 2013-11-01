//
//  KSRangeSlider.m
//  Kschaeffler
//
//  Created by Karl Schaeffler on 30/07/13.
//  Copyright (c) 2013 Kschaeffler. All rights reserved.
//

#import "KSRangeSlider.h"

#define kDefaultWidth 300

@implementation KSRangeSlider
{
    NSInteger _thumbHeight;
    NSInteger _thumbWidth;
    NSInteger _barHeight;
}

- (void)calculateSizes
{
    _thumbHeight = [UIImage imageNamed:@"slider_handle.png"].size.height;
    _thumbWidth = [UIImage imageNamed:@"slider_handle.png"].size.width;
    _barHeight = [UIImage imageNamed:@"slider_bar_inactive.png"].size.height;
}

- (instancetype)init {
    [self calculateSizes];
    self = [super initWithFrame:CGRectMake(0, 0, kDefaultWidth, _thumbHeight)];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    [self calculateSizes];
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    [self calculateSizes];
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.threshold = _thumbWidth / 2;

    _outerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width+_thumbWidth*2, _barHeight)];
    _outerView.image = [[UIImage imageNamed:@"slider_bar_inactive.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [self addSubview:_outerView];
    
    _maxValue = 100;
    _minValue = 0;
    
    _leftValue = 0;
    _rightValue = 100;
    
    _innerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height / 2 - 3, self.frame.size.width - _thumbWidth/2, _barHeight)];
    _innerView.image = [[UIImage imageNamed:@"slider_bar_active.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [self addSubview:_innerView];
    
    _leftThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _thumbWidth, _thumbHeight)];
    _leftThumbView.image = [UIImage imageNamed:@"slider_handle.png"];
    _leftThumbView.contentMode = UIViewContentModeLeft;
    _leftThumbView.userInteractionEnabled = YES;
    _leftThumbView.clipsToBounds = YES;
    [self addSubview:_leftThumbView];
    
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    [_leftThumbView addGestureRecognizer:leftPan];
    
    _rightThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - _thumbWidth/2, 0, _thumbWidth, _thumbHeight)];
    _rightThumbView.image = [UIImage imageNamed:@"slider_handle.png"];
    _rightThumbView.contentMode = UIViewContentModeRight;
    _rightThumbView.userInteractionEnabled = YES;
    _rightThumbView.clipsToBounds = YES;
    [self addSubview:_rightThumbView];
    
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [_rightThumbView addGestureRecognizer:rightPan];
}

- (void)layoutSubviews
{
    CGFloat availableWidth = self.frame.size.width - _thumbWidth;
    CGFloat inset = _thumbWidth / 2;
    
    CGFloat range = _maxValue - _minValue;
    
    CGFloat left = floorf((_leftValue - _minValue) / range * availableWidth);
    CGFloat right = floorf((_rightValue - _minValue) / range * availableWidth);
    
    if (isnan(left)) left = 0;
    if (isnan(right)) right = 0;
    
    _leftThumbView.center = CGPointMake(inset + left, _thumbWidth/2);
    _rightThumbView.center = CGPointMake(inset + right, _thumbWidth/2);
    
    CGRect frame = _innerView.frame;
    frame.origin.x = _leftThumbView.frame.origin.x + _threshold;
    frame.size.width = _rightThumbView.frame.origin.x + _rightThumbView.frame.size.width - _threshold - frame.origin.x;
    _innerView.frame = frame;
    
    _outerView.frame = CGRectMake(_thumbWidth/2, self.frame.size.height / 2 - 3, self.frame.size.width - 1 - _threshold * 2, _outerView.image.size.height);
}

#pragma mark - UIGestureRecognizer delegate methods

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGFloat range = _maxValue - _minValue;
        CGFloat availableWidth = self.frame.size.width - _thumbWidth;
        _leftValue += translation.x / availableWidth * range;
        if (_leftValue < 0) _leftValue = 0;
        
        if (_rightValue - _leftValue < [self minRangeValue]) _leftValue = _rightValue - [self minRangeValue];
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
            
        [self notifyChangeValueDelegate];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self notifyFinishGestureDelegateWithPan:YES];
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGFloat range = _maxValue - _minValue;
        CGFloat availableWidth = self.frame.size.width - _thumbWidth;
        _rightValue += translation.x / availableWidth * range;
        
        if (_rightValue > 100) _rightValue = 100;
        if (_rightValue - _leftValue < [self minRangeValue]) _rightValue = _leftValue + [self minRangeValue];
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
        
        [self notifyChangeValueDelegate];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self notifyFinishGestureDelegateWithPan:NO];
        
}

- (NSInteger)minRangeValue
{
    return (CGFloat)self.minRange / _length * 100.0f;
}

- (void)setLeftPanAtValue:(CGFloat)value
{
    _leftValue = value / _length * 100.0f ;
    [self notifyChangeValueDelegate];
}

- (void)setRightPanAtValue:(CGFloat)value
{
    _rightValue = value / _length * 100.0f ;
    [self notifyChangeValueDelegate];
}

- (void)setLeftPanAtValue:(CGFloat)leftValue rightPanAtValue:(CGFloat)rightValue
{
    _leftValue = leftValue / _length * 100.0f ;
    _rightValue = rightValue / _length * 100.0f ;
    [self notifyChangeValueDelegate];
}

#pragma mark - Delegate methods

- (void)notifyChangeValueDelegate
{
    if ([_delegate respondsToSelector:@selector(rangeSlider:didChangeLeftValue:rightValue:)])
        [_delegate rangeSlider:self didChangeLeftValue:[NSNumber numberWithFloat:self.leftValue] rightValue:[NSNumber numberWithFloat:self.rightValue]];
}

- (void)notifyFinishGestureDelegateWithPan:(BOOL)left
{
    if ([self.delegate respondsToSelector:@selector(rangeSlider:didFinishGestureWithLeftPanOrRightPan:)])
        [self.delegate rangeSlider:self didFinishGestureWithLeftPanOrRightPan:NO];
}

#pragma mark - Properties

- (CGFloat)leftValue
{
    return _leftValue * _length / 100.0f;
}

- (CGFloat)rightValue
{
    return _rightValue * _length / 100.0f;
}

@end
//
//  KSViewController.m
//  KSRangeSlider
//
//  Created by Karl Schaeffler on 30/10/2013.
//  Copyright (c) 2013 kschaeffler. All rights reserved.
//

#import "KSViewController.h"
#import "KSRangeSlider.h"

//Slider type
enum KSRangeSliderType {
    slider1 = 0,
    slider2
};

@interface KSViewController () <KSRangeSliderDelegate>

@property (nonatomic, strong) IBOutlet KSRangeSlider *ibRangeSlider;

@end

@implementation KSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Add range slider programatically
    KSRangeSlider *rangeSlider = [[KSRangeSlider alloc] initWithFrame:CGRectMake(15, 40, 300, 35)];
    rangeSlider.length = 250;
    rangeSlider.minRange = 40;
    rangeSlider.delegate = self;
    rangeSlider.tag = slider1;
    [self.view addSubview:rangeSlider];
    
    //Init interface builder range slider
    self.ibRangeSlider.length = 200;
    self.ibRangeSlider.minRange = 50;
    self.ibRangeSlider.delegate = self;
    self.ibRangeSlider.tag = slider2;
    
}

- (void)rangeSlider:(KSRangeSlider *)rangeSlider didChangeLeftValue:(NSNumber *)leftValue rightValue:(NSNumber *)rightValue
{
    if (rangeSlider.tag == slider1){
        NSLog(@"slider1 left %@", leftValue);
        NSLog(@"slider1 right %@", rightValue);
    } else if (rangeSlider.tag == slider2) {
        NSLog(@"slider2 left %@", leftValue);
        NSLog(@"slider2 right %@", rightValue);
    }
    
}

- (void)rangeSlider:(KSRangeSlider *)rangeSlider didFinishGestureWithLeftPanOrRightPan:(BOOL)left
{
    NSString *pan = (left) ? @"left" : @"right";
    
    NSLog(@"gesture ended with %@ pan", pan);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

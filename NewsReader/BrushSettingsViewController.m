//
//  SettingsViewController.m
//  NewsReader
//
//  Created by Alexey on 20.11.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

#import "BrushSettingsViewController.h"
#import "DrawingViewController.h"

@interface BrushSettingsViewController ()

@end

@implementation BrushSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.brushSizeSlider.value = self.brushSize;
    self.opacitySlider.value = self.opacity;
    self.redSlider.value = self.red * 255.0;
    self.greenSlider.value = self.green * 255.0;
    self.blueSlider.value = self.blue * 255.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self previewRedraw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - Helpers

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// MARK: - Actions

- (IBAction)brushSizeSliderChanged:(UISlider *)sender {
    self.brushSize = sender.value;
    [self previewRedraw];
}

- (IBAction)opacitySliderChanged:(UISlider *)sender {
    self.opacity = sender.value;
    [self previewRedraw];
}

- (IBAction)rgbSlidersChanged:(id)sender {
    self.red = self.redSlider.value / 255.0;
    self.green = self.greenSlider.value / 255.0;
    self.blue = self.blueSlider.value / 255.0;
    [self previewRedraw];
}

- (void)previewRedraw {
    CGFloat graphicsScale = [[UIScreen mainScreen] scale];
    CGFloat positionX = self.previewImageView.frame.size.width * graphicsScale / 2;
    CGFloat positionY = self.previewImageView.frame.size.height * graphicsScale / 2;
    CGSize previewSize = CGSizeMake(self.previewImageView.frame.size.width * graphicsScale, self.previewImageView.frame.size.height * graphicsScale);
    
    UIGraphicsBeginImageContext(previewSize);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brushSize);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), positionX, positionY);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), positionX, positionY);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    self.previewImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

// MARK: - UIBarPositioningDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"BrushSettingsExitSegue"]) {
        DrawingViewController *destination = [segue destinationViewController];
        
        destination.red = self.red;
        destination.green = self.green;
        destination.blue = self.blue;
        destination.brushSize = self.brushSize;
        destination.opacity = self.opacity;
    }
}

@end

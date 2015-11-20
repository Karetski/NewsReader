//
//  SettingsViewController.m
//  NewsReader
//
//  Created by Alexey on 20.11.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

#import "SettingsViewController.h"
#import "DrawingViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    self.brushSizeSlider.value = self.brushSize;
    self.opacitySlider.value = self.opacity;
    self.redSlider.value = self.red * 255.0;
    self.greenSlider.value = self.green * 255.0;
    self.blueSlider.value = self.blue * 255.0;
    [self previewRedraw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - UIBarPositioningDelegate

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
    UIGraphicsBeginImageContext(self.previewImageView.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brushSize);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
    CGFloat position = self.previewImageView.frame.size.width/2;
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), position, position);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), position, position);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.previewImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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

//
//  DrawingViewController.m
//  NewsReader
//
//  Created by Alexey on 20.11.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

#import "DrawingViewController.h"

@interface DrawingViewController ()

@end

@implementation DrawingViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    self.red = 0.0/255.0;
    self.green = 0.0/255.0;
    self.blue = 0.0/255.0;
    self.brushSize = 7.5;
    self.opacity = 1;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self drawClearImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// MARK - Button actions

- (IBAction)presetButtonAction:(id)sender {
    UIButton *pressedButton = (UIButton*)sender;
    if (pressedButton.tag == 0) {
        self.red = 0.0;
        self.green = 0.0;
        self.blue = 0.0;
    } else if (pressedButton.tag == 1) {
        self.red = 1.0;
        self.green = 1.0;
        self.blue = 1.0;
    } else if (pressedButton.tag == 2) {
        self.red = 1.0;
        self.green = 0.0;
        self.blue = 0.0;
    } else if (pressedButton.tag == 3) {
        self.red = 0.0;
        self.green = 0.0;
        self.blue = 1.0;
    }
}

- (IBAction)refreshButtonAction:(id)sender {
    self.mainDrawImage.image = nil;
    [self drawClearImage];
}

- (IBAction)shareButtonAction:(id)sender {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.mainDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *savingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *activityItems = [[NSArray alloc] initWithObjects: savingImage, nil];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}


// MARK - Helpers

- (void)drawClearImage {
    UIImage *drawingImage = [self.sourceImage copy];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.mainDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    int drawingImageWidth = self.view.frame.size.width;
    int drawingImageHeight = self.view.frame.size.width / drawingImage.size.width * drawingImage.size.height;
    int drawingImageVertPosition = (self.view.frame.size.height / 2) - (drawingImageHeight / 2);
    
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
    
    [drawingImage drawInRect:CGRectMake(0, drawingImageVertPosition, drawingImageWidth, drawingImageHeight)];
    
    self.mainDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

// MARK: - UIBarPositioningDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

// MARK: - Drawing

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brushSize);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha: self.opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brushSize);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainDrawImage.frame.size);
    [self.mainDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha: self.opacity];
    self.mainDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

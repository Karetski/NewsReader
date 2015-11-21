//
//  DrawingViewController.m
//  NewsReader
//
//  Created by Alexey on 20.11.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

#import "DrawingViewController.h"
#import "BrushSettingsViewController.h"

@interface DrawingViewController ()

@property (nonatomic) CGRect drawingSpace;

@property (nonatomic) CGFloat graphicsScale;
@property (nonatomic) CGRect scaledDrawingSpace;
@property (nonatomic) CGRect scaledDrawingContext;

@end

@implementation DrawingViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    self.red = 30.0/255.0;
    self.green = 30.0/255.0;
    self.blue = 30.0/255.0;
    self.brushSize = 7.5;
    self.opacity = 0.9;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self calculateDrawingSpace];
    [self drawImageBounds];
    [self drawCleanImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - Actions

- (IBAction)presetButtonAction:(id)sender {
    UIButton *pressedButton = (UIButton*)sender;
    if (pressedButton.tag == 0) {
        self.red = 30.0/255.0;
        self.green = 30.0/255.0;
        self.blue = 30.0/255.0;
    } else if (pressedButton.tag == 1) {
        self.red = 250.0/255.0;
        self.green = 250.0/255.0;
        self.blue = 250.0/255.0;
    } else if (pressedButton.tag == 2) {
        self.red = 254.0/255.0;
        self.green = 48.0/255.0;
        self.blue = 24.0/255.0;
    } else if (pressedButton.tag == 3) {
        self.red = 48.0/255.0;
        self.green = 135.0/255.0;
        self.blue = 246.0/255.0;
    }
}

- (IBAction)refreshButtonAction:(id)sender {
    self.mainDrawImage.image = nil;
    [self drawCleanImage];
}

- (IBAction)shareButtonAction:(id)sender {
    UIImage *savingImage = [self getSubImageFrom:self.mainDrawImage.image withRect:self.drawingSpace];
    
    NSArray *activityItems = [[NSArray alloc] initWithObjects: savingImage, nil];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)showHideGesture:(id)sender {
    NSLog(@"asdasdasd");
}

// MARK - Unwind segues

- (IBAction)brushSettingsExitSegue:(UIStoryboardSegue *)segue {
}

// MARK - Helpers

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)calculateDrawingSpace {
    UIImage *drawingImage = [self.sourceImage copy];
    
    int drawingImageWidth;
    int drawingImageHeight;
    
    if (drawingImage.size.width >= self.view.frame.size.width) {
        drawingImageWidth = self.view.frame.size.width;
        drawingImageHeight = self.view.frame.size.width / drawingImage.size.width * drawingImage.size.height;
    } else if (drawingImage.size.height >= self.view.frame.size.height) {
        drawingImageWidth = self.view.frame.size.height / drawingImage.size.height * drawingImage.size.width;
        drawingImageHeight = self.view.frame.size.height;
    } else {
        drawingImageWidth = drawingImage.size.width;
        drawingImageHeight = drawingImage.size.height;
    }
    
    int drawingImageVertPosition = (self.view.frame.size.height / 2) - (drawingImageHeight / 2);
    int drawingImageHorizPosition = (self.view.frame.size.width / 2) - (drawingImageWidth / 2);
    
    self.graphicsScale = [[UIScreen mainScreen] scale];
    
    self.drawingSpace = CGRectMake(drawingImageHorizPosition, drawingImageVertPosition, drawingImageWidth, drawingImageHeight);
    self.scaledDrawingSpace = CGRectMake(drawingImageHorizPosition * self.graphicsScale, drawingImageVertPosition * self.graphicsScale, drawingImageWidth * self.graphicsScale, drawingImageHeight * self.graphicsScale);
    self.scaledDrawingContext = CGRectMake(0, 0, self.view.frame.size.width * self.graphicsScale, self.view.frame.size.height * self.graphicsScale);
}

- (void)drawImageBounds {
    UIGraphicsBeginImageContext(self.scaledDrawingContext.size);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 30.0/255.0, 30.0/255.0, 30.0/255.0, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokeRect(UIGraphicsGetCurrentContext(), self.scaledDrawingSpace);
    
    self.boundsImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)drawCleanImage {
    UIImage *drawingImage = [self.sourceImage copy];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.mainDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [drawingImage drawInRect:self.drawingSpace];
    
    self.mainDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (UIImage*)getSubImageFrom:(UIImage*)img withRect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    [img drawInRect:drawRect];
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
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

// Mark: - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"BrushSettingsSegue"]) {
        BrushSettingsViewController *destination = [segue destinationViewController];
        
        destination.red = self.red;
        destination.green = self.green;
        destination.blue = self.blue;
        destination.brushSize = self.brushSize;
        destination.opacity = self.opacity;
    }
}

@end

//
//  DrawingViewController.h
//  NewsReader
//
//  Created by Alexey on 20.11.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingViewController : UIViewController <UIBarPositioningDelegate> {
    CGPoint lastPoint;
    BOOL mouseSwiped;
}

@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) CGFloat blue;
@property (nonatomic) CGFloat brushSize;
@property (nonatomic) CGFloat opacity;

@property (strong, nonatomic) UIImage *sourceImage;

@property (weak, nonatomic) IBOutlet UIImageView *mainDrawImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIImageView *boundsImageView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

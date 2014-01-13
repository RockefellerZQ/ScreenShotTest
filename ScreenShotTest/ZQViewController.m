//
//  ZQViewController.m
//  ScreenShotTest
//
//  Created by Admin on 14-1-4.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import "ZQViewController.h"

@interface ZQViewController ()

@property (weak, nonatomic) IBOutlet UIView *transformView;

@end

CGImageRef UIGetScreenImage();

@implementation ZQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    CATransform3D transforma = CATransform3DIdentity;
//    transforma.m34 = 0.005;
//    transforma = CATransform3DRotate(transforma, 45.0 * M_PI / 180.0, 0, 1, 0);
//    self.transformView.layer.transform = transforma;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 0.005;
    float angle = -45 * M_PI / 180.0;
    transform = CATransform3DRotate(transform, angle, 0, 1, 0);
    self.transformView.layer.transform = transform;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)screenShot:(id)sender {
//    方法一：
//    UIScreen *mainScreen = [UIScreen mainScreen];
//    CGSize windowSize = self.view.window.frame.size;
//    if ([mainScreen respondsToSelector:@selector(scale)]) {
//        UIGraphicsBeginImageContextWithOptions(windowSize, NO, mainScreen.scale);
//    } else {
//        UIGraphicsBeginImageContext(windowSize);
//    }
//
//    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, nil);
    
//    方法二：
//    CGImageRef imageRef = UIGetScreenImage();
//    UIImage *image = [UIImage imageWithCGImage:imageRef];
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
//    方法三：
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGSize windowSize = self.view.window.frame.size;
    if ([mainScreen respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(windowSize, NO, mainScreen.scale);
    } else {
        UIGraphicsBeginImageContext(windowSize);
    }
    
    if ([self.view.window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self.view.window drawViewHierarchyInRect:self.view.window.bounds afterScreenUpdates:YES];
    } else {
        [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, nil);
}

@end

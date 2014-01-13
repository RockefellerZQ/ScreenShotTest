###ScreenShotTest
---
####关于UIView进行3D转换之后截图的问题
---
在view上面添加了一个transformView，并对其进行变换
```objective-c
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 0.005;
    float angle = -45 * M_PI / 180.0;
    transform = CATransform3DRotate(transform, angle, 0, 1, 0);
    self.transformView.layer.transform = transform;
```
<!-- more -->
接下来我们实现截图的代码, 一般情况下，我们会这样实现一个简单的截图功能：

**方法一：**
```objective-c
//    方法一：
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGSize windowSize = self.view.window.frame.size;
    if ([mainScreen respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(windowSize, NO, mainScreen.scale);
    } else {
        UIGraphicsBeginImageContext(windowSize);
    }
    
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, nil);
```
将截图与实现了3DTransform的视图进行对比，我们发现自定义的截图功能并不是我们想要的。 

**截图前视图与截取的图片对比：**  

![ScreenImage1](/images/3DTranformScreenShot/screen1.png) ![ScreenImage2](/images/3DTranformScreenShot/screen2.png) 

那么如何解决这个问题呢？我们在实现文件中声明这样一个方法：   `CGImageRef UIGetScreenImage()`
替换之前我们实现的**方法一** 如下：

**方法二：**
```objective-c
//    方法二：
    CGImageRef imageRef = UIGetScreenImage();
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
```
这样我们的截图就能像原视图那样带有3D变换的效果了：

<img src="/images/3DTranformScreenShot/screen1.png" alt="ScreenImage" text-align=center>

由于`CGImageRef UIGetScreenImage()`属于私有API所以不需要我们实现这个方法，如果是在IOS7下，我们还有一种方法可以实现，替换之前实现的方法二：

**方法三：**
```objective-c
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
```
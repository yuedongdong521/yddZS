//
//  UIImage+ScallGif.m
//  iShow
//
//  Created by ydd on 2018/8/22.
//

#import "UIImage+ScallGif.h"
#import <CoreGraphics/CoreGraphics.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (ScallGif)

+ (NSData*)scallGIFWithData:(NSData*)data scallSize:(CGSize)scallSize {
  if (!data) {
    return nil;
  }
  CGImageSourceRef source =
      CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
  size_t count = CGImageSourceGetCount(source);

  // 设置 gif 文件属性 (0:无限次循环)
  NSDictionary* fileProperties = [self filePropertiesWithLoopCount:0];

  NSString* tempFile =
      [NSTemporaryDirectory() stringByAppendingString:@"scallTemp.gif"];
  NSFileManager* manager = [NSFileManager defaultManager];
  if ([manager fileExistsAtPath:tempFile]) {
    [manager removeItemAtPath:tempFile error:nil];
  }
  NSURL* fileUrl = [NSURL fileURLWithPath:tempFile];
  CGImageDestinationRef destination = CGImageDestinationCreateWithURL(
      (__bridge CFURLRef)fileUrl, kUTTypeGIF, count, NULL);

  NSTimeInterval duration = 0.0f;
  for (size_t i = 0; i < count; i++) {
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
    UIImage* image = [UIImage imageWithCGImage:imageRef];
    UIImage* scallImage = [image scallImageWidthScallSize:scallSize];

    NSTimeInterval delayTime = [self frameDurationAtIndex:i source:source];
    duration += delayTime;
    // 设置 gif 每针画面属性
    NSDictionary* frameProperties =
        [self framePropertiesWithDelayTime:delayTime];
    CGImageDestinationAddImage(destination, scallImage.CGImage,
                               (CFDictionaryRef)frameProperties);
    CGImageRelease(imageRef);
  }
  CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
  // Finalize the GIF
  if (!CGImageDestinationFinalize(destination)) {
    NSLog(@"Failed to finalize GIF destination");
    if (destination != nil) {
      CFRelease(destination);
    }
    if (source) {
      CFRelease(source);
    }
    return nil;
  }
  CFRelease(destination);
  CFRelease(source);
  return [NSData dataWithContentsOfFile:tempFile];
}

+ (float)frameDurationAtIndex:(NSUInteger)index
                       source:(CGImageSourceRef)source {
  float frameDuration = 0.1f;
  CFDictionaryRef cfFrameProperties =
      CGImageSourceCopyPropertiesAtIndex(source, index, nil);
  NSDictionary* frameProperties = (__bridge NSDictionary*)cfFrameProperties;
  NSDictionary* gifProperties =
      frameProperties[(NSString*)kCGImagePropertyGIFDictionary];

  NSNumber* delayTimeUnclampedProp =
      gifProperties[(NSString*)kCGImagePropertyGIFUnclampedDelayTime];
  if (delayTimeUnclampedProp) {
    frameDuration = [delayTimeUnclampedProp floatValue];
  } else {
    NSNumber* delayTimeProp =
        gifProperties[(NSString*)kCGImagePropertyGIFDelayTime];
    if (delayTimeProp) {
      frameDuration = [delayTimeProp floatValue];
    }
  }

  if (frameDuration < 0.011f) {
    frameDuration = 0.100f;
  }
  CFRelease(cfFrameProperties);
  frameDuration += 0.1;
  return frameDuration;
}

- (UIImage*)scallImageWidthScallSize:(CGSize)scallSize {
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;

  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = scallSize.width;
  CGFloat scaledHeight = scallSize.height;
  CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

  if (!CGSizeEqualToSize(self.size, scallSize)) {
    CGFloat widthFactor = scaledWidth / width;
    CGFloat heightFactor = scaledHeight / height;

    scaleFactor = MAX(widthFactor, heightFactor);

    scaledWidth = width * scaleFactor;
    scaledHeight = height * scaleFactor;

    // center the image
    if (widthFactor > heightFactor) {
      thumbnailPoint.y = (scallSize.height - scaledHeight) * 0.5;
    } else if (widthFactor < heightFactor) {
      thumbnailPoint.x = (scallSize.width - scaledWidth) * 0.5;
    }
  }
  CGRect rect;
  rect.origin = thumbnailPoint;
  rect.size = CGSizeMake(scaledWidth, scaledHeight);
  UIGraphicsBeginImageContext(rect.size);
  [self drawInRect:rect];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (NSDictionary*)filePropertiesWithLoopCount:(int)loopCount {
  return @{
    (NSString*)kCGImagePropertyGIFDictionary :
        @{(NSString*)kCGImagePropertyGIFLoopCount : @(loopCount)}
  };
}

+ (NSDictionary*)framePropertiesWithDelayTime:(NSTimeInterval)delayTime {
  return @{
    (NSString*)kCGImagePropertyGIFDictionary :
        @{(NSString*)kCGImagePropertyGIFDelayTime : @(delayTime)},
    (NSString*)
    kCGImagePropertyColorModel : (NSString*)kCGImagePropertyColorModelRGB
  };
}

@end

//
//  UIImage+MusicBar.m
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/31/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "UIImage+MusicBar.h"

@implementation UIImage (MusicBar)

+ (UIImage*)mb_imageFromView:(UIView*)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);

    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

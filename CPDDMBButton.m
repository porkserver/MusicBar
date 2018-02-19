//
//  CPDDMBButton.m
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 02/19/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "CPDDMBButton.h"

@implementation CPDDMBButton

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect newArea = CGRectMake(self.bounds.origin.x - 10, self.bounds.origin.y - 10, self.bounds.size.width + 20, self.bounds.size.height + 20);
    return CGRectContainsPoint(newArea, point);
}

@end

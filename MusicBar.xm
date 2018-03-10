//
//  MusicBar.xm
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/30/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "MusicBar.h"
#import "CPDDMBBarController.h"

static void handleTouches(NSSet *touches) {
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps == 2) {
         SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
        if([iconController _isAppIconForceTouchControllerPeekingOrShowing]) {

            [iconController _dismissAppIconForceTouchControllerIfNecessaryAnimated:YES withCompletionHandler:^{
                musicBarBlock();
            }];
        } else {
            musicBarBlock();
    }
}

static void addGesture(id self, UIView *target) {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [target addGestureRecognizer:tapGesture];
    [tapGesture release];
}


%hook SpringBoard



    void(^musicBarBlock)(void)  = ^(void) {
        if([CPDDMBBarController sharedInstance].isPresented || [CPDDMBBarController sharedInstance].isPresenting) {
            [[CPDDMBBarController sharedInstance] dismissWithCompletion:nil];
        } else {
            [CPDDMBBarController sharedInstance].isPresenting = YES;
            [[CPDDMBBarController sharedInstance] presentWithCompletion:nil];
        }
    };
        handleTouches();
        
        }
        
        return NO;

    }

    return %orig;
}

%end

%hook SBFolderContainerView

%property (nonatomic, retain) NSNumber *forcedBoundsYOffset;

- (CGRect)bounds {
    CGRect orig = %orig;
    if (self.forcedBoundsYOffset) {
        orig.origin.y -= (CGFloat)[self.forcedBoundsYOffset doubleValue];
    }
    return orig;
}
%end

%hook SBIconController
-(void)iconTapped:(id)arg1 {
    if([CPDDMBBarController sharedInstance].isPresented || [CPDDMBBarController sharedInstance].isPresenting) {
        [[CPDDMBBarController sharedInstance] dismissWithCompletion:^{
            %orig;
        }];
        return;
    }
    %orig;
}
%end

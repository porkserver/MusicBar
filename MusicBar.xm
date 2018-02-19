//
//  MusicBar.xm
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/30/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "MusicBar.h"
#import "CPDDMBBarController.h"

%hook SpringBoard

- (BOOL)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1 {

	/*
		Thanks Ziph0n for this hook and doing the work on reversing the button types. Who knew I'd be reading a thread on a random post and find something so useful for this project

		https://www.reddit.com/r/jailbreak/comments/7u2vcv/upcoming_unitether_a_semi_untether_for_ios_9x_10x/dthmiwa/
	*/

    int type = arg1.allPresses.allObjects[0].type;
    int force = arg1.allPresses.allObjects[0].force;

    if((type == 102) && (force == 1)) {
    	if([CPDDMBBarController sharedInstance].isPresented || [CPDDMBBarController sharedInstance].isPresenting) {
    		[[CPDDMBBarController sharedInstance] dismissWithCompletion:^{
    			NSLog(@"Dismissed");
    		}];
    	} else {
    		[CPDDMBBarController sharedInstance].isPresenting = YES;
    		[[CPDDMBBarController sharedInstance] presentWithCompletion:^{
                NSLog(@"Presented");
    		}];
    	}

    	return NO;

    }

    return %orig;
}

%end

%ctor {
	NSLog(@"MusicBar Init");
}

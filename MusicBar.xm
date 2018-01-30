//
//  MusicBar.xm
//  MusicBar
//
//  Created by CP Digital Darkroom <tweaks@cpdigitaldarkroom.support> on 01/30/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "MusicBar.h"
#import "CPDDMBPrefManager.h"

%ctor{
    [CPDDMBPrefManager sharedPrefs];
}

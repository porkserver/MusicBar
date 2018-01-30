//
//  CPDDMBPrefManager.h
//  MusicBar
//
//  Created by CP Digital Darkroom <tweaks@cpdigitaldarkroom.support> on 01/30/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

@interface CPDDMBPrefManager : NSObject

@property (nonatomic, readonly) BOOL 	isEnabled;

+ (instancetype)sharedPrefs;

@end

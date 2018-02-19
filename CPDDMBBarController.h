//
//  CPDDMBBarController.h
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/30/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

@interface CPDDMBBarController : NSObject

+ (instancetype)sharedInstance;

@property (assign, nonatomic) BOOL isPresenting;

@property (assign, nonatomic) BOOL isPresented;

@property (assign, nonatomic) BOOL needsStatusBar;

- (void)dismissWithCompletion:(void(^)(void))completion;

- (void)presentWithCompletion:(void(^)(void))completion;

@end

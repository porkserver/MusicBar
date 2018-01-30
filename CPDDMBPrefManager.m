//
//  CPDDMBPrefManager.m
//  MusicBar
//
//  Created by CP Digital Darkroom <tweaks@cpdigitaldarkroom.support> on 01/30/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "CPDDMBPrefManager.h"
#import "MusicBar.h"
#import <notify.h>

@interface CPDDMBPrefManager ()

@property (nonatomic, readonly) int token;
@property (nonatomic, readonly) NSDictionary *preferences;

@end

static NSString * const MBEnableKey = @"MBEnableKey";


@implementation CPDDMBPrefManager

@synthesize preferences = _preferences;

+ (instancetype)sharedPrefs {
    static CPDDMBPrefManager *sharedPrefs = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedPrefs = [[self alloc] init];
    });
    return sharedPrefs;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        [self release];
        return nil;
    }

    int token = 0;
    __block CPDDMBPrefManager *blockSelf = self;
    notify_register_dispatch("com.cpdigitaldarkroom.musicbar.settings", &token, dispatch_get_main_queue(), ^(int token) {
        blockSelf->_preferences = nil;
    });
    _token = token;
    return self;
}

- (void)dealloc {
    notify_cancel(self.token);

    [super dealloc];
}

- (NSDictionary *)preferences {
    if (!_preferences) {
    	CFStringRef appID = CFSTR(kPrefDomain);
    	CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    	if (!keyList) {
    		return nil;
    	}
    _preferences = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFRelease(keyList);
	}

    return _preferences;
}

- (BOOL)isEnabled {
    return (self.preferences[MBEnableKey] ? [self.preferences[MBEnableKey] boolValue] : YES);
}

@end

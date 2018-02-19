//
//  MusicBar.h
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/30/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import <UIKit/UIImage+Private.h>

#define kPrefDomain "com.cpdigitaldarkroom.musicbar"

@interface CALayer (Private)
@property BOOL continuousCorners;
@end

@interface FBSDisplay : NSObject
@end

@interface FBDisplayManager : NSObject
+ (id)sharedInstance;
+ (FBSDisplay*)mainDisplay;
@end

@interface MediaControlsTimeControl : UIControl
-(void)_updateTimeControl;
@end

@interface MPVolumeViewController : UIViewController
@end

@interface MPVolumeView : UIView
@property (assign,nonatomic) BOOL showsVolumeSlider;
@property (assign,nonatomic) BOOL showsRouteButton;
-(BOOL)showsRouteButton;
- (instancetype)initWithFrame:(CGRect)frame style:(int)style;
@end

@interface MTMaterialView : UIView
+ (id)materialViewWithRecipe:(int)arg1 options:(int)arg2 initialWeighting:(CGFloat)arg3 ;
@end

@class MPUNowPlayingController;
@protocol MPUNowPlayingDelegate <NSObject>
@optional
- (void)nowPlayingControllerDidBeginListeningForNotifications:(MPUNowPlayingController *)controller;
- (void)nowPlayingControllerDidStopListeningForNotifications:(MPUNowPlayingController *)controller;
- (void)nowPlayingController:(MPUNowPlayingController *)controller nowPlayingInfoDidChange:(NSDictionary *)info;
- (void)nowPlayingController:(MPUNowPlayingController *)controller playbackStateDidChange:(BOOL)playing;
- (void)nowPlayingController:(MPUNowPlayingController *)controller nowPlayingApplicationDidChange:(NSString *)application;
- (void)nowPlayingController:(MPUNowPlayingController *)controller elapsedTimeDidChange:(NSTimeInterval)elapsed;
@end

@interface MPUNowPlayingController : NSObject {
	NSDictionary *_currentNowPlayingInfo;
}
@property (assign, nonatomic) id<MPUNowPlayingDelegate> delegate;
@property (nonatomic, readonly) NSDictionary *currentNowPlayingInfo;
@property (nonatomic, readonly) UIImage *currentNowPlayingArtwork;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) NSString *nowPlayingAppDisplayID;
@property (nonatomic, readonly) NSTimeInterval currentElapsed;
@property (nonatomic, readonly) NSTimeInterval currentDuration;
@property (assign, nonatomic) NSTimeInterval timeInformationUpdateInterval;
- (void)update;
- (void)startUpdating;
- (void)stopUpdating;
@end

@interface SBAppContainerView : UIView
@end

@interface SBAppContainerViewController : UIViewController
@property (nonatomic, retain) SBAppContainerView* view;
@end

@interface SBApplication : NSObject
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(NSString *)bundleID;
@end

@interface SBHomeScreenView : UIView
@end

@interface SBHomeScreenViewController : UIViewController
@end

@interface SBHomeScreenWindow : UIWindow
@property (nonatomic,readonly) SBHomeScreenViewController * homeScreenViewController;
@end

@interface SBIcon : NSObject
@property (nonatomic, retain) NSString* applicationBundleID;
-(NSString*)displayNameForLocation:(NSInteger)location;
-(UIImage*)generateIconImage:(int)arg1;
@end

@interface SBIconModel : NSObject
-(id)expectedIconForDisplayIdentifier:(NSString*)ident;
@end

@interface SBRootFolderView : UIView
@end

@interface SBRootFolderController : UIViewController
@property (nonatomic,readonly) SBRootFolderView * contentView;
@end

@interface SBIconController : NSObject
@property (nonatomic, retain) SBIconModel* model;
+ (id)sharedInstance;
- (id)dockListView;
- (SBRootFolderController *)_rootFolderController;
@end

@interface SBMainDisplaySceneLayoutViewController : UIViewController
- (SBAppContainerViewController *)_layoutElementViewContainerViewForLayoutRole:(int)role;
- (SBAppContainerViewController*)_layoutElementControllerForLayoutRole:(int)role;
- (CGRect)referenceFrameForIdentifier:(NSString*)identifier inLayoutState:(int)layoutState;
@end

@interface SBMainDisplaySceneManager : NSObject
@property (nonatomic,readonly) SBMainDisplaySceneLayoutViewController * sceneLayoutViewController;
- (SBMainDisplaySceneLayoutViewController*)layoutController;
@end

@interface SBMediaController : NSObject
@property (copy) SBApplication *nowPlayingApplication;
+ (id)sharedInstance;
@end

@interface SBSceneManagerCoordinator : NSObject
+ (id)sharedInstance;
- (SBMainDisplaySceneManager *)sceneManagerForDisplay:(FBSDisplay*)display;
- (SBMainDisplaySceneManager *)sceneManagerForDisplayIdentity:(FBSDisplay *)display ;
@end

@interface SBUIController : NSObject
@property (nonatomic, retain) SBHomeScreenWindow *window;
+ (id)sharedInstance;
- (void)activateApplication:(id)arg1;
- (void)_activateApplicationFromAccessibility:(id)arg1;
- (void)setHomeScreenBlurProgress:(CGFloat)blurProgress behaviorMode:(NSInteger)behavior completion:(void(^)(void))completion;
@end

@interface SBWallpaperController : NSObject
+(id)sharedInstance;
@end

@interface SBWallpaperEffectView : UIView
- (id)initWithWallpaperVariant:(long long)arg1;
- (void)setStyle:(int)style;
@end

@interface UIApplication (Private)
- (id)_accessibilityFrontMostApplication;
- (void)setStatusBarHidden:(BOOL)hidden duration:(CGFloat)duration;
@end

@interface UILabel (Private)
-(void) setMarqueeEnabled:(BOOL)marqueeEnabled;
-(void) setMarqueeRunning:(BOOL)marqueeRunning;
-(void) _startMarquee;
@end

@interface SBFolderContainerView : UIView
@property (nonatomic, retain) NSNumber *forcedBoundsYOffset;
@end

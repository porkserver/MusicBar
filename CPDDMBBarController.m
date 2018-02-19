//
//  CPDDMBBarController.m
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/30/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "CPDDMBBarController.h"
#import "CPDDMBBarView.h"
#import "MusicBar.h"
#import "UIImage+MusicBar.h"

@interface CPDDMBBarController () <MPUNowPlayingDelegate>

@property (assign, nonatomic) BOOL presentedOnSpringBoard;

@property (assign, nonatomic) CGRect originalFrame;
@property (assign, nonatomic) CGRect sbOriginalFrame;

@property (strong, nonatomic) CPDDMBBarView *barView;

@property (strong, nonatomic) MPUNowPlayingController *nowPlayingController;

@property (strong, nonatomic) UIView *contentViewContainerView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *touchEater;

@property (strong, nonatomic) UIImageView *wallpaperCopyImageView;

@end

@implementation CPDDMBBarController

+ (instancetype)sharedInstance {
    static CPDDMBBarController *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if(self = [super init]) {
        _nowPlayingController = [[MPUNowPlayingController alloc]init];
        _nowPlayingController.delegate = self;
        _sbOriginalFrame = CGRectZero;
    }
    return self;
}

- (SBHomeScreenView *)homescreenViewFromWindow:(SBHomeScreenWindow *)window {
    for(UIView *subview in window.subviews) {
        if([subview isKindOfClass:NSClassFromString(@"SBHomeScreenView")]) {
            HBLogInfo(@"Got Homescreen View");
            return (SBHomeScreenView *)subview;
        }
    }
    return nil;
}

- (void)animatePresentation {

    if(_presentedOnSpringBoard) {

        [[UIApplication sharedApplication] setStatusBarHidden:YES duration:0.5];

        [[NSClassFromString(@"SBUIController") sharedInstance] setHomeScreenBlurProgress:0.60 behaviorMode:0 completion:nil];

        SBRootFolderController *rootFolderController = [[NSClassFromString(@"SBIconController") sharedInstance] _rootFolderController];

        if (CGRectIsEmpty(_sbOriginalFrame)) {
            _originalFrame = rootFolderController.view.frame;
            _sbOriginalFrame = rootFolderController.view.frame;
        }

        SBFolderContainerView *containerView = (SBFolderContainerView *)rootFolderController.view;
        [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowAnimatedContent) animations:^{
            CGRect origBounds = containerView.bounds;
            origBounds.origin.y = -109;
            containerView.bounds = origBounds;
            containerView.forcedBoundsYOffset = [NSNumber numberWithDouble:109];
            containerView.frame = CGRectMake(rootFolderController.view.frame.origin.x, _sbOriginalFrame.origin.y-(109*2), rootFolderController.view.frame.size.width, rootFolderController.view.frame.size.height);

        } completion:^(BOOL finished) {
            if(finished) {
                _isPresenting = NO;
                _isPresented = YES;
            }
        }];

    } else {

        [[UIApplication sharedApplication] setStatusBarHidden:YES duration:0.5];

        [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowAnimatedContent) animations:^{
            _contentViewContainerView.frame = CGRectMake(_originalFrame.origin.x, _originalFrame.origin.y - 116, _originalFrame.size.width, _originalFrame.size.height);
        } completion:^(BOOL finished) {
            if(finished) {
                _isPresenting = NO;
                _isPresented = YES;
            }
        }];

    }
}

- (void)animateDismissalWithCompletion:(void(^)(void))completion {

    [[UIApplication sharedApplication] setStatusBarHidden:NO duration:0.1];

    if(_presentedOnSpringBoard) {
        SBRootFolderController *rootFolderController = [[NSClassFromString(@"SBIconController") sharedInstance] _rootFolderController];
        SBFolderContainerView *containerView = (SBFolderContainerView *)rootFolderController.view;
        [UIView animateWithDuration:0.2 delay:0.0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut) animations:^{
            containerView.frame = CGRectMake(_sbOriginalFrame.origin.x,109,_sbOriginalFrame.size.width, _sbOriginalFrame.size.height);
        } completion:^(BOOL finished){
            containerView.frame = _sbOriginalFrame;
            containerView.bounds = CGRectMake(0,0,_sbOriginalFrame.size.width, _sbOriginalFrame.size.height);
            containerView.forcedBoundsYOffset = nil;
            _sbOriginalFrame = CGRectZero;
            if (finished) {
                [_barView removeFromSuperview];
                _isPresented = NO;
                [[NSClassFromString(@"SBUIController") sharedInstance] setHomeScreenBlurProgress:0.0 behaviorMode:0 completion:nil];
                if(completion) {
                    completion();
                }
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 delay:0.0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut) animations:^{

            _contentViewContainerView.frame = _originalFrame;

        } completion:^(BOOL finished){
            if (finished) {

                [_barView removeFromSuperview];
                [_contentViewContainerView.superview insertSubview:_contentView aboveSubview:_contentViewContainerView];
                [_wallpaperCopyImageView removeFromSuperview];
                [_contentViewContainerView removeFromSuperview];
                [_contentView removeFromSuperview];
                _isPresented = NO;

                if(completion) {
                    completion();
                }
            }
        }];
    }

}

- (void)dismiss:(id)sender {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    [self animateDismissalWithCompletion:completion];
}

- (void)presentWithCompletion:(void(^)(void))completion {
    if ([[UIApplication sharedApplication] _accessibilityFrontMostApplication]) {
        _presentedOnSpringBoard = NO;
        [self prepareForPresentingFromApp];
        [self performCommonSetup];
        [self updateMediaInformation];
        [self animatePresentation];
    } else {
        _presentedOnSpringBoard = YES;
        [self prepareForPresentingFromSpringBoard];
        [self updateMediaInformation];
        [self animatePresentation];
    }
    completion();
}

- (void)prepareForPresentingFromApp {

    // Thanks Phillip for Snakebite, you should be able to use these changes to update Snakebit as well
    SBSceneManagerCoordinator* sceneManagerCoordinator = [NSClassFromString(@"SBSceneManagerCoordinator") sharedInstance];

    FBSDisplay* mainDisplay = [NSClassFromString(@"FBDisplayManager") mainDisplay];

    SBMainDisplaySceneManager* sceneManager = [sceneManagerCoordinator sceneManagerForDisplayIdentity:mainDisplay];

    SBMainDisplaySceneLayoutViewController* layoutController = sceneManager.sceneLayoutViewController;
    UIViewController* containerViewController = [layoutController _layoutElementViewContainerViewForLayoutRole:2];

    if (!containerViewController) {
        containerViewController = [NSClassFromString(@"SBMainSwitcherViewController") sharedInstance];
    }

    SBAppContainerView* view = (SBAppContainerView*)[containerViewController view];

    SBWallpaperController* wallpaperController = [NSClassFromString(@"SBWallpaperController") sharedInstance];
    UIView* wallpaperView = ([wallpaperController valueForKey:@"_sharedWallpaperView"]) ?: [wallpaperController valueForKey:@"_homescreenWallpaperView"];
    _wallpaperCopyImageView = [[UIImageView alloc] initWithImage:[UIImage mb_imageFromView:wallpaperView]];

    [view addSubview:_wallpaperCopyImageView];

    UIImageView* appCopyImageView = [[UIImageView alloc] initWithImage:[UIImage mb_imageFromView:view]];
    UIView *contentView = [[UIView alloc] initWithFrame:appCopyImageView.frame];

    [contentView addSubview:appCopyImageView];
    [view addSubview:contentView];


    _contentView = contentView;

}

- (void)prepareForPresentingFromSpringBoard {

    SBRootFolderController *rootFolderController = [[NSClassFromString(@"SBIconController") sharedInstance] _rootFolderController];

    _barView = [[CPDDMBBarView alloc] initWithFrame:CGRectZero];
    _barView.translatesAutoresizingMaskIntoConstraints = NO;
    _barView.userInteractionEnabled = YES;
    [rootFolderController.view addSubview:_barView];

    [rootFolderController.view addConstraint:[NSLayoutConstraint constraintWithItem:_barView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootFolderController.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:6]];
    [rootFolderController.view addConstraint:[NSLayoutConstraint constraintWithItem:_barView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootFolderController.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
    [rootFolderController.view addConstraint:[NSLayoutConstraint constraintWithItem:_barView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rootFolderController.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    [rootFolderController.view addConstraint:[NSLayoutConstraint constraintWithItem:_barView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:113]];
}

-(void)performCommonSetup {

    _originalFrame = _contentView.frame;

    _contentViewContainerView = [[UIView alloc] initWithFrame:_contentView.frame];
    _contentViewContainerView.clipsToBounds = NO;
    [_contentView.superview insertSubview:_contentViewContainerView belowSubview:_contentView];

    [_contentViewContainerView addSubview:_contentView];
    _contentView.layer.masksToBounds = YES;

    _touchEater = [[UIView alloc] initWithFrame:_contentViewContainerView.frame];
    _touchEater.userInteractionEnabled = YES;
    _touchEater.backgroundColor = [UIColor colorWithRed:0.08 green:0.07 blue:0.07 alpha:0.02];
    [_contentViewContainerView addSubview:_touchEater];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    singleTap.numberOfTapsRequired = 1;
    [_touchEater addGestureRecognizer:singleTap];

    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [_touchEater addGestureRecognizer:swipeDown];

    _barView = [[CPDDMBBarView alloc] initWithFrame:CGRectZero];
    _barView.translatesAutoresizingMaskIntoConstraints = NO;
    _barView.userInteractionEnabled = YES;

    [_contentViewContainerView.superview insertSubview:_barView belowSubview:_contentViewContainerView];

    [_contentViewContainerView.superview addConstraint:[NSLayoutConstraint constraintWithItem:_barView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentViewContainerView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8]];
    [_contentViewContainerView.superview addConstraint:[NSLayoutConstraint constraintWithItem:_barView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentViewContainerView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
    [_contentViewContainerView.superview addConstraint:[NSLayoutConstraint constraintWithItem:_barView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentViewContainerView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    [_contentViewContainerView.superview addConstraint:[NSLayoutConstraint constraintWithItem:_barView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:113]];
}

- (void)updateMediaInformation {

    NSString *artistText = _nowPlayingController.currentNowPlayingInfo[@"kMRMediaRemoteNowPlayingInfoArtist"] ?: @"Unknown";
    NSString *titleText = _nowPlayingController.currentNowPlayingInfo[@"kMRMediaRemoteNowPlayingInfoTitle"] ?: @"Unknown";

    if(_nowPlayingController.isPlaying) {
        if(_nowPlayingController.currentNowPlayingArtwork) {
            _barView.artworkImageView.image = _nowPlayingController.currentNowPlayingArtwork;
        }
    } else {
        artistText = @"";
        titleText = @"Music";
    }

    _barView.songArtistLabel.text = artistText;
    _barView.songTitleLabel.text = titleText;

    if(!_barView.artworkImageView.image) {
        _barView.artworkImageView.image = [UIImage _applicationIconImageForBundleIdentifier:_nowPlayingController.nowPlayingAppDisplayID ?: @"com.apple.Music" format:MIIconVariantDefault scale:[[UIScreen mainScreen] scale]];
    }
    _barView.isPlaying = _nowPlayingController.isPlaying;
}

#pragma mark - MPUNowPlayingDelegate

-(void)nowPlayingController:(id)arg1 nowPlayingInfoDidChange:(id)arg2 {

    if(_isPresented) {

        NSString *artistText = _nowPlayingController.currentNowPlayingInfo[@"kMRMediaRemoteNowPlayingInfoArtist"] ?: @"Unknown";
        NSString *titleText = _nowPlayingController.currentNowPlayingInfo[@"kMRMediaRemoteNowPlayingInfoTitle"] ?: @"Unknown";

        if(_nowPlayingController.isPlaying) {
            if(_nowPlayingController.currentNowPlayingArtwork) {
                _barView.artworkImageView.image = _nowPlayingController.currentNowPlayingArtwork;
            }
        } else {
            artistText = @"";
            titleText = @"Music";
        }

        _barView.songArtistLabel.text = artistText;
        _barView.songTitleLabel.text = titleText;

        if(_nowPlayingController.currentNowPlayingArtwork) {
            _barView.artworkImageView.image = _nowPlayingController.currentNowPlayingArtwork;
        }

        if(!_barView.artworkImageView.image) {
            _barView.artworkImageView.image = [UIImage _applicationIconImageForBundleIdentifier:_nowPlayingController.nowPlayingAppDisplayID ?: @"com.apple.Music" format:MIIconVariantDefault scale:[[UIScreen mainScreen] scale]];
        }
        _barView.isPlaying = _nowPlayingController.isPlaying;
    }

}

@end

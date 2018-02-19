//
//  CPDDMBBarView.m
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/31/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "CPDDMBBarController.h"
#import "CPDDMBBarView.h"
#import "MusicBar.h"
#import "MediaRemote.h"

@interface CPDDMBBarView ()

@property (strong, nonatomic) MPVolumeView *volumeSlider;
@property (strong, nonatomic) SBWallpaperEffectView *backgroundView;
@property (strong, nonatomic) UIButton *forwardButton;
@property (strong, nonatomic) UIButton *playPauseButton;

@end

@implementation CPDDMBBarView

- (instancetype)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {

		_backgroundView = [[NSClassFromString(@"SBWallpaperEffectView") alloc] initWithWallpaperVariant:1];
		_backgroundView.layer.continuousCorners = YES;
		_backgroundView.layer.cornerRadius = 30;
		[_backgroundView setStyle:12];
		_backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_backgroundView];

    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:93]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];

    	_artworkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    	_artworkImageView.layer.continuousCorners = YES;
		_artworkImageView.layer.cornerRadius = 13;
		_artworkImageView.layer.masksToBounds = YES;
    	_artworkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    	_artworkImageView.userInteractionEnabled = YES;
    	[self addSubview:_artworkImageView];

    	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleArtworkTapped:)];
    	singleTap.numberOfTapsRequired = 1;
    	[_artworkImageView addGestureRecognizer:singleTap];

    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_artworkImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_artworkImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_artworkImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_artworkImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15]];

    	UIImage *forwardImage = [UIImage imageNamed:@"Forward" inBundle:[NSBundle bundleWithPath:@"/Library/Application Support/MusicBar/ImageAssets.bundle"]];
    	if(!forwardImage) {
    		forwardImage = [UIImage imageNamed:@"Forward" inBundle:[NSBundle bundleWithPath:@"/bootstrap/Library/Application Support/MusicBar/ImageAssets.bundle"]];
    	}

    	_forwardButton = [[UIButton alloc] initWithFrame:CGRectZero];
    	[_forwardButton addTarget:self action:@selector(handleForwardButton:) forControlEvents:UIControlEventTouchUpInside];
    	[_forwardButton setImage:forwardImage forState:UIControlStateNormal];
    	[_forwardButton setImage:[forwardImage _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    	_forwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    	[self addSubview:_forwardButton];

    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_forwardButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_forwardButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_forwardButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_forwardButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24]];

    	UIImage *playImage = [UIImage imageNamed:@"Play" inBundle:[NSBundle bundleWithPath:@"/Library/Application Support/MusicBar/ImageAssets.bundle"]];
    	if(!playImage) {
    		playImage = [UIImage imageNamed:@"Play" inBundle:[NSBundle bundleWithPath:@"/bootstrap/Library/Application Support/MusicBar/ImageAssets.bundle"]];
    	}

    	_playPauseButton = [[UIButton alloc] initWithFrame:CGRectZero];
    	[_playPauseButton addTarget:self action:@selector(handlePlayPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    	[_playPauseButton setImage:playImage forState:UIControlStateNormal];
    	[_playPauseButton setImage:[forwardImage _flatImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    	_playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    	[self addSubview:_playPauseButton];

    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_playPauseButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_forwardButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-15]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_playPauseButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_playPauseButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_playPauseButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24]];

    	_songTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    	_songTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    	_songTitleLabel.textAlignment = NSTextAlignmentCenter;
    	_songTitleLabel.textColor = [UIColor whiteColor];
    	_songTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    	[self addSubview:_songTitleLabel];
    	[_songTitleLabel setMarqueeEnabled:YES];
    	[_songTitleLabel setMarqueeRunning:YES];

    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_songTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_artworkImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_songTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_playPauseButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_songTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_artworkImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-2]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_songTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:18]];

    	_songArtistLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    	_songArtistLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    	_songArtistLabel.textAlignment = NSTextAlignmentCenter;
    	_songArtistLabel.textColor = [UIColor whiteColor];
    	_songArtistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    	[self addSubview:_songArtistLabel];
    	[_songArtistLabel setMarqueeEnabled:YES];
    	[_songArtistLabel setMarqueeRunning:YES];

    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_songArtistLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_artworkImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_songArtistLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_playPauseButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_songArtistLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_songTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];
    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_songArtistLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:16]];

    	_volumeSlider = [[MPVolumeView alloc] initWithFrame:CGRectZero style:5];
		_volumeSlider.alpha = 1;
		_volumeSlider.showsRouteButton = NO;
    	_volumeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    	_volumeSlider.userInteractionEnabled = YES;
    	[self addSubview:_volumeSlider];

    	for (id current in _volumeSlider.subviews) {
        	if ([current isKindOfClass:[UISlider class]]) {
            	UISlider *slider = (UISlider *)current;

                [slider setMinimumTrackTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
				[slider setMaximumTrackTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
				[slider setThumbImage:[UIImage imageNamed:@"Thumb" inBundle:[NSBundle bundleWithPath:@"/bootstrap/Library/Application Support/MusicBar/ImageAssets.bundle"]] forState:UIControlStateNormal];

				NSBundle *mediaControlsFramework = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MediaControls.framework"];
            	UIImage *lessImage = [UIImage imageNamed:@"CC-Volume-Min" inBundle:mediaControlsFramework compatibleWithTraitCollection:nil];
            	UIImage *maxImage = [UIImage imageNamed:@"CC-Volume-Max" inBundle:mediaControlsFramework compatibleWithTraitCollection:nil];

				[slider setMinimumValueImage:[lessImage _flatImageWithColor:[UIColor whiteColor]]];
				[slider setMaximumValueImage:[maxImage _flatImageWithColor:[UIColor whiteColor]]];
        	}
    	}

    	[self addConstraint:[NSLayoutConstraint constraintWithItem:_volumeSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:_volumeSlider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_songTitleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:8]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:_volumeSlider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_songTitleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:-8]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:_volumeSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_songArtistLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:6]];


	}
	return self;
}

- (void)actuateSlightImpactFeedback {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
}

- (void)handleForwardButton:(UIButton *)button {
	MRMediaRemoteSendCommand(4, nil);
    [self actuateSlightImpactFeedback];
}

- (void)handlePlayPauseButton:(UIButton *)button {
	MRMediaRemoteSendCommand(2, nil);
    [self actuateSlightImpactFeedback];
}

- (void)handleArtworkTapped:(UITapGestureRecognizer *)recognizer {
	SBApplication *nowPlayingApp = ((SBMediaController *)[NSClassFromString(@"SBMediaController") sharedInstance]).nowPlayingApplication;
	if (nowPlayingApp) {
		[[CPDDMBBarController sharedInstance] dismissWithCompletion:^{
			[[NSClassFromString(@"SBUIController") sharedInstance] _activateApplicationFromAccessibility:nowPlayingApp];
		}];
	} else {
		SBApplication *nowPlayingApp = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:@"com.apple.Music"];
		[[CPDDMBBarController sharedInstance] dismissWithCompletion:^{
			[[NSClassFromString(@"SBUIController") sharedInstance] _activateApplicationFromAccessibility:nowPlayingApp];
		}];
	}
}

- (void)setIsPlaying:(BOOL)isPlaying {
	_isPlaying = isPlaying;

	UIImage *playImage = [UIImage imageNamed:isPlaying ? @"Pause" : @"Play" inBundle:[NSBundle bundleWithPath:@"/Library/Application Support/MusicBar/ImageAssets.bundle"]];
    if(!playImage) {
    	playImage = [UIImage imageNamed:isPlaying ? @"Pause" : @"Play" inBundle:[NSBundle bundleWithPath:@"/bootstrap/Library/Application Support/MusicBar/ImageAssets.bundle"]];
    }
    [_playPauseButton setImage:playImage forState:UIControlStateNormal];

}

@end

//
//  CPDDMBBarView.h
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/31/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

/*@protocol CPDDMusicBarDelegate <NSObject>

@required
- (void)userTappedForward;
- (void)userTappedPlayPause;

@optional
- (void)userTappedArtwork;

@end*/

@interface CPDDMBBarView : UIView

@property (assign, nonatomic) BOOL isPlaying;

//@property (strong, nonatomic) NSObject <CPDDMusicBarDelegate> *delegate;

@property (strong, nonatomic) UIImageView *artworkImageView;

@property (strong, nonatomic) UILabel *songArtistLabel;

@property (strong, nonatomic) UILabel *songTitleLabel;

@end

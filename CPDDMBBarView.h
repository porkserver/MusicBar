//
//  CPDDMBBarView.h
//  MusicBar
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 01/31/2018.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

@interface CPDDMBBarView : UIView

@property (assign, nonatomic) BOOL isPlaying;

@property (strong, nonatomic) UIImageView *artworkImageView;

@property (strong, nonatomic) UILabel *songArtistLabel;

@property (strong, nonatomic) UILabel *songTitleLabel;

@end

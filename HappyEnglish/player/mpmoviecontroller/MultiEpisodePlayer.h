//
// Created by @krq_tiger on 13-6-7.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "EpisodePlayer.h"

@class MPMoviePlayerController;

@interface MultiEpisodePlayer : EpisodePlayer

- (id)initWithEpisodes:(NSMutableArray *)episodes;
@end
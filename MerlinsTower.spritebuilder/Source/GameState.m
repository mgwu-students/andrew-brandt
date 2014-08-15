//
//  GameState.m
//  Merlins Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"
#import "Entity.h"

@implementation GameState {
    OALSimpleAudio *_audioMgr;

    BOOL _sfxPlaying;
}

static GameState *_sharedState;

static const NSString *TOP_LEVEL_KEY = @"Merlin's Tower Top Level";

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self loadDefaults];
        [self setupAudio];
    }
    
    return self;
}


#pragma mark - Setup methods

- (void)loadDefaults {
    _topLevel = [[NSUserDefaults standardUserDefaults] objectForKey:TOP_LEVEL_KEY];
    if (_topLevel == nil) {
        NSLog(@"New game started, setting default.");
        _topLevel = @"Level1";
        _selectedLevel = _topLevel;
        _playBGM = YES;
        _playSFX = YES;
    }
}

- (void)setupAudio {
    _audioMgr = [OALSimpleAudio sharedInstance];
    [_audioMgr preloadEffect:@"Assets/sounds/fizzle1.wav"];
}

- (void)playFizzle {
    if (_playSFX) {
        [_audioMgr playEffect:@"Assets/sounds/fizzle1.wav"];
    }
}

- (void)playClearMagic: (EntityType)color {
    
}
#pragma mark - Singleton method

+ (GameState *)sharedState {
    if (_sharedState == nil) {
        _sharedState = [[GameState alloc] init];
    }
    return _sharedState;
}

@end

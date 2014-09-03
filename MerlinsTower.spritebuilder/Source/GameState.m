//
//  GameState.m
//  Merlins Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

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
        [self registerNotifications];
    }
    
    return self;
}


#pragma mark - Setup methods

- (void)loadDefaults {
    _topLevel = [[NSUserDefaults standardUserDefaults] objectForKey:TOP_LEVEL_KEY];
    if (_topLevel == nil) {
        NSLog(@"New game started, setting default.");
        _topLevel = @"Level 1";
        _selectedLevel = _topLevel;
        _playBGM = YES;
        _playSFX = YES;
    }
}

- (void)setupAudio {
    _audioMgr = [OALSimpleAudio sharedInstance];
    [_audioMgr preloadEffect:@"Assets/sounds/fizzle1.wav"];
    [_audioMgr preloadEffect:@"Assets/sounds/red-clear.wav"];
    [_audioMgr preloadEffect:@"Assets/sounds/green-clear.wav"];
    [_audioMgr preloadEffect:@"Assets/sounds/blue-clear.wav"];
    [_audioMgr preloadEffect:@"Assets/sounds/woosh1.wav"];
    [_audioMgr preloadEffect:@"Assets/sounds/touched1.wav"];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playGrabbed)
            name:@"Orb grabbed!" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMerging)
            name:@"Merging!" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playClearMagic:)
            name:@"Entity cleared effect!" object:nil];
}

#pragma mark - Singleton method

+ (GameState *)sharedState {
    if (_sharedState == nil) {
        _sharedState = [[GameState alloc] init];
    }
    return _sharedState;
}

#pragma mark - Sound effect methods

- (void)playFizzle {
    if (_playSFX) {
        [_audioMgr playEffect:@"Assets/sounds/fizzle1.wav"];
    }
}

- (void)playClearMagic: (NSNotification *)message {
    if (_playSFX) {
        Entity *type = [message object];
        switch (type.magicType) {
            case BlueMagic:
                [_audioMgr playEffect:@"Assets/sounds/blue-clear.wav"];
                break;
            case RedMagic:
                [_audioMgr playEffect:@"Assets/sounds/red-clear.wav"];
                break;
            case GreenMagic:
                [_audioMgr playEffect:@"Assets/sounds/green-clear.wav"];
                break;
        }
    }
}

- (void)playGrabbed {
    [_audioMgr playEffect:@"Assets/sounds/touched1.wav" volume:1.0f pitch:1.0f pan:1.0f loop:NO];
}

- (void)playMerging {
    [_audioMgr playEffect:@"Assets/sounds/woosh1.wav"];
}

@end

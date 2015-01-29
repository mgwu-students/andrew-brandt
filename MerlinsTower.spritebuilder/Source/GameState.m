//
//  GameState.m
//  Merlins Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

@interface GameState ()

@property (nonatomic, readonly) BOOL completedIAP;

@end

@implementation GameState {
    OALSimpleAudio *_audioMgr;

    BOOL _sfxPlaying;
}

static GameState *_sharedState;

static const NSString *TOP_LEVEL_KEY = @"Merlin's Tower Top Level";
static const NSString *IAP_UNLOCK_KEY = @"Merlin's Tower IAP";

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self loadDefaults];
        [self setupAudio];
        [self registerNotifications];
        [self addObserver:self forKeyPath:@"topLevel" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}


#pragma mark - Setup methods

- (void)loadDefaults {
    //_topLevel = [[NSUserDefaults standardUserDefaults] objectForKey:TOP_LEVEL_KEY];
    _topLevel = [MGWU objectForKey:TOP_LEVEL_KEY];
    if (_topLevel == nil) {
        NSLog(@"New game started, setting default.");
        _topLevel = @1;
        _completedIAP = NO;
    } else {
        _completedIAP = [MGWU objectForKey:IAP_UNLOCK_KEY];
    }
    _selectedLevel = [NSString stringWithFormat:@"Level %@",_topLevel];
    _playBGM = YES;
    _playSFX = YES;
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
    [_audioMgr playEffect:@"Assets/sounds/touched1.wav" volume:10.0f pitch:1.0f pan:1.0f loop:NO];
}

- (void)playMerging {
    [_audioMgr playEffect:@"Assets/sounds/woosh1.wav"];
}

#pragma mark - KVO callback method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"noticed new value for %@", keyPath);
    if ([keyPath isEqualToString:@"topLevel"]) {
        [MGWU setObject:_topLevel forKey:TOP_LEVEL_KEY];
    }
}

@end

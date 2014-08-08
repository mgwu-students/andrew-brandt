//
//  GameState.m
//  Merlins Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

@implementation GameState

static GameState *_sharedState;

static const NSString *TOP_LEVEL_KEY = @"Merlin's Tower Top Level";

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self loadDefaults];
    }
    
    return self;
}

- (void)loadDefaults {
    _topLevel = [[NSUserDefaults standardUserDefaults] objectForKey:TOP_LEVEL_KEY];
    if (_topLevel == nil) {
        NSLog(@"New game started, setting default.");
        _topLevel = @"Level1";
        _selectedLevel = _topLevel;
    }
}

#pragma mark - Singleton method

+ (GameState *)sharedState {
    if (_sharedState == nil) {
        _sharedState = [[GameState alloc] init];
    }
    return _sharedState;
}

@end

//
//  GameState.h
//  Merlins Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameState : CCNode

@property (nonatomic, strong) NSString *selectedLevel;
@property (nonatomic, assign) NSString *topLevel;
@property (nonatomic, assign) BOOL playBGM;
@property (nonatomic, assign) BOOL playSFX;

- (void)playFizzle;

+ (GameState *)sharedState;

@end

//
//  GameState.h
//  Merlins Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Entity.h"

@interface GameState : CCNode

@property (nonatomic, strong) NSString *selectedLevel;
@property (nonatomic, assign) NSNumber *topLevel;
@property (nonatomic, readonly) BOOL completedIAP;
@property (nonatomic, assign) BOOL playBGM;
@property (nonatomic, assign) BOOL playSFX;

- (void)playFizzle;
- (void)userPerformIAP;

- (void)startBGM;

+ (GameState *)sharedState;

@end

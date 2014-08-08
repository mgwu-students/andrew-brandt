//
//  LevelSelect.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelSelect.h"
#import "GameState.h"

@implementation LevelSelect

- (void)selectLevel: (CCButton *)selector {
    NSString *level = selector.name;
    NSLog(@"Button pressed: %@", level);
    [GameState sharedState].selectedLevel = level;
    CCTransition *fade = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:[CCBReader loadAsScene:@"Gameplay"] withTransition:fade];
}

@end

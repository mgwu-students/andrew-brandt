//
//  LevelSelect.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelSelect.h"
#import "GameState.h"

@implementation LevelSelect {
    CCScrollView *_scrollView;
    
    GameState *state;
}

- (void)didLoadFromCCB{
    _scrollView.scrollPosition = ccp(0,2000);
    state = [GameState sharedState];
    int maxLevel = [state.topLevel intValue];
    
    for (CCNode *n in _scrollView.contentNode.children) {
        if ([n isKindOfClass:[CCLayoutBox class]]) {
            for (CCButton *b in n.children) {
                if ([b.title intValue] > maxLevel) {
                    NSLog(@"%@", b.title);
                    b.enabled = NO;
                    b.state = CCControlStateDisabled;
                }
                [b setTarget:self selector:@selector(selectLevel:)];
            }
        } else {
            NSLog(@"%@", [n class]);
        }
    }
}

- (void)selectLevel: (CCButton *)selector {
    NSString *level = [NSString stringWithFormat:@"Level %@", selector.title];
    NSLog(@"Button pressed: %@", level);
    [GameState sharedState].selectedLevel = level;
    CCTransition *fade = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:[CCBReader loadAsScene:@"Gameplay"] withTransition:fade];
}

@end

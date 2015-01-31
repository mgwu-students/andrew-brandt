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
    CCScrollView *_parallaxView;
    GameState *state;
}

- (void)didLoadFromCCB{
    _scrollView.scrollPosition = ccp(0,2000);
    _scrollView.delegate = self;
    _parallaxView.scrollPosition = ccp(0,270);
    state = [GameState sharedState];
    //CCNode *backgroundNode = [CCBReader load:@"Backgrounds/ExteriorBackground"];
    CCSprite *background = [CCSprite spriteWithImageNamed:@"Assets/Halloween-BK@4x.png"];
    [_parallaxView.contentNode addChild:background];
    
    //[backgroundNode addChild:background];
    //_parallaxView.contentNode = backgroundNode;
    [self setupButtons];
}

- (void)selectLevel: (CCButton *)selector {
    NSString *level = [NSString stringWithFormat:@"Level %@", selector.title];
    #if DEBUG
    NSLog(@"Button pressed: %@", level);
    #endif
    [GameState sharedState].selectedLevel = level;
    CCTransition *fade = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:[CCBReader loadAsScene:@"Gameplay"] withTransition:fade];
}

- (void)setupButtons {
    int maxLevel = [state.topLevel intValue];
    
    for (CCNode *n in _scrollView.contentNode.children) {
        if ([n isKindOfClass:[CCLayoutBox class]]) {
            for (CCButton *b in n.children) {
                if ([b.title intValue] > maxLevel) {
                    #if DEBUG
                    NSLog(@"%@", b.title);
                    #endif
                    b.enabled = NO;
                    b.state = CCControlStateDisabled;
                }
                [b setTarget:self selector:@selector(selectLevel:)];
            }
        } else {
            #if DEBUG
            NSLog(@"%@", [n class]);
            #endif
        }
    }
}

#pragma mark - CCScrollViewDelegate methods

- (void)scrollViewDidScroll:(CCScrollView *)scrollView {
    _scrollView.scrollPosition = scrollView.scrollPosition;
    //[_parallaxView setScrollPosition:ccp(0,scrollView.scrollPosition.y/4) ];
    _parallaxView.scrollPosition = ccp(0,scrollView.scrollPosition.y/4);
}

@end

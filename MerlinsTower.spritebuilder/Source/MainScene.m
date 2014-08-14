//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Gameplay.h"

@implementation MainScene {
    OALSimpleAudio *bgm;
}

- (void)onEnter {
    [super onEnter];
    self.userInteractionEnabled = YES;
    _startWaiting = NO;
    
    //start bgm
    bgm = [OALSimpleAudio sharedInstance];
    [bgm preloadBg:@"Assets/sounds/bgm1.wav"];
}

- (void)startGame {
    Gameplay *gameplay = (Gameplay *)[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameplay];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!_startWaiting) {
        CCAnimationManager *mgr = self.animationManager;
        [mgr runAnimationsForSequenceNamed:@"Waiting"];
        [self setStartFlag];
    }
}

- (void)setStartFlag {
    _startWaiting = YES;
    [bgm playBgWithLoop:YES];
}

@end

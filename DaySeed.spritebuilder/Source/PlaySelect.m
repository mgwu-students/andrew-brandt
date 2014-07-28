//
//  PlaySelect.m
//  Fireflies
//
//  Created by Andrew Brandt on 7/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PlaySelect.h"
#import "Gameplay.h"

@implementation PlaySelect {
    CCNode *_page1;
    CCNode *_options;

}

- (void)didLoadFromCCB {
    _page1 = [CCBReader load:@"PlaySelectPages/PlayPage1"owner:self];
    [self addChild: _page1];
}

- (void)playGame: (CCButton *)caller {
    NSLog(caller.title);
    Gameplay *_gameplay = (Gameplay *)[CCBReader loadAsScene:@"Gameplay"];
    
    [[CCDirector sharedDirector] presentScene:_gameplay];
}

@end

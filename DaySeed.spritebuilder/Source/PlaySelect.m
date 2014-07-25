//
//  PlaySelect.m
//  Fireflies
//
//  Created by Andrew Brandt on 7/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PlaySelect.h"

@implementation PlaySelect

- (void)playGame {
    CCScene *_gameplay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:_gameplay];
}

@end

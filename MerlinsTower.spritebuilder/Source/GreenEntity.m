//
//  GreenEntity.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GreenEntity.h"

@implementation GreenEntity

static const GLKVector4 GreenMagicBaseColor =     {{0.10f,	0.99f,	0.10f, 1.0f}};

- (void)didLoadFromCCB {
    self.magicType = GreenMagic;
    self.lightColor = GreenMagicBaseColor;
    self.physicsBody.collisionType = @"entity";
}

- (void)clear {
    CCParticleSystem *exit = (CCParticleSystem *)[CCBReader load:@"Effects/GreenClear"];
    exit.autoRemoveOnFinish = YES;
    exit.position = self.position;
    [self.parent addChild: exit];
    [super clear];
}
@end

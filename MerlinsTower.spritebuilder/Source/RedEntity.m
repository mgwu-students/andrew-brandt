//
//  RedEntity.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RedEntity.h"

@implementation RedEntity

static const GLKVector4 RedMagicBaseColor =    {{1.00f,    0.10f,	0.10f, 1.0f}};

- (void)didLoadFromCCB {
    self.magicType = RedMagic;
    self.lightColor = RedMagicBaseColor;
    self.physicsBody.collisionType = @"entity";
}

- (void)startClear {
    [super startClear];
    CCParticleSystem *exit = (CCParticleSystem *)[CCBReader load:@"Effects/RedClear"];
    exit.autoRemoveOnFinish = YES;
    exit.position = self.position;
    [self.parent addChild: exit];
}

@end

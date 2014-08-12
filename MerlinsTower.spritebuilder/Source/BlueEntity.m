//
//  BlueEntitiy.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "BlueEntity.h"

@implementation BlueEntity

static const GLKVector4 BlueMagicBaseColor =   {{0.10f,	0.10f,	1.00f, 1.0f}};

- (void)didLoadFromCCB {
    self.magicType = BlueMagic;
    self.lightColor = BlueMagicBaseColor;
    self.physicsBody.collisionType = @"entity";
}

- (void)startClear {
    [super startClear];
    CCParticleSystem *exit = (CCParticleSystem *)[CCBReader load:@"Effects/BlueClear"];
    exit.autoRemoveOnFinish = YES;
    exit.position = self.position;
    [self.parent addChild: exit];
}

@end

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

@end

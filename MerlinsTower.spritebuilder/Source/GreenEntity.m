//
//  GreenEntity.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GreenEntity.h"

@implementation GreenEntity

static const GLKVector4 GreenMagicBaseColor =     {{0.00f,	0.99f,	0.00f, 1.0f}};

- (void)didLoadFromCCB {
    self.magicType = GreenMagic;
    self.lightColor = GreenMagicBaseColor;
    self.physicsBody.collisionType = @"entity";
}

@end

//
//  HelperEntity.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/11/14.
//  Copyright (c) 2014 Dory Studios. All rights reserved.
//

#import "HelperEntity.h"

@implementation HelperEntity {
    float _lightRadius;
    BOOL _lightIncreasing;
}

const float LIGHT_MAX = 100;
const float LIGHT_MIN = 25;

static const GLKVector4 HelperBaseColor =   {{0.60f,	0.60f,	0.60f,  0.9f}};

- (void)update: (CCTime)dt {
    if (_lightIncreasing) {
        if (_lightRadius < LIGHT_MIN) {
            _lightRadius *= 1.05;
        }
        _lightRadius *= 1.01;
    }
    else {
        _lightRadius *= 0.995;
    }
    
    if (_lightRadius > LIGHT_MAX) {
        _lightIncreasing = NO;
    }
    else {
        _lightIncreasing = YES;
    }
}

- (void)didLoadFromCCB {
    _lightRadius = 5.0f;
    _lightIncreasing = YES;
    self.lightColor = HelperBaseColor;
    self.physicsBody.collisionMask = @[];
}

- (void)onEnter {
    [super onEnter];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Entity cleared!" object:self];
}

- (float)lightRadius {
    return _lightRadius;
}

@end

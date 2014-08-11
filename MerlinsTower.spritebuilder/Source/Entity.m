//
//  Entity.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Entity.h"
#import "LightingLayer.h"

@implementation Entity {
    CGPoint _startLocation;
    
    LightingLayer *_lightingLayer;
    
    CCActionScaleTo *_appear;
    CCActionScaleTo *_disappear;
    CCActionCallFunc *_return;
    
    float _phase;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        //self.scaleX = 0.0f;
        //self.scaleY = 0.0f;
        _phase = 2.0*M_PI*CCRANDOM_0_1();
        _canPerfomAction = YES;
        _lightingLayer = [LightingLayer sharedLayer];
        
        _appear = [CCActionScaleTo actionWithDuration:0.25f scale:1.0f];
        _disappear = [CCActionScaleTo actionWithDuration:0.25f scale:0.0f];
        _return = [CCActionCallFunc actionWithTarget:self selector:@selector(resetSpawnPoint)];
        self.physicsBody.collisionMask = @[@"obstacle"];
        NSLog(@"Ready!");
    }
    
    return self;
}

- (void)onEnter {
    [super onEnter];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"Entity created!" object:self];
    _startLocation = [self convertToWorldSpace:ccp(0,0)];
//    [self runAction:_appear];
    [_lightingLayer addLight:self];
}

- (void)onExit {
    [_lightingLayer removeLight:self];
    [super onExit];
}

- (void)startMove: (NSMutableArray *)instructions {
    NSLog(@"Moving");
    CGFloat delay = 0.05f;
    CGFloat offset = 0.05f;
    for (CCNode *o in instructions) {
        [self performSelector:@selector(move:) withObject:o afterDelay:delay];
        delay += offset;
    }
    [self performSelector:@selector(returnToSpawnPoint) withObject:nil afterDelay:delay];
}

- (void)move: (CCNode *)location {
    if (_canPerfomAction) {
        self.position = location.position;
    }
}

- (void)returnToSpawnPoint {
    [self runAction: [CCActionSequence actions:_disappear,_return,_appear, nil]];
}

- (void)resetSpawnPoint {
    self.position = _startLocation;
}

- (void)clear {
    [self removeFromParent];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Entity cleared!" object:self];
}

-(float)lightRadius
{
	return 180.f;
}

-(GLKVector4)lightColor
{
	return _lightColor;
}

@end

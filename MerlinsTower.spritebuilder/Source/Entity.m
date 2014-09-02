//
//  Entity.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Entity.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation Entity {
    LightingLayer *_lightingLayer;
    GameState *_state;
    CCAction *_appear, *_disappear, *_wait, *_return;
    
    CGPoint _startLocation;
    CGFloat _mergeTimer;
    
    float _phase, _lightRadius;
    BOOL _goodMerge, _clearing, _playSFX, _canClear;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        //self.scaleX = 0.0f;
        //self.scaleY = 0.0f;
        _phase = 2.0*M_PI*CCRANDOM_0_1();
        _lightRadius = 180.0f;
        _lightingLayer = [LightingLayer sharedLayer];
        _state = [GameState sharedState];
        _isMerged = NO;
        _clearing = NO;
        _canClear = NO;
        _mergeTimer = 0.0f;
        
      
        _appear = [CCActionScaleTo actionWithDuration:0.25f scale:1.0f];
        _disappear = [CCActionScaleTo actionWithDuration:0.25f scale:0.0f];
        _wait = [CCActionDelay actionWithDuration:0.1f];
        _return = [CCActionCallFunc actionWithTarget:self selector:@selector(resetSpawnPoint)];
        self.physicsBody.collisionMask = @[@"obstacle"];
        NSLog(@"Ready!");
    }
    
    return self;
}

- (void)onEnter {

    self.position = [self.parent convertPositionToPoints:self.position type:self.positionType];
    self.positionType = CCPositionTypePoints;

    [super onEnter];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"Entity created!" object:self];
    [center addObserver:self selector:@selector(setClearFlag:) name:@"Can clear!" object:nil];
    _startLocation = [self convertToWorldSpace:ccp(0,0)];
    [_lightingLayer addLight:self];
}

- (void)onExit {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_lightingLayer removeLight:self];
    [super onExit];
}

- (void)update: (CCTime)dt {
    
    //Merge logic is here
    if (self.isMerged) {
        _mergeTimer += dt;
    }
    if (!_goodMerge && _mergeTimer > 0.5f) {
        _mergeTimer = 0.0f;
        [self returnToSpawnPoint];
    }
    else if (!_canClear && _goodMerge && _mergeTimer > 2.0f) {
        _mergeTimer = 0.0f;
        [self returnToSpawnPoint];
    }
    else if (_canClear && _goodMerge && _mergeTimer > 2.0f) {
        _mergeTimer = 0.0f;
        [self startClear];
    }

    
    //Fade out logic is here
    if (_clearing) {
        _lightRadius *= 0.97f;
    }
}

- (void)startMove: (NSMutableArray *)instructions {
    NSLog(@"Moving");
    NSMutableArray *actionList = [NSMutableArray array];
    for (NSValue *o in instructions) {
        CCAction *act = [CCActionMoveTo actionWithDuration:0.1f position:[o CGPointValue]];
        [actionList addObject:act];
    }
    CCActionCallFunc *returnCall = [CCActionCallFunc actionWithTarget:self selector:@selector(returnToSpawnPoint)];
    [actionList addObject:returnCall];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:actionList];
    [self runAction:sequence];
}

- (void)move: (NSValue *)location {
    self.position = [location CGPointValue];
}

- (void)returnToSpawnPoint {
    self.physicsBody.velocity = ccp(0,0);
    [self runAction: [CCActionSequence actions:_disappear,_return,_appear, nil]];
}

- (void)resetSpawnPoint {
    self.position = _startLocation;
    _isMerged = NO;
    self.physicsBody.sensor = NO;
}

- (void)haltActions {
    [self stopAllActions];
    self.physicsBody.sensor = YES;
}

- (void)startClear {
    _clearing = YES;
    if (_playSFX) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Entity cleared effect!" object:self];
    }
    CCAction *fade = [CCActionFadeOut actionWithDuration:1.0f];
    CCAction *clear = [CCActionCallFunc actionWithTarget:self selector:@selector(clear)];
    CCAction *sequence = [CCActionSequence actions:fade, clear, nil];
    [self runAction:sequence];
}

- (void)clear {
    [self removeFromParent];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Entity cleared!" object:self];
    //[_state playClearMagic:self];
}

- (void)setClearFlag: (NSNotification *)message {
    _canClear = YES;
}

- (void)mergeWithEntity: (Entity *)target atLoc: (CGPoint)loc playSFX: (BOOL)val{
    CCAction *move = [CCActionMoveTo actionWithDuration:0.2f position:loc];
    self.physicsBody.sensor = YES;
    self.isMerged = YES;
    _playSFX = val;
    if (self.magicType == target.magicType) {
        NSLog(@"Similar magic collided!");
        _goodMerge = YES;
    }
    else {
        NSLog(@"Different magic collided");
        _goodMerge = NO;
    }
    [self runAction:move];
}

#pragma mark - Shader methods

-(float)lightRadius
{
	return _lightRadius;
}

-(GLKVector4)lightColor
{
	return _lightColor;
}

@end

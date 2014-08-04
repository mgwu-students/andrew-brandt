//
//  Entity.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Entity.h"

#ifndef DEFAULT_BRIGHTNESS
    #define DEFAULT_BRIGHTNESS = 100.0
#endif

@implementation Entity{
        float _phase;
        CGFloat timeSinceAction;
    
        NSMutableArray *_entitiesJoined;
}

//static const GLKVector4 AlgaeBaseColor = {{0.00f,	0.99f,	0.27f, 1.0f}};
static const GLKVector4 WaterBaseColor = {{0.62f,	0.92f,	1.00f, 1.0f}};

-(void)onEnter
{
	_phase = 2.0*M_PI*CCRANDOM_0_1();
	_lightColor = WaterBaseColor;
	_lightingLayer = [LightingLayer sharedLayer];
    [_lightingLayer addLight:self];
    
    _entitiesJoined = [NSMutableArray array];
    _currentState = EntityAppearing;
    timeSinceAction = 0;
    
	CCPhysicsBody *body = self.physicsBody;
	body.collisionType = @"entity";
	   
    self.visible = YES;
	
	[super onEnter];
}

-(void)onExit
{
	[_lightingLayer removeLight:self];
	
	[super onExit];
}

-(void)update:(CCTime)dt
{
	_phase += dt;
    timeSinceAction += dt;
    
    if (timeSinceAction >= 3.0f && _currentState != EntityIdle) {
        [self setState:EntityIdle];
    }
	
    if (_currentState == EntityAppearing) {
        [self.physicsBody applyImpulse:ccp(20,50)];
        [self setState:EntityIdle];
    }
//	float speed = ccpLength(self.physicsBody.velocity);
//	float intensity = clampf(speed/100.0f + 0.3f*(0.5f + 0.5*sinf(_phase)), 0.0f, 1.0f);
//	
//	float yPos = self.position.y;
//	float blend = clampf((yPos - 140.0f)/30.0f, 0.0f, 1.0f);
//	
//	GLKVector4 dstColor = GLKVector4MultiplyScalar(GLKVector4Lerp(WaterBaseColor, AlgaeBaseColor, blend), intensity);
//	_lightColor = GLKVector4Lerp(dstColor, _lightColor, powf(0.3, dt));
}

#pragma mark - Light effect methods

-(float)lightRadius
{
	return 180.f;
}

-(GLKVector4)lightColor
{
	return _lightColor;
}

#pragma mark - Movement handling

- (void)encourage: (CGPoint)location
{
    NSLog(@"Received encouragement!");
    [self setState:EntityJoining];
    CGPoint push = ccpMult(ccpSub(location, self.position), 0.3);
    [self.physicsBody applyImpulse: push];
}

- (void)lift{
    NSLog(@"Upward bound!");
    [self.physicsBody applyImpulse: ccp(30,30)];
    if (self.physicsBody.velocity.x > 100) {
        NSLog(@"%.2f",self.physicsBody.velocity.x);
    }
}

#pragma mark - State handling

- (void)setState: (EntityState)state {
    NSLog(@"State changing to %d", state);
    _currentState = state;
}

#pragma mark - Joint handling

- (void)tryJoinWithSpring: (Entity *)e {

    BOOL goodState = (_currentState == EntityJoining && e.currentState == EntityJoining) ? YES : NO;
    BOOL goodJoints = (_jointsPresent < 2 && e.jointsPresent < 2) ? YES : NO;
    BOOL noDup = YES;
    for (Entity *obj in _entitiesJoined) {
        if ([e isEqual:obj]) {
            noDup = NO;
        }
    }
    
    if (goodState && goodJoints && noDup) {
            NSLog(@"Can create joint.");
            [self joinWithSpring: e];
    }
}

- (void)joinWithSpring: (Entity *)e {
    NSLog(@"Joining.");
    [CCPhysicsJoint connectedSpringJointWithBodyA:self.physicsBody bodyB:e.physicsBody anchorA:ccp(0.5,0.5) anchorB:ccp(0.5,0.5) restLength:30.f stiffness:100.f damping:80.f];
    _jointsPresent++;
    e.jointsPresent++;
}

#pragma mark - Factory method

+ (Entity *)generateEntity {

    Entity *obj = (Entity *)[CCBReader load:@"Entities/Individual"];
    return obj;

}

@end

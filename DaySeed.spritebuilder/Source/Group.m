//
//  Group.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Group.h"
#import "Individual.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation Group {

    NSMutableArray *_entityArray;
    
    CCNode *_groupNode;
    GroupState _currentState;
    
    //CCPhysicsJoint *_indivdualSpringJoint;
}

static const NSString *INDIVIDUAL_SPAWNED = @"Individual spawned";

static const NSString *HIVE_FINISHED_SPAWN = @"Hive completed spawning";

- (void)didLoadFromCCB {
    _entityArray = [NSMutableArray array];
    self.physicsBody.collisionMask = @[];
    self.physicsBody.affectedByGravity = NO;
    _currentState = GroupWaiting;
    
    //Signing up for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameplayStart:) name:HIVE_FINISHED_SPAWN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIndividualFromMessage:) name:INDIVIDUAL_SPAWNED object:nil];

    
}

- (void)onEnter {
    [super onEnter];
}

- (void)onExit {
    for (CCPhysicsJoint *j in self.physicsBody.joints) {
        //[j invalidate];
    }
    [super onExit];
}

- (void)update: (CCTime)dt {
    switch(_currentState) {
        case GroupWaiting:
            [self.physicsBody applyAngularImpulse:10];
            break;
        case GroupReady:
            [self.physicsBody applyAngularImpulse:-35];
            break;
    }
}

- (void)changeState: (GroupState)newState {
    switch (newState) {
        case GroupReady:
            NSLog(@"Changing velocity function!!!");
            self.physicsBody.body.body->velocity_func = playerUpdateVelocity;
            break;
        case GroupWaiting:
            break;
        }
    _currentState = newState;
}

#pragma mark - Notification listening

- (void)gameplayStart: (NSNotification *)message {
    [self changeState:GroupReady];
}

- (void)addIndividualFromMessage: (NSNotification *)message {
    NSLog(@"Received notification!");
    Individual *i = [message object];
    [self addIndividual:i];
}

- (void)addIndividual: (Individual *)node {
    [_entityArray addObject: node];
    [CCPhysicsJoint connectedSpringJointWithBodyA:self.physicsBody bodyB:node.physicsBody anchorA:ccp(0,0) anchorB:ccp(0.5,0.5) restLength:30.f stiffness:600.f damping:30.f];
}

#pragma mark - Velocity Function

static void
playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
    cpBodyUpdateVelocity(body, gravity, damping, dt);
    
    float x = body->v.x;
	//body->v.x = clampf(body->v.x,-50.0f,100.0f);
    if (x > 60.0f)
    {
        NSLog(@"%.2f",x);
        x *= 0.98;
    }
    else if(x < -50.0f)
    {
        x *= 0.98;
    }
    
    body->v.x = x;
}

@end

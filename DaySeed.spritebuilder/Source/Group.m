//
//  Group.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Group.h"
#import "Individual.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState:) name:HIVE_FINISHED_SPAWN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIndividualFromMessage:) name:INDIVIDUAL_SPAWNED object:nil];

    
}

- (void)onEnter {
    [super onEnter];
}

- (void)update: (CCTime)dt {
    switch(_currentState) {
        case GroupWaiting:
            [self.physicsBody applyAngularImpulse:10];
            break;
        case GroupReady:
            break;
    }

}

- (void)changeState: (NSNotification *)message {

}

- (void)addIndividualFromMessage: (NSNotification *)message {
    NSLog(@"Received notification!");
    Individual *i = [message object];
    [self addIndividual:i];
}

- (void)addIndividual: (Individual *)node {
    [_entityArray addObject: node];
    [CCPhysicsJoint connectedSpringJointWithBodyA:self.physicsBody bodyB:node.physicsBody anchorA:ccp(0,0) anchorB:ccp(0,0) restLength:20.f stiffness:500.f damping:40.f];
}

- (void)breakupGroup {


}


@end

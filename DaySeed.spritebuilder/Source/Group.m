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

    //CCPhysicsJoint *_indivdualSpringJoint;
}

- (void)didLoadFromCCB {
    _entityArray = [NSMutableArray array];
    _groupNode.physicsBody.collisionMask = @[];
}

- (void)onEnter {
    [super onEnter];
}

- (void)addIndividual: (Individual *)node {
    [_entityArray addObject: node];
    [CCPhysicsJoint connectedSpringJointWithBodyA:_groupNode.physicsBody bodyB:node.physicsBody anchorA:ccp(0,0) anchorB:ccp(0,0) restLength:20.f stiffness:800.f damping:30.f];
}

- (void)breakupGroup {


}


@end

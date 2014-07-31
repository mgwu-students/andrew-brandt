//
//  Individual.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Individual.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation Individual {
    IndividualState _currentState;
    CGFloat _worldSizeX;
    CGFloat _timeSinceAction;
}

static const NSString *HIVE_FINISHED_SPAWN = @"Hive completed spawning";

- (void)didLoadFromCCB {
    //Signing up for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameplayStart:) name:HIVE_FINISHED_SPAWN object:nil];
    _worldSizeX = [CCDirector sharedDirector].viewSize.width;
}

- (void)onEnter {
    [super onEnter];
    _timeSinceAction = 0.0f;
    
}

- (void)update: (CCTime)dt {
    _timeSinceAction += dt;
    switch(_currentState) {
        case IndividualReady:
            if (self.position.x > _worldSizeX) {
                //CGFloat currentVelocityX = self.physicsBody.body.velocity.x;
                //self.physicsBody.body.velocity.x currentVelocityX * 0.9f;
            }
            break;
        case IndividualAppearing:
            break;
    }
}

- (float)lightRadius
{
	return 100.f;
}

- (void)changeState: (IndividualState)newState {
    switch(newState) {
        case IndividualReady:
            //NSLog(@"Changing velocity function!!!");
            self.physicsBody.body.body->velocity_func = playerUpdateVelocity;
            break;
        case IndividualAppearing:
            break;
    }
     _currentState = newState;
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
        x *= 0.99;
    }
    else if(x < -50.0f)
    {
        x *= 0.99;
    }
    
    body->v.x = x;
    //body->v.y = 0.0f;
}

#pragma mark - Notification listening

- (void)gameplayStart: (NSNotification *)message {
    [self changeState:IndividualReady];
}

#pragma mark - Factory method

+ (Individual *)generateEntity {

    Individual *_obj = (Individual *)[CCBReader load:@"Entities/Individual"];
    return _obj;

}

@end

//
//  Seed.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Seed.h"

@implementation Seed {
    
    LightingLayer *_lightingLayer;
    float _phase;

}

static const GLKVector4 AlgaeBaseColor = {{0.00f,	0.99f,	0.27f, 1.0f}};
static const GLKVector4 WaterBaseColor = {{0.62f,	0.92f,	1.00f, 1.0f}};

-(void)onEnter
{
	_phase = 2.0*M_PI*CCRANDOM_0_1();
	_lightColor = AlgaeBaseColor;
	
	CCPhysicsBody *body = self.physicsBody;
	body.collisionType = @"blob";
	
	[_lightingLayer addLight:self];
	
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
	
	float speed = ccpLength(self.physicsBody.velocity);
	float intensity = clampf(speed/100.0f + 0.3f*(0.5f + 0.5*sinf(_phase)), 0.0f, 1.0f);
	
	float yPos = self.position.y;
	float blend = clampf((yPos - 140.0f)/30.0f, 0.0f, 1.0f);
	
	GLKVector4 dstColor = GLKVector4MultiplyScalar(GLKVector4Lerp(WaterBaseColor, AlgaeBaseColor, blend), intensity);
	_lightColor = GLKVector4Lerp(dstColor, _lightColor, powf(0.3, dt));
}

-(float)lightRadius
{
	return 250.0;
}

-(GLKVector4)lightColor
{
	return _lightColor;
}

@end

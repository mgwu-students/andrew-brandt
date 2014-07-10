//
//  Gameplay.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Seed.h"
#import "Box.h"
#import "LightingLayer.h"

#import "CCPhysics+ObjectiveChipmunk.h"
#import "CCTexture_Private.h"

@implementation Gameplay {

    CCSprite *_backgroundSprite;
    CCPhysicsNode *_physicsNode;
    LightingLayer *_lightingLayer;

}

- (void)onEnter {
    CCTexture *caustics = [CCTexture textureWithFile:@"Assets/Caustics.psd"];
	
	// This is currently part of the private texture API...
	// Need to find a nice way to expose this when loading textures since it's not very friendly to cached textures.
	caustics.texParameters = &((ccTexParams){GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT});
//	
//	_backgroundSprite.shaderUniforms[@"caustics"] = caustics;
//	_backgroundSprite.shaderUniforms[@"causticsSize"] = [NSValue valueWithCGSize:CC_SIZE_SCALE(caustics.contentSize, 8.0)];
//	
//	_backgroundSprite.shader = [[CCShader alloc] initWithVertexShaderSource:CC_GLSL(
//		uniform vec2 causticsSize;
//		
//		varying highp vec2 causticsCoord1;
//		varying highp vec2 causticsCoord2;
//		
//		void main(){
//			gl_Position = cc_Position;
//			cc_FragTexCoord1 = cc_TexCoord1;
//			cc_FragColor = cc_Color;
//			
//			const float f = 1.0;
//			
//			vec4 offset1 = mod(cc_Time[0]*vec4(16.0, -11.0, 0.0, 0.0), vec4(causticsSize, 1.0, 1.0));
//			causticsCoord1 = (cc_ProjectionInv*cc_Position + offset1).xy/causticsSize;
//			
//			vec4 offset2 = mod(cc_Time[0]*vec4(-14.0, -7.0, 0.0, 0.0), vec4(causticsSize, 1.0, 1.0));
//			causticsCoord2 = (cc_ProjectionInv*cc_Position + offset2).xy/causticsSize;
//		}
//	) fragmentShaderSource:CC_GLSL(
//		uniform sampler2D caustics;
//		
//		varying highp vec2 causticsCoord1;
//		varying highp vec2 causticsCoord2;
//		
//		void main(){
//			vec4 bg = texture2D(cc_MainTexture, cc_FragTexCoord1)*cc_FragColor;
//			vec4 caustics1 = texture2D(caustics, causticsCoord1);
//			vec4 caustics2 = texture2D(caustics, causticsCoord2);
//			gl_FragColor = bg + 0.2*(caustics1 + caustics2);
//		}
//	)];
//    
    Seed *_seed = (Seed *)[CCBReader load:@"Seed"];
    
    _seed.position = ccp(200,170);
    _seed.scaleX = 0.3f;
    _seed.scaleY = 0.3f;
    
    [_physicsNode addChild: _seed];
    [_lightingLayer addLight:_seed];
    
    Box *_box = (Box *)[CCBReader load:@"Box"];
    _box.position = ccp(110,220);
    _box.scaleX = 0.6f;
    _box.scaleY = 0.6f;
    
    [_physicsNode addChild :_box];
    [_lightingLayer addOccluder:_box];
    
    Box *_box2 = (Box *)[CCBReader load:@"Box"];
    _box2.position = ccp(240,100);
    _box2.scaleX = 0.6f;
    _box2.scaleY = 0.6f;
    
    [_physicsNode addChild :_box2];
    [_lightingLayer addOccluder:_box2];
    
    [super onEnter];
}

@end

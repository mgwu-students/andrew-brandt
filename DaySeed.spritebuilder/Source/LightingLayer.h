//
//  LightingLayer.h
//  DaySeed
//
//  Created by Andrew Brandt on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Light
@property(nonatomic, readonly) float lightRadius;
@property(nonatomic, readonly) GLKVector4 lightColor;
@end


@protocol Occluder
@property(nonatomic, readonly) CCVertex *occluderVertexes;
@property(nonatomic, readonly) int occluderVertexCount;
@end

@interface LightingLayer : CCNode

-(void)addLight:(CCNode<Light> *)light;
-(void)removeLight:(CCNode<Light> *)light;
-(void)addOccluder:(CCNode<Occluder> *)occluder;
-(void)removeOccluder:(CCNode<Occluder> *)occluder;

+(LightingLayer *)sharedLayer;

@end

@interface CCNode(LightingLayer)
-(LightingLayer *)lightingLayer;
@end

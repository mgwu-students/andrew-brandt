//
//  Individual.h
//  DaySeed
//
//  Created by Andrew Brandt on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Entity.h"
#import "LightingLayer.h"

typedef NS_ENUM(NSInteger, IndividualState) {
    IndividualAppearing,
    IndividualReady
};

@interface Individual : Entity

+ (Individual *)generateEntity;

@end

//
//  Individual.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Individual.h"

@implementation Individual

-(float)lightRadius
{
	return 100.f;
}

#pragma mark - Factory method

+ (Individual *)generateEntity {

    Individual *_obj = (Individual *)[CCBReader load:@"Individual"];
    return _obj;

}

@end

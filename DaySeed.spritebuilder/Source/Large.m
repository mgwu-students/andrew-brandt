//
//  Large.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Large.h"

@implementation Large

-(float)lightRadius
{
	return 300.f;
}

#pragma mark - Factory method

+(Large *)generateEntity {

    Large *_obj = (Large *)[CCBReader load:@"Large"];
    return _obj;

}


@end

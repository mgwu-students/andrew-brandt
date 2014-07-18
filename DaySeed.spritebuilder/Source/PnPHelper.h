//
//  PnPHelper.h
//  DaySeed
//
//  Created by Andrew Brandt on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PnPHelper : NSObject

BOOL pointInPoly(int nvert, float vertx[], float verty[], float testx, float testy);

@end

//
//  SKSpiritNodeWithCount.m
//  FlappyWings
//
//  Created by Travis Delly on 9/19/15.
//  Copyright (c) 2015 Travis Delly. All rights reserved.
//

#import "SKSpiritNodeWithCount.h"

@implementation SKSpiritNodeWithCount

-(id)init:(int)count{
    self = [super init];
    if(self) {
        self.count = count;
    }
    return self;
}

@end

//
//  Cloud.h
//  Rexscue
//
//  Created by Laura Breiman on 1/26/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Cloud : CCSprite {
    CGFloat screenWidth,screenHeight;
}

@property int direction;
@property double speed;
@end

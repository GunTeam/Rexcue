//
//  Meteor.m
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Meteor.h"


@implementation Meteor

-(void)didLoadFromCCB{
    self.speed = 10;
    self.userInteractionEnabled = true;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
}

-(void)launch{
    
}

@end

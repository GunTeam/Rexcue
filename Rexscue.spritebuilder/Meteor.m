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
    int destinationX = arc4random()%(int)screenWidth;
    int destinationY = 0;
    CGPoint destination = CGPointMake(destinationX, destinationY);
    
    CGPoint velVector = CGPointMake(self.position.x - destinationX, self.position.y);
    double magnitude = sqrt(pow(velVector.x,2) + pow(velVector.y,2));
    CGPoint normalizedVel = CGPointMake(self.speed*velVector.x/magnitude, self.speed*velVector.y/magnitude);
    
    self.rotation = (180/M_PI)*atan2(normalizedVel.y, normalizedVel.x)+180;
    self.physicsBody.velocity = normalizedVel;
}

@end

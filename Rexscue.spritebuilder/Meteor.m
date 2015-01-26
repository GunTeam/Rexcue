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
    self.speed = 0;
    self.userInteractionEnabled = true;
    
    self.physicsBody.collisionType = @"meteor";
    self.physicsBody.collisionGroup = @"meteors";
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    
    //adjust for ipad sizing:
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        screenWidth = screenWidth/2;
        screenHeight = screenHeight/2;
    }
    
    
    self.scale = 0.2;
    }

-(void)launch{
    int destinationX = arc4random()%(int)screenWidth;
    int destinationY = 0;
    
    CGPoint velVector = CGPointMake(-self.position.x + destinationX, -self.position.y);
    double magnitude = sqrt(pow(velVector.x,2) + pow(velVector.y,2));
    CGPoint normalizedVel = CGPointMake(self.speed*velVector.x/magnitude, self.speed*velVector.y/magnitude);
    
    self.rotation = -(180/M_PI)*atan2(normalizedVel.y, normalizedVel.x);
    self.physicsBody.velocity = normalizedVel;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    Explosion *explosion = (Explosion*)[CCBReader load:@"Explosion"];
    explosion.position = self.position;
    GameScene *gameScene = (GameScene *)self.parent.parent;
    [gameScene addPointsToScore: (int)(screenHeight-self.position.y) ];
    [self removeFromParent];
    [gameScene addChild:explosion];
}

@end

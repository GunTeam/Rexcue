//
//  Cloud.m
//  Rexscue
//
//  Created by Laura Breiman on 1/26/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Cloud.h"


@implementation Cloud
@synthesize speed;

-(void) didLoadFromCCB{
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
    
    self.direction = 0;
    self.speed = 0.01;
}

-(void) update:(CCTime)delta{
    if(self.direction == 1){
        self.position = ccp( self.position.x + 100*self.speed, self.position.y );
    }
    else{
        self.position = ccp( self.position.x - 100*self.speed, self.position.y );
    }
    
    if(self.position.x > screenWidth){
        self.position = ccp(0, self.position.y);
    }
    else if(self.position.x < 0){
        self.position = ccp(screenWidth, self.position.y);
    }
}

@end

//
//  GameScene.m
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene
-(void) didLoadFromCCB {
    NUM_DINOS = 10;
    
    self.userInteractionEnabled = true;
    
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
    
    _physicsNode.collisionDelegate = self;
    _physicsNode.debugDraw = true;
    
    _ground.physicsBody.collisionType = @"ground";
    
    [self schedule:@selector(spawnMeteor:) interval:2];
    
    
    for(int i=0; i<NUM_DINOS; i++){
        [self addRandomDino];
    }
}

-(void) addRandomDino{
    
    dinosaur *newDino;
    int randSpawnFlag = arc4random()%5;
    switch (randSpawnFlag)
    {
        case 0:
            newDino = (Allosaurus*)[CCBReader load:@"Allosaurus"];
            break;
        case 1:
            newDino = (TRex*)[CCBReader load:@"TRex"];
            break;
        case 2:
            newDino = (Stegosaurus*)[CCBReader load:@"Stegosaurus"];
            break;
        case 3:
            newDino = (Triceratops*)[CCBReader load:@"Triceratops"];
            break;
        case 4:
            newDino = (Pterodactyl*)[CCBReader load:@"Pterodactyl"];
            break;
        default:
            break;
            
    }
    newDino.scale = 0.8;
    
    int positionX = arc4random()%(int)screenWidth;
    int positionY = screenHeight/10;
    
    newDino.position = CGPointMake(positionX, positionY);
    
    [_physicsNode addChild:newDino];
}

-(void) spawnMeteor:(CCTime) dt{
    Meteor *meteor = (Meteor *)[CCBReader load:@"Meteor"];
    meteor.position = CGPointMake(arc4random()%(int)screenWidth, screenHeight);
    [_physicsNode addChild:meteor];
    [meteor launch];
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor ground:(CCNodeColor *)ground{
    [meteor removeFromParent];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor dinosaur:(dinosaur *)dinosaur{
    [meteor removeFromParent];
    [dinosaur removeFromParent];
}


@end

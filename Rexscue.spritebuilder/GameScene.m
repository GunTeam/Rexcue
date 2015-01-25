//
//  GameScene.m
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

@synthesize score, meteorSpeed, timeElapsed, numDinos, level;

-(void) didLoadFromCCB {
    NUM_STARTING_DINOS = 10;
    SECONDS_TO_LEVEL_UPDATE = 5;
    
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
    
    self.score = 0;
    
    for(int i=0; i<NUM_STARTING_DINOS; i++){
        [self addRandomDino];
    }
    
    meteorSpeed = 100;
    timeElapsed = 0;
    numDinos = NUM_STARTING_DINOS;
    level = 0;
    
    [self setTimeLabel];
    [self setLevelLabel];
    
    [self schedule:@selector(updateBySecond) interval:1];
}

-(void) addRandomDino{
    
    dinosaur *newDino;
    int randSpawnFlag = arc4random()%5;
    double positionX = arc4random()%(int)screenWidth;
    double positionY = screenHeight/8;
    
    switch (randSpawnFlag)
    {
        case 0:
            newDino = (Allosaurus*)[CCBReader load:@"Allosaurus"];
            positionY = screenHeight/4;
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
    
    
    if(newDino.inAir){
        positionY = (7./10)*screenHeight;
    }
    newDino.position = CGPointMake(positionX, positionY);
    
    //point the dino in a random direction:
    int directionFlag = arc4random()%2;
    [newDino setDirection:directionFlag];
    
    if(directionFlag ==1){
        newDino.scaleX *= -1;
        [newDino reverseHealthLabel];
    }
    
    [_physicsNode addChild:newDino];
    numDinos += 1;
}

-(void) spawnEnemyDino{
    
    dinosaur *newDino;
    int randSpawnFlag = arc4random()%5;
    double positionX = arc4random()%(int)screenWidth;
    double positionY = screenHeight/8;
    
    switch (randSpawnFlag)
    {
        case 0:
            newDino = (Allosaurus*)[CCBReader load:@"EvilAllosaurus"];
            positionY = screenHeight/4;
            break;
        case 1:
            newDino = (TRex*)[CCBReader load:@"EvilTRex"];
            break;
        case 2:
            newDino = (Stegosaurus*)[CCBReader load:@"EvilStegosaurus"];
            break;
        case 3:
            newDino = (Triceratops*)[CCBReader load:@"EvilTriceratops"];
            break;
        case 4:
            newDino = (Pterodactyl*)[CCBReader load:@"EvilPterodactyl"];
            break;
        default:
            break;
            
    }
    newDino.scale = 0.8;
    
    
    if(newDino.inAir){
        positionY = (7./10)*screenHeight;
    }
    newDino.position = CGPointMake(positionX, positionY);
    
    //point the dino in a random direction:
    int directionFlag = arc4random()%2;
    [newDino setDirection:directionFlag];
    
    if(directionFlag ==1){
        newDino.scaleX *= -1;
        [newDino reverseHealthLabel];
    }
    newDino.physicsBody.collisionType = @"evilDino";
    newDino.physicsBody.collisionGroup = @"evilDinos";
    [newDino setIsEnemy:true];
    [_physicsNode addChild:newDino];
}


-(void) spawnMeteor:(CCTime) dt{
    Meteor *meteor = (Meteor *)[CCBReader load:@"Meteor"];
    meteor.position = CGPointMake(arc4random()%(int)screenWidth, screenHeight);
    [_physicsNode addChild:meteor];
    [meteor setSpeed: meteorSpeed];
    [meteor launch];
}

-(void) addPointsToScore: (int) points{
    self.score += points;
    NSString *scoreString = [NSString stringWithFormat:@"Score: %d", (self.score)];
    [_scoreLabel setString:scoreString];
}

-(void) setTimeLabel{
    NSString *timeString = [NSString stringWithFormat:@"Time: %d", (self.timeElapsed)];
    [_timeLabel setString:timeString];
}

-(void) setLevelLabel{
    NSString *levelString = [NSString stringWithFormat:@"Level: %d", (self.level)];
    [_levelLabel setString:levelString];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor ground:(CCNodeColor *)ground{
    [meteor removeFromParent];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor evilDino:(dinosaur *)evilDino{
    [meteor removeFromParent];
    [evilDino removeFromParent];
    [self addPointsToScore:evilDino.killBonus];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor dinosaur:(dinosaur *)dinosaur{
    [meteor removeFromParent];
    [dinosaur removeFromParent];
    numDinos -= 1;
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair dinosaur:(dinosaur *)dinosaur evilDino:(dinosaur *)evilDino{
    [dinosaur removeFromParent];
    numDinos -= 1;
    return NO;
}

-(void) update:(CCTime)delta{
    if(numDinos == 0){
        [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
    }
}


-(void) updateBySecond{
    timeElapsed += 1;
    
    if(timeElapsed%SECONDS_TO_LEVEL_UPDATE == 0){
        level += 1;
        meteorSpeed += 50;
        [self spawnEnemyDino];
    }
    
    [self setTimeLabel];
    [self setLevelLabel];
}

@end

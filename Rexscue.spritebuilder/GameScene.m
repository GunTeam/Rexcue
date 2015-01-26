//
//  GameScene.m
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

@synthesize score, meteorSpeed, timeElapsed, numDinos, level, secondsBetweenMeteors, meteorHittingGroundBonus;

-(void) didLoadFromCCB {
    NUM_STARTING_DINOS = 6;
    SECONDS_TO_LEVEL_UPDATE = 5;
    secondsBetweenMeteors = 2;
    meteorHittingGroundBonus = 100;
    
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
//    _physicsNode.debugDraw = true;
    
    _ground.physicsBody.collisionType = @"ground";
    
    [self schedule:@selector(spawnMeteor:) interval:secondsBetweenMeteors];
    
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
            positionY = screenHeight/11;
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
    newDino.scale = 0.6;
    
    
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
    double positionX = 0; //arc4random()%(int)screenWidth;
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
            positionY = screenHeight/9;
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
    int directionFlag = 1; //arc4random()%2;
    [newDino setDirection:directionFlag];
    
    if(directionFlag ==1){
        newDino.scaleX *= -1;
        [newDino reverseHealthLabel];
    }
    newDino.physicsBody.collisionType = @"evilDino";
    newDino.physicsBody.collisionGroup = @"evilDinos";
    [newDino setIsEnemy:true];
    [newDino setHealthInvisible];
    [_physicsNode addChild:newDino];
}

-(void) spawnMeteor:(CCTime) dt{
    Meteor *meteor = (Meteor *)[CCBReader load:@"Meteor"];
    meteor.position = CGPointMake(arc4random()%(int)screenWidth, screenHeight+screenHeight/4);
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
    Smoke *smoke = (Smoke*)[CCBReader load:@"Smoke"];
    smoke.position = meteor.position;
    [meteor removeFromParent];
    [self addPointsToScore:100];
    [self addChild:smoke];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor evilDino:(dinosaur *)evilDino{
    [meteor removeFromParent];
    evilDino.physicsBody.collisionMask = @[];
    [evilDino.animationManager runAnimationsForSequenceNamed:@"Dying"];
    [evilDino scheduleOnce:@selector(removeFromParent) delay:2];
    [self addPointsToScore:evilDino.killBonus];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor dinosaur:(dinosaur *)dinosaur{
    [meteor removeFromParent];
    [dinosaur die];
    numDinos -= 1;
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair dinosaur:(dinosaur *)dinosaur evilDino:(dinosaur *)evilDino{
    Boolean killed = [dinosaur attackedByDino:evilDino];
    if(killed){
        numDinos -= 1;
    }
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
        if(level == 5){
            [self spawnEnemyDino];
        }
        if(secondsBetweenMeteors > 0.1){
            secondsBetweenMeteors -= 0.1;
        }
        else if(secondsBetweenMeteors > 0.01){
            secondsBetweenMeteors -= 0.01;
        }
        [self unschedule:@selector(spawnMeteor:)];
        [self schedule:@selector(spawnMeteor:) interval:secondsBetweenMeteors];
    }
    
    [self setTimeLabel];
    [self setLevelLabel];
}

@end

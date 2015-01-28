//
//  GameScene.m
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

@synthesize score, meteorSpeed, timeElapsed, numDinos, level, secondsBetweenMeteors, meteorHittingGroundBonus, meteorScale;

-(void) didLoadFromCCB {
    NUM_STARTING_DINOS = 6;
    SECONDS_TO_LEVEL_UPDATE = 5;
    secondsBetweenMeteors = 2;
    meteorHittingGroundBonus = 100;
    meteorScale = 0.5;
    meteorsToSpawnAtOnce = 1;

    ourDinos = [[NSMutableArray alloc] init];
    
    _volcanoSmoke.duration = -1;
    _volcanoSmoke.emissionRate = 20;

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
    
    [self spawnClouds];
    
    for(int i=0; i<NUM_STARTING_DINOS; i++){
        [self addRandomDino];
    }
    
    meteorSpeed = 100;
    timeElapsed = 0;
    numDinos = NUM_STARTING_DINOS;
    level = 0;
    
    [self setTimeLabel];
    [self setLevelLabel];
    [self addPointsToScore:0];
//    [self spawnEnemyDino];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"GamePlay.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
    
    [self schedule:@selector(updateBySecond) interval:1];
}

-(void) spawnClouds{
    for(int i =1; i<4; i++){
        int upperBound = screenHeight;
        int lowerBound = (3./4)*screenHeight;
        int positionY = lowerBound + arc4random() % (int)(upperBound - lowerBound);
        
        int positionX = arc4random()%2;
        int direction = positionX;
        positionX *= screenWidth;
        
        NSString *cloudFile = [NSString stringWithFormat:@"DarkCloud%i",i];
        Cloud *cloud = (Cloud*)[CCBReader load:cloudFile];
        
        cloud.opacity = 0.2;
        
        [cloud setPosition:ccp(positionX,positionY)];
        cloud.direction = direction;
        cloud.speed = (arc4random()%3+1)/150.0;
        cloud.scale = 2;
        [_physicsNode addChild: cloud];
    }
    
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
    [ourDinos addObject:newDino];
}

-(void) spawnEnemyDino{
    
    dinosaur *newDino;
    int randSpawnFlag = arc4random()%4;
    double positionX = 0; //arc4random()%(int)screenWidth;
    double positionY = screenHeight;
    
    switch (randSpawnFlag)
    {
        case 0:
            newDino = (Allosaurus*)[CCBReader load:@"EvilAllosaurus"];
//            positionY = screenHeight/4;
            break;
        case 1:
            newDino = (TRex*)[CCBReader load:@"EvilTRex"];
            break;
        case 2:
            newDino = (Stegosaurus*)[CCBReader load:@"EvilStegosaurus"];
//            positionY = screenHeight/9;
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
    newDino.scale = 0.6;
    
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
    [newDino setSpeed:0.005];
    
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:2 position:ccp(0,-(7./8)*(screenHeight))];
    [newDino runAction:mover];
    
    [_physicsNode addChild:newDino];
}

-(void) spawnMeteor:(CCTime) dt{
    for(int i=0; i<meteorsToSpawnAtOnce; i++){
        Meteor *meteor = (Meteor *)[CCBReader load:@"Meteor"];
        meteor.scale = meteorScale;
        meteor.position = CGPointMake(arc4random()%(int)screenWidth, screenHeight+screenHeight/4);
        [_physicsNode addChild:meteor];
        [meteor setSpeed: meteorSpeed];
        [meteor launch];
    }
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
    [self addPointsToScore:meteorHittingGroundBonus];
    
    DisappearingLabel *label = [DisappearingLabel labelWithString:[NSString stringWithFormat:@"%i",meteorHittingGroundBonus]fontName:@"PatrickHandSC-Regular" fontSize:24];
    label.position = smoke.position;
    [self addChild:label];
    
    [self addChild:smoke];
    
    for(dinosaur *dino in ourDinos) {
        [dino panic];
    }
    
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor evilDino:(dinosaur *)evilDino{
    [meteor removeFromParent];
    evilDino.physicsBody.collisionMask = @[];
    [evilDino.animationManager runAnimationsForSequenceNamed:@"Dying"];
    [evilDino scheduleOnce:@selector(removeFromParent) delay:2];
    [self addPointsToScore:evilDino.killBonus];
    
    DisappearingLabel *label = [DisappearingLabel labelWithString:[NSString stringWithFormat:@"BANG!"]fontName:@"PatrickHandSC-Regular" fontSize:24];
    label.position = evilDino.position;
    [self addChild:label];
    
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteor:(Meteor *)meteor dinosaur:(dinosaur *)dinosaur{
    
    DisappearingLabel *label = [DisappearingLabel labelWithString:[NSString stringWithFormat:@"BAM!"]fontName:@"PatrickHandSC-Regular" fontSize:24];
    label.position = meteor.position;
    [self addChild:label];
    
    [meteor removeFromParent];
    Boolean killed = [dinosaur hitByMeteor];
    if(killed){
        numDinos -= 1;
        [ourDinos removeObject:dinosaur];
    }

    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair dinosaur:(dinosaur *)dinosaur evilDino:(dinosaur *)evilDino{
    DisappearingLabel *label = [DisappearingLabel labelWithString:[NSString stringWithFormat:@"POW!"]fontName:@"PatrickHandSC-Regular" fontSize:24];
    label.position = dinosaur.position;
    [self addChild:label];
    
    Boolean killed = [dinosaur attackedByDino:evilDino];
    if(killed){
        numDinos -= 1;
        [ourDinos removeObject:dinosaur];
    }
    return NO;
}

-(void) loseLevel{
    int highScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"HighScore"];
    if(self.score > highScore){
        [[NSUserDefaults standardUserDefaults]setInteger:self.score forKey:@"HighScore"];
    }
    [[NSUserDefaults standardUserDefaults]setInteger:self.score forKey:@"LastScore"];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameOver"]];
}

-(void) update:(CCTime)delta{
    if(numDinos == 0){
        [self loseLevel];
    }
    
}

-(void) increaseMeteorFrequency{

    if(secondsBetweenMeteors > 0.2){
        secondsBetweenMeteors -= 0.2;
    }
    else if(secondsBetweenMeteors > 0.02){
        secondsBetweenMeteors -= 0.02;
    }
    
    [self unschedule:@selector(spawnMeteor:)];
    [self schedule:@selector(spawnMeteor:) interval:secondsBetweenMeteors];
}

-(void) increaseMeteorSpeed{
    meteorSpeed += 50;
}

-(void) decreaseMeteorSize{
    if(meteorScale > 0.04){
        meteorScale -= 0.04;
    }
    else if(meteorScale > 0.002){
        meteorScale -= 0.002;
    }
}

-(void) increaseMeteorsToSpawnAtOnce{
    meteorsToSpawnAtOnce ++;
}

-(void) updateBySecond{
    timeElapsed += 1;
    
    if(timeElapsed%SECONDS_TO_LEVEL_UPDATE == 0){
        level += 1;
        if(level%5 == 0){
            [self spawnEnemyDino];
        }
        
        if(level%4 == 1){
            [self decreaseMeteorSize];
        }
        else if(level%4 == 2){
            [self increaseMeteorSpeed];
        }
        else if(level%4 == 3){
            [self increaseMeteorFrequency];
        }
        else{
            [self increaseMeteorsToSpawnAtOnce];
        }
        
    }
    
    [self setTimeLabel];
    [self setLevelLabel];
}

-(void) doPause{
    [musicPlayer stop];
    [[NSUserDefaults standardUserDefaults]setInteger:self.score forKey:@"LastScore"];
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Paused"]];
}

-(void) onEnter{
    [super onEnter];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        [musicPlayer play];
    }
    [[CCDirector sharedDirector] resume];
}

@end

//
//  GameScene.m
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

@synthesize score, meteorSpeed, timeElapsed, numDinos, level, secondsBetweenMeteors, meteorHittingGroundBonus, meteorScale, sandboxMode, playTutorial, meteorsDestroyed;

-(void) didLoadFromCCB {
    playTutorial = [[NSUserDefaults standardUserDefaults] boolForKey:@"playTutorial"];
    
    NUM_STARTING_DINOS = 6;
    SECONDS_TO_LEVEL_UPDATE = 5;
    PROBABILITY_OF_ENEMY_SPAWN = -1; //out of 1000
    
    secondsBetweenMeteors = 2;
    meteorHittingGroundBonus = 100;
    meteorScale = 0.5;
    meteorsToSpawnAtOnce = 1;
    backgroundIndex = 1;
    meteorIndex = 1;
    meteorsDestroyed = 0;
    
    backgroundToFade = (Background*)[CCBReader load:@"NormalScene"];
    
    backgrounds = @[@"NormalScene", @"IceScene",@"CavemanScene",@"RoadScene",@"ProtestScene",@"CityScene"];
    numBackgroundsToFade = [backgrounds count]-1;
    
    [self addChild:backgroundToFade z:-1];
    
    self.multiplier = 1;
    self.sandboxMode = [[NSUserDefaults standardUserDefaults]boolForKey:@"SandboxMode"];
    
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
    
    self.score = 0;
    
    for(int i=0; i<NUM_STARTING_DINOS; i++){
        [self addRandomDino];
    }
    
    meteorSpeed = 100;
    timeElapsed = 0;
    numDinos = NUM_STARTING_DINOS;
    level = 0;
    
    _ground.visible = false;
    
    [self setLevelLabel];
    [self addPointsToScore:0];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"GamePlay.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
    
    _tapPrompt.visible = false;
    
    if(playTutorial){
        [self createDemoEnemy];
        [self runTutorial];
    }
    else{
        [_tutorialMeteor removeFromParent];
        [_tapPrompt removeFromParent];
        [self startGame];
    }
}

-(void) runTutorial{

    for(dinosaur *dino in ourDinos){
        [dino setIsStationary:true];
        [dino.animationManager runAnimationsForSequenceNamed:@"Waving"];
    }
    
    Meteor *demoMeteor = (Meteor *)_tutorialMeteor;
    
    [demoMeteor setIsDemo:true];
    demoMeteor.physicsBody.collisionGroup = @"dinosaurs";
    _tapPrompt.visible = true;

    [demoMeteor setSpeed: meteorSpeed];
    [demoMeteor launch];

}

-(void) demoDestroyed{
    
    [self startEnemyDemo];
}

-(void) createDemoEnemy{
    int randSpawnFlag = arc4random()%4;
    switch (randSpawnFlag)
    {
        case 0:
            evilDemo = (Allosaurus*)[CCBReader load:@"EvilAllosaurus"];
            break;
        case 1:
            evilDemo = (TRex*)[CCBReader load:@"EvilTRex"];
            break;
        case 2:
            evilDemo = (Stegosaurus*)[CCBReader load:@"EvilStegosaurus"];
            //            positionY = screenHeight/9;
            break;
        case 3:
            evilDemo = (Triceratops*)[CCBReader load:@"EvilTriceratops"];
            break;
        default:
            break;
            
    }
    double positionX = (1.00/2)*screenWidth;//arc4random()%(int)screenWidth;
    double positionY =  screenHeight+(1./3)*screenHeight;;
    
    evilDemo.scale = 0.6;
    evilDemo.position = CGPointMake(positionX, positionY);
    [evilDemo setIsStationary:true];
    [self addChild:evilDemo];
}

-(void) startEnemyDemo{
    [_tapPrompt setString:@"Tap the evil dino to save the good dinos!"];
    
    [evilDemo setIsEnemy:true];
    [evilDemo setIsStationary:true];

    double destinationY = -(7./8)*(screenHeight);
    
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:4 position:ccp(0,destinationY)];
    [evilDemo runAction:mover];
    
    [evilDemo playAttackSound];
    
    [evilDemo.animationManager runAnimationsForSequenceNamed:@"Attacking"];
    
}

-(void) startGame{
    [self schedule:@selector(spawnMeteor:) interval:secondsBetweenMeteors];
    [self schedule:@selector(updateBySecond) interval:1];
    for(dinosaur *dino in ourDinos){
        [dino setIsStationary:false];
        [dino.animationManager runAnimationsForSequenceNamed:@"Walking"];
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
        positionY = (8./10)*screenHeight;
    }
    newDino.position = CGPointMake(positionX, positionY);
    
    //point the dino in a random direction:
    int directionFlag = arc4random()%2;
    [newDino setDirection:directionFlag];
    
    if(directionFlag ==1){
        newDino.scaleX *= -1;
    }
    
    [_physicsNode addChild:newDino];
    numDinos += 1;
    [ourDinos addObject:newDino];
}

-(void) spawnEnemyDino{
    
    dinosaur *newDino;
    newDino.physicsBody.collisionGroup = @"meteors";
    int randSpawnFlag = arc4random()%4;
    double positionX = (1.00/2)*screenWidth;//arc4random()%(int)screenWidth;
    double positionY = screenHeight+(1./4)*screenHeight;
    
    double destinationY = -(7./8)*(screenHeight);
    
    switch (randSpawnFlag)
    {
        case 0:
            newDino = (Allosaurus*)[CCBReader load:@"EvilAllosaurus"];
            destinationY = -(6./8)*(screenHeight);
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
    }
    newDino.physicsBody.collisionType = @"meteor";
    newDino.physicsBody.collisionGroup = @"meteors";
    [newDino setIsEnemy:true];
    [newDino setSpeed:0.005];
    
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:4 position:ccp(0,destinationY)];
    [newDino runAction:mover];
    
    [newDino playAttackSound];
    
    [newDino.animationManager runAnimationsForSequenceNamed:@"Attacking"];
    
    [_physicsNode addChild:newDino];
}

-(void) spawnMeteor:(CCTime) dt{
    int randSpawnFlag = arc4random()%1000;
    if(randSpawnFlag<= PROBABILITY_OF_ENEMY_SPAWN){
        for(int i=0; i<meteorsToSpawnAtOnce; i++){
            [self spawnEnemyDino];
        }
    }
    else{
        NSString *ccbFileString = @"Meteor";
        if(meteorIndex == 2){
            ccbFileString = @"IceMeteor";
        }
        else if(meteorIndex == 4){
            ccbFileString = @"ElectricMeteor";
        }
        else if(meteorIndex == 5){
            ccbFileString = @"NatureMeteor";
        }
        else if(meteorIndex >= 6){
            ccbFileString = @"RainbowMeteor";
        }
        for(int i=0; i<meteorsToSpawnAtOnce; i++){
            Meteor *meteor = (Meteor *)[CCBReader load:ccbFileString];
            meteor.scale = meteorScale;
            meteor.position = CGPointMake(arc4random()%(int)screenWidth, screenHeight+screenHeight/4);
            [_physicsNode addChild:meteor];
            [meteor setSpeed: meteorSpeed];
            [meteor launch];
        }
    }
}

-(void) addPointsToScore: (int) points{
    self.score += points;
    NSString *scoreString = [NSString stringWithFormat:@"%d", (self.score)];
    [_scoreLabel setString:scoreString];
}


-(void) addPointsToScore: (int) points fromMeteor: (Meteor*) meteor{
    self.score += points;
    NSString *scoreString = [NSString stringWithFormat:@"%d", (self.score)];
    [_scoreLabel setString:scoreString];
    meteorsDestroyed += 1;
}


-(void) setLevelLabel{
    NSString *levelString = [NSString stringWithFormat:@"Level: %d", (self.level)];
    [_levelLabel setString:levelString];
}

-(void) panicDinos{
    for(dinosaur *dino in ourDinos) {
        [dino panic];
    }
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
    
    [self panicDinos];
    
    if([meteor isDemo]){
        [self demoDestroyed];
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
    
    self.multiplier = 1;
    
    DisappearingLabel *label = [DisappearingLabel labelWithString:[NSString stringWithFormat:@"BAM!"]fontName:@"PatrickHandSC-Regular" fontSize:24];
    label.position = meteor.position;
    [self addChild:label];
    
    [meteor removeFromParent];
    Boolean killed = [dinosaur hurt];
    if(killed){
        numDinos -= 1;
        [ourDinos removeObject:dinosaur];
        long dinosKilled =[[NSUserDefaults standardUserDefaults]integerForKey:@"DinosLost"]+1;
        [[NSUserDefaults standardUserDefaults]setInteger:dinosKilled forKey:@"DinosLost"];
    }

    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair dinosaur:(dinosaur *)dinosaur evilDino:(dinosaur *)evilDino{
    self.multiplier = 1;
    
    DisappearingLabel *label = [DisappearingLabel labelWithString:[NSString stringWithFormat:@"POW!"]fontName:@"PatrickHandSC-Regular" fontSize:24];
    label.position = dinosaur.position;
    [self addChild:label];
    
    Boolean killed = [dinosaur attackedByDino:evilDino];
    if(killed){
        numDinos -= 1;
        [ourDinos removeObject:dinosaur];
        long dinosKilled =[[NSUserDefaults standardUserDefaults]integerForKey:@"DinosLost"]+1;
        [[NSUserDefaults standardUserDefaults]setInteger:dinosKilled forKey:@"DinosLost"];

    }
    return NO;
}

-(void) loseLevel{
    long highScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"HighScore"];
    long bestLevel = [[NSUserDefaults standardUserDefaults]integerForKey:@"BestLevel"];
    long pastMeteors = [[NSUserDefaults standardUserDefaults]integerForKey:@"MeteorsDestroyed"];
    long totalMeteors = pastMeteors + meteorsDestroyed;
    [[NSUserDefaults standardUserDefaults]setInteger:totalMeteors forKey:@"MeteorsDestroyed"];

    if(self.score > highScore){
        [[NSUserDefaults standardUserDefaults]setInteger:self.score forKey:@"HighScore"];
    }
    if(self.level > bestLevel){
        [[NSUserDefaults standardUserDefaults]setInteger:self.level forKey:@"BestLevel"];
    }
    
    [[NSUserDefaults standardUserDefaults]setInteger:self.score forKey:@"LastScore"];
    [[NSUserDefaults standardUserDefaults]setInteger:self.level forKey:@"LastLevel"];

    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameOver"]];
}

-(void) phaseBackground{
    backgroundIndex ++;
    meteorIndex ++;
    backgroundIndex = MIN(numBackgroundsToFade, backgroundIndex);
    backgroundToFade.cascadeOpacityEnabled = true;

    NSString *backgroundAdd = [backgrounds objectAtIndex:(backgroundIndex-1)];
    CCSprite *backgroundToAdd =(Background*)[CCBReader load:backgroundAdd];
    
    backgroundToAdd.cascadeOpacityEnabled = true;
    [self addChild:backgroundToAdd z:-(backgroundIndex)];

    [backgroundToFade runAction:[CCActionFadeOut actionWithDuration:2]];
    [backgroundToFade scheduleOnce:@selector(removeFromParent) delay:3];

//    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:2];
//    
//    [backgroundToAdd runAction:fadeIn];
//    [self scheduleOnce:@selector(addChild:backgroundToAdd z:-1) delay:2];
    
    
    backgroundToFade = backgroundToAdd;

}

-(void) update:(CCTime)delta{
    if(numDinos == 0){
        [self loseLevel];
    }
    if(playTutorial){
        if(![[self children] containsObject:evilDemo]){
            [_tapPrompt removeFromParent];
            playTutorial = false;
            [self scheduleOnce:@selector(startGame) delay:1];
        }
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
    if(meteorScale > 0.02){
        meteorScale -= 0.02;
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
            [self phaseBackground];
        }
        
        if(!self.sandboxMode){
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
        else{
            if(level%5 == 0){
                [self increaseMeteorsToSpawnAtOnce];
            }
        }
        
    }
    
    [self setLevelLabel];
}

-(void) doPause{
    [musicPlayer stop];
    [[NSUserDefaults standardUserDefaults]setInteger:self.score forKey:@"LastScore"];
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Paused"]];
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    self.multiplier = 1;
}

-(void) onEnter{
    [super onEnter];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        [musicPlayer play];
    }
    [[CCDirector sharedDirector] resume];
}

@end

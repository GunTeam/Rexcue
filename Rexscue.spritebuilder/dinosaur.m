//
//  dinosaur.m
//  dinogame
//
//  Created by Laura Breiman on 1/7/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "dinosaur.h"

@implementation dinosaur

@synthesize health, speed, attack, inAir, killBonus, readyToAttack, attackCounter, afterAttackDelay, price, levelMultiplier, direction, turnWait,isStationary;

-(void) didLoadFromCCB{
    self.physicsBody.collisionType = @"dinosaur";
    self.physicsBody.collisionGroup = @"dinosaurs";
    self.userInteractionEnabled = true;
    
    self.direction = 0;
    self.turnWait = 0;

    soundsOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"EffectsOn"];
    
    evilSounds = @[@"rawr2.mp3", @"grr.mp3",@"rawr.mp3", @"growl.mp3",@"grrAndStuff.mp3"];
    
    self.levelMultiplier = 1;
    self.isEnemy = false;
    MAX_HEALTH = 100;
    self.health = MAX_HEALTH;
    KNOCKBACK_THRESHOLD = MAX_HEALTH/2; //point at which the dino gets knocked back
    _healthLabel.string = [NSString stringWithFormat:@"%f", self.health];
    self.attack = 50;
    self.speed = 0.01; //default
    ATTACK_THRESHOLD = 10; //number of pix between this dino and its attack target. e.g. some dinosaurs get closer than others to their enemy
    self.readyToAttack = true;
    self.afterAttackDelay = 60;
    self.attackCounter = 0;
    self.price = 200;
    self.killBonus = 100;
    self.isStationary = false;
    self.hasMittens = false;
    
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    [self setHealthInvisible];
    
    //adjust for ipad sizing:
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        screenWidth = screenWidth/2;
        screenHeight = screenHeight/2;
    }
    
    audioPlayer =  [OALSimpleAudio sharedInstance];
    audioPlayer.effectsVolume = 1.5;
    
    _frontMitten.visible = false;
    _backMitten.visible = false;
    _hat.visible = false;
    
    if(self.hasMittens){
        [self putOnMittens];
    }
    else{
        self.isWearingTheirMittens = false;
    }
    
    if(self.hasHat){
        [self putOnHat];
    }
    else{
        self.isWearingTheirHat = false;
    }
}

-(void) playHurtSound{
    if(soundsOn){
        int randomSound = arc4random()%(sounds.count-1);
        [audioPlayer playEffect:[sounds objectAtIndex:randomSound]];
    }
}

-(void) setHealthLabel{
    _healthLabel.string = [NSString stringWithFormat:@"%d", (int)(self.health+0.5)];
}

-(void) setHealthInvisible{
    _healthLabel.visible = false;
}

-(void) changeLevelMultiplier: (double) newMultiplier{
    self.levelMultiplier = newMultiplier;
    self.health *= levelMultiplier;
    self.speed *= levelMultiplier;
    self.attack *= levelMultiplier;
    self.attackCounter *= levelMultiplier;
    self.killBonus *= levelMultiplier;
    [self setHealthLabel];
}

-(void) moveDinoForward{
    self.position = ccp( self.position.x + 100*self.speed, self.position.y );
}

-(void) moveDinoBackward{
    self.position = ccp( self.position.x - 100*self.speed, self.position.y );
}

-(Boolean) collidesWith:(dinosaur *)otherDino{
    int distanceAway = (1./2)*self.contentSize.width + (1./2)*otherDino.contentSize.width;
    if( abs(otherDino.position.x - self.position.x) <= (ATTACK_THRESHOLD+distanceAway)){
        return true;
    }
    return false;
}

-(void) attackDino:(dinosaur *)enemyDino{
    enemyDino.health -= self.attack;
}

-(void) knockback{
    int knockbackAmount = self.contentSize.width;

    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:1 position:ccp(-(0.5)*knockbackAmount,0)];
    [self runAction:mover];
    [self.animationManager runAnimationsForSequenceNamed:@"Knockback"];
}

-(void) knockforward{
    int knockbackAmount = self.contentSize.width;

    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:1 position:ccp((0.5)*knockbackAmount,0)];
    [self runAction:mover];
    [self.animationManager runAnimationsForSequenceNamed:@"Knockback"];
}

-(void) die{
    self.isDead = true;
    self.physicsBody.collisionMask = @[];

    [self playHurtSound];
    
    [self.animationManager runAnimationsForSequenceNamed:@"Dying"];
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:1 position:ccp(0,-(1./2)*self.contentSize.height)];
    [self runAction:mover];
//    self.cascadeOpacityEnabled = true;
//    [self runAction:[CCActionFadeOut actionWithDuration:2]];
    [self scheduleOnce:@selector(removeFromParent) delay:2];
}

-(Boolean) attackedByDino:(dinosaur *)otherDino{
    [otherDino playAttackSound];
    [otherDino.animationManager runAnimationsForSequenceNamed:@"Attacking"];
    otherDino.readyToAttack = false;
    self.health -= otherDino.attack;
    [self setHealthLabel];
    
    
    if(direction == 0 && otherDino.position.x > self.position.x){
        [self knockback];
    }
    else if(direction == 0 && otherDino.position.x < self.position.x){
        [self knockforward];
    }
    else if(direction == 1 && otherDino.position.x > self.position.x){
        [self knockback];
    }
    else if(direction == 1 && otherDino.position.x < self.position.x){
        [self knockforward];
    }
    
    if(self.health <= 0){
        return [self hurt];
    }
    return false;
}

-(Boolean) isEnemyNest{
    return false;
}

-(void) reverseHealthLabel{
    _healthLabel.scaleX = -1;
}

-(void) panic{
    if(soundsOn){
        [audioPlayer playEffect:[sounds objectAtIndex:sounds.count-1]];
    }
    [self.animationManager runAnimationsForSequenceNamed:@"Panic"];
}

-(void) reverseDinoDirection{
    self.direction = (self.direction+1)%2;
//    self.scaleX *= -1;
    [self reverseHealthLabel];
}

-(void) loseMittens{
    self.isWearingTheirMittens =  false;
    [self playHurtSound];
    
    [self.animationManager runAnimationsForSequenceNamed:@"MittensOff"];
    _frontMitten.cascadeOpacityEnabled = true;
    [_frontMitten runAction:[CCActionFadeOut actionWithDuration:2]];
    _backMitten.cascadeOpacityEnabled = true;
    [_backMitten runAction:[CCActionFadeOut actionWithDuration:2]];
}

-(void) loseHat{
    self.isWearingTheirHat =  false;
    [self playHurtSound];

    [self.animationManager runAnimationsForSequenceNamed:@"HatOff"];
    _hat.visible = false;
}

-(Boolean) hurt{
    if(self.isWearingTheirHat){
        [self loseHat];
        return false;
    }
    else if(self.isWearingTheirMittens){
        [self loseMittens];
        return false;
    }
    else{
        [self die];
        return true;
    }
//
//    
//    [self die];
//    return true;
}

-(void) update:(CCTime)delta{
    if(!self.isStationary && !self.isDead){
        if(self.direction == 1){
            [self moveDinoForward];
        }
        else{
            [self moveDinoBackward];
        }
        
        if(self.position.x > screenWidth){
            self.position = ccp(0, self.position.y);
        }
        else if(self.position.x < 0){
            self.position = ccp(screenWidth, self.position.y);
        }
        
        self.attackCounter += 1;
        if(self.attackCounter > self.afterAttackDelay){
            self.readyToAttack = true;
            self.attackCounter = 0;
        }
    }

    
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    if(self.isEnemy){
//        GameScene *gameScene = (GameScene *)self.parent.parent;
//        [gameScene addPointsToScore: (int)(killBonus) ];
        [self removeFromParent];
    }
}

-(void) playAttackSound{
    if(soundsOn){
        int randomSound = arc4random()%(sounds.count-1);
        [audioPlayer playEffect:[evilSounds objectAtIndex:randomSound]];
    }

}

-(void) putOnMittens{
    _frontMitten.visible = true;
    _backMitten.visible = true;
    self.isWearingTheirMittens = true;
}

-(void) putOnHat{
    _hat.visible = true;
    self.isWearingTheirHat = true;
}


@end

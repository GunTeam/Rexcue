//
//  dinosaur.m
//  dinogame
//
//  Created by Laura Breiman on 1/7/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "dinosaur.h"

@implementation dinosaur

@synthesize health, speed, attack, inAir, killBonus, readyToAttack, attackCounter, afterAttackDelay, direction, turnWait,isStationary, tapsToKillEnemy;

-(void) didLoadFromCCB{
    self.physicsBody.collisionType = @"dinosaur";
    self.physicsBody.collisionGroup = @"dinosaurs";
    self.userInteractionEnabled = true;
    
    self.direction = 0;
    self.turnWait = 0;

    tapsToKillEnemy = 1;
    
    soundsOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"EffectsOn"];
    
    evilSounds = @[@"rawr2.mp3", @"grr.mp3",@"rawr.mp3", @"growl.mp3",@"grrAndStuff.mp3"];
    
    self.isEnemy = false;
    MAX_HEALTH = 100;
    self.health = MAX_HEALTH;
    self.attack = 50;
    self.speed = 0.01; //default
    self.readyToAttack = true;
    self.afterAttackDelay = 60;
    self.attackCounter = 0;
    self.killBonus = 100;
    self.isStationary = false;
    self.hasMittens = false;
    
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

-(void) moveDinoForward{
    self.position = ccp( self.position.x + 100*self.speed, self.position.y );
}

-(void) moveDinoBackward{
    self.position = ccp( self.position.x - 100*self.speed, self.position.y );
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
    [self scheduleOnce:@selector(removeFromParent) delay:2];
}

-(Boolean) attackedByDino:(dinosaur *)otherDino{
    [otherDino playAttackSound];
    [otherDino.animationManager runAnimationsForSequenceNamed:@"Attacking"];
    otherDino.readyToAttack = false;
    self.health -= otherDino.attack;

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

-(void) panic{
    if(soundsOn){
        [audioPlayer playEffect:[sounds objectAtIndex:sounds.count-1]];
    }
    [self.animationManager runAnimationsForSequenceNamed:@"Panic"];
}


-(void) loseMittens{
    self.isWearingTheirMittens =  false;
    [self playHurtSound];
    
    [self.animationManager runAnimationsForSequenceNamed:@"MittensOff"];
    _frontMitten.cascadeOpacityEnabled = true;
    [_frontMitten runAction:[CCActionFadeOut actionWithDuration:1]];
    _backMitten.cascadeOpacityEnabled = true;
    [_backMitten runAction:[CCActionFadeOut actionWithDuration:1]];
}

-(void) loseHat{
    self.isWearingTheirHat =  false;
    [self playHurtSound];

    [self.animationManager runAnimationsForSequenceNamed:@"HatOff"];
    _hat.cascadeOpacityEnabled = true;
    [_hat runAction:[CCActionFadeOut actionWithDuration:1]];
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
        if(tapsToKillEnemy <= 0){
            Smoke *smoke = (Smoke*)[CCBReader load:@"Smoke"];
            smoke.position = self.position;
            smoke.color = _enemyParticles.color;
            [self.parent addChild:smoke];
            self.isDead = true;
            self.physicsBody.collisionMask = @[];
            [self.animationManager runAnimationsForSequenceNamed:@"Explode"];
            [self scheduleOnce:@selector(removeFromParent) delay:1];
            self.userInteractionEnabled = false;
            if(soundsOn){
                int effect = arc4random() % 3;
                if (effect == 0) {
                    [audioPlayer playEffect:@"grrrreat.mp3"];
                } else if (effect == 1){
                    [audioPlayer playEffect:@"goodJob.mp3"];
                } else if (effect == 2){
                    [audioPlayer playEffect:@"nice.mp3"];
                }
            }
        }
        else{
            Explosion *explosion = (Explosion*)[CCBReader load:@"Explosion"];
            explosion.position = self.position;
            [self.parent addChild:explosion];
            tapsToKillEnemy -= 1;
        }
    }
}

-(void) playAttackSound{
    if(soundsOn){
        int randomSound = arc4random()%(sounds.count-1);
        [audioPlayer playEffect:[evilSounds objectAtIndex:randomSound]];
    }

}

-(void) putOnMittens{
    self.hasMittens = true;
    _frontMitten.visible = true;
    _backMitten.visible = true;
    self.isWearingTheirMittens = true;
}

-(void) putOnHat{
    self.hasHat = true;
    _hat.visible = true;
    self.isWearingTheirHat = true;
}

-(NSString*) getType{
    return @"Generic Dinosaur";
}


@end

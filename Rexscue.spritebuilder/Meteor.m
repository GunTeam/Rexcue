//
//  Meteor.m
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Meteor.h"


@implementation Meteor
@synthesize isDemo;

-(void)didLoadFromCCB{
    self.speed = 0;
    self.userInteractionEnabled = true;
    
    self.isDemo = false;
    
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
    
    soundsOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"EffectsOn"];
    audioPlayer =  [OALSimpleAudio sharedInstance];
    MAX_LABEL_SIZE = 30;
    }

-(void)launch{
    int destinationX = arc4random()%(int)screenWidth;
    
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
    
    int pointsEarned = (int)(screenHeight+self.position.y)+50;
    
    CCColor *color = [CCColor colorWithRed:0.0 green: 0.0 blue:0];
    
    NSString *scoreLabel = [NSString stringWithFormat:@"%i",pointsEarned];
    int labelSize = 24;
    
    if(!isDemo){
        int multiplier = [gameScene multiplier];
        labelSize = MIN(MAX_LABEL_SIZE, labelSize+multiplier);
        color = [CCColor colorWithRed:0 green: (multiplier/10.)-0.1 blue:0];
        scoreLabel = [NSString stringWithFormat:@"%i\rx%i",pointsEarned,multiplier];
        pointsEarned = multiplier*pointsEarned;
        [gameScene addPointsToScore: pointsEarned];
        [gameScene setMultiplier:(multiplier+1)];
    }
    
    [self removeFromParent];
    [gameScene addChild:explosion];
    
    DisappearingLabel *label = [DisappearingLabel labelWithString:scoreLabel fontName:@"PatrickHandSC-Regular" fontSize:labelSize];
    label.color = color;
    label.position = explosion.position;
    [gameScene addChild:label];
    
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

@end

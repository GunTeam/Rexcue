#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Cloud.h"
#import "TRex.h"
#import "Stegosaurus.h"
#import "Triceratops.h"
#import "Allosaurus.h"
#import "Pterodactyl.h"
#import "GameScene.h"
#import "Upgrades.h"

@interface MainScene : CCNode{
    CGFloat screenWidth,screenHeight;
    Stegosaurus *_stego;
    Pterodactyl *_ptero;
    TRex *_trex;
    Triceratops *_trice;
    Allosaurus *_allosaurus;
    CCButton *playButton, *_menuButton;
    OALAudioTrack *musicPlayer;
    Cloud *_cloud1, *_cloud2, *_cloud3;
    CCParticleSystem *_smopocalypse;
    NSArray *dinos;
}

@property Boolean soundEffectsOn;
@property Boolean musicOn;
@property long numNeedles;

@end

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Cloud.h"
#import "TRex.h"
#import "Stegosaurus.h"
#import "Triceratops.h"
#import "Allosaurus.h"
#import "Pterodactyl.h"
#import "GameScene.h"

@interface MainScene : CCNode{
    CGFloat screenWidth,screenHeight;
    Stegosaurus *_stego;
    Pterodactyl *_ptero;
    TRex *_trex;
    Triceratops *_trice;
    Allosaurus *_allosaurus;
    CCButton *playButton, *_menuButton;
    OALAudioTrack *musicPlayer;
}

@property Boolean soundEffectsOn;
@property Boolean musicOn;

@end

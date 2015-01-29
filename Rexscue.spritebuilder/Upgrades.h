//
//  Upgrades.h
//  Rexscue
//
//  Created by Anna Neuman on 1/28/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "dinosaur.h"

@interface Upgrades : CCNode {
    dinosaur *_triceratops, *_pterodactyl, *_allosaurus, *_trex, *_stegosaurus;
    NSArray *ourdinos;
    CCParticleSystem *_selector;
    CCButton *mittenUpgrade;
    CCButton *needleUpgrade;
    CCButton *hatUpgrade;
    CCButton *pteroUpgrade;
    CCButton *tricUpgrade;
    CCButton *trexUpgrade;
    CCButton *alloUpgrade;
    CCButton *stegoUpgrade;
}

@end

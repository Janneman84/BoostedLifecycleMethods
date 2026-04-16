//
//  Initializer.m
//  MixedFwk
//
//  Created by Eidinger, Marco on 11/14/22.
//

#import "Initializer.h"
@import BoostedLifecycleMethods;

@implementation Initializer
+(void)load {
    [UIViewController _boostLifecycleMethodsWithDebug:NO]; //this automatically initializes the package on startup
}
@end

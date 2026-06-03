//
//  Initializer.m
//  MixedFwk
//
//  Created by Eidinger, Marco on 11/14/22.
//

#import "InitializerBLM.h"
@import BoostedLifecycleMethods;

@implementation InitializerBLM
+(void)load {
    [UIViewController _boostLifecycleMethodsWithDebug:NO]; //this automatically initializes the package on startup
}
@end

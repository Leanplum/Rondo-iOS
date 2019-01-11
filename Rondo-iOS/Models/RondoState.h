//
//  InternalState.h
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeanplumApp.h"
#import "LeanplumEnv.h"

@interface RondoState : NSObject

@property (nonatomic, strong) LeanplumApp *app;
@property (nonatomic, strong) LeanplumEnv *env;
@property (nonatomic, strong) NSString *sdkVersion;

+ (RondoState *)sharedState;

@end
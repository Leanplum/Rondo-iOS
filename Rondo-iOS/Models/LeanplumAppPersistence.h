//
//  LeanplumAppPersistence.h
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeanplumApp.h"

@interface LeanplumAppPersistence : NSObject

+(void)saveLeanplumApp:(LeanplumApp *)app;
+(NSArray <LeanplumApp *> *)loadLeanplumApps;
+(LeanplumApp *)rondoQAProduction;
+(void)seedDatabase;
+(LeanplumApp *)rondoQAProductionSeed;

@end

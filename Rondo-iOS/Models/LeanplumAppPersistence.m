//
//  LeanplumAppPersistence.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumAppPersistence.h"
#import <Realm/Realm.h>

@implementation LeanplumAppPersistence

+(void)saveLeanplumApp:(LeanplumApp *)app {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:app];
    }];
}

+(NSArray <LeanplumApp *> *)loadLeanplumApps {
    RLMResults<LeanplumApp *> *results = [LeanplumApp allObjects];
    NSMutableArray <LeanplumApp *> *apps = [NSMutableArray arrayWithCapacity:results.count];
    for (int i=0;i<results.count;i++) {
        LeanplumApp *app = [results objectAtIndex:i];
        [apps addObject:app];
    }
    return apps;
}

+(LeanplumApp *)rondoQAProduction {
    RLMResults<LeanplumApp *> *results = [LeanplumApp objectsWhere:@"displayName = 'Rondo QA Production'"];
    return results.firstObject;
}

+(void)seedDatabase {
    if (![self rondoQAProduction]) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:[self rondoQAProductionSeed]];
        }];
    }
}

+(LeanplumApp *)rondoQAProductionSeed {
    LeanplumApp *app = [LeanplumApp new];
    app.displayName = @"Rondo QA Production";
    app.appId = @"app_ve9UCNlqI8dy6Omzfu1rEh6hkWonNHVZJIWtLLt6aLs";
    app.devKey = @"dev_cKF5HMpLGqhbovlEGMKjgTuf8AHfr2Jar6rrnNhtzQ0";
    app.prodKey = @"prod_D5ECYBLrRrrOYaFZvAFFHTg1JyZ2Llixe5s077Lw3rM";
    return app;
}

@end
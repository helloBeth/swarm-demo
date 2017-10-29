//
//  AllDataManager.m
//  SignInSample
//
//  Created by jy on 2017/10/2.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "AllDataManager.h"

@implementation AllDataManager

DEFINE_SINGLETON_FOR_CLASS(AllDataManager);
- (id)init
{
    self = [super init];
    if(self)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        _dicToken = [userDefaults objectForKey:@"dicToken"];
        _userInfo = [userDefaults objectForKey:@"userInfo"];
    }
    
    return self;
}

@end

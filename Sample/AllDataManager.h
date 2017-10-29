//
//  AllDataManager.h
//  SignInSample
//
//  Created by jy on 2017/10/2.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalMacro.h"

@interface AllDataManager : NSObject
DEFINE_SINGLETON_FOR_HEADER(AllDataManager);

@property (nonatomic,strong) NSDictionary *dicToken;
@property (nonatomic,strong) NSDictionary *userInfo;

@property (nonatomic,strong) NSArray *arrChunk;

@end

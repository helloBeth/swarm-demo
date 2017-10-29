//
//  NetLogicInterface.h
//
//
//  Created by jy on 17/8/5.
//  Copyright (c) 2017 me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "GlobalMacro.h"
#import <CoreLocation/CoreLocation.h>

@interface NetLogicInterface : NSObject<ASIHTTPRequestDelegate>

DEFINE_SINGLETON_FOR_HEADER(NetLogicInterface)


-(void)RequestGooleloginByTaskID:(NSString*)taskID;

-(void)RequestCurUserInfoByToken:(NSString*)access_token andTaskID:(NSString*)taskID;

-(void)RequestRatingByToken:(NSString*)access_token andCommentID:(NSString*)commentId andRateDic:(NSDictionary*)rateDic andTaskID:(NSString*)taskID;

-(void)RequestAddCommentByToken:(NSString*)access_token andParentID:(NSString*)parentId andContent :(NSString*)content andTaskID:(NSString*)taskID;

-(void)RequestAddAnswerByToken:(NSString*)access_token andParentID:(NSString*)parentId andContent:(NSString*)content andTaskID:(NSString*)taskID;

-(void)RequestAddQuestByToken:(NSString*)access_token andTitle:(NSString*)title andContent :(NSString*)content andTaskID:(NSString*)taskID;

-(void)RequestSuggestedChangeByToken:(NSString*)access_token andChunkID:(NSString*)chunkID andTaskID:(NSString*)taskID;

-(void)RequestCommentByToken:(NSString*)access_token andChunkID:(NSString*)chunkID andTaskID:(NSString*)taskID;

-(void)RequestHypothesisByToken:(NSString*)access_token andChunkID:(NSString*)chunkID andTaskID:(NSString*)taskID;

-(void)RequestChunkDetailByToken:(NSString*)access_token andChunkID:(NSString*)chunkID andTaskID:(NSString*)taskID;

-(void)RequestChunkByToken:(NSString*)access_token andTaskID:(NSString*)taskID;

-(void)RequestLoginByUsername:(NSString*)username andPassword:(NSString*)password andTaskID:(NSString*)taskID;

@end

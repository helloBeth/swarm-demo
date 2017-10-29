//
//  NetLogicInterface.m
//  ttk
//
//  Created by jy on 17/8/5.
//  Copyright (c) 2017 me. All rights reserved.
//

#import "NetLogicInterface.h"
#import "NSObject+SBJSON.h"
#import "ASIFormDataRequest.H"
#import "NetRequestConst.h"
#import "NSString+SBJSON.h"
#import "GlobalMacro.h"
#import "AppDelegate.h"


@implementation NetLogicInterface

DEFINE_SINGLETON_FOR_CLASS(NetLogicInterface)

-(void)RequestGooleloginByTaskID:(NSString*)taskID
{
    
}

-(void)RequestCurUserInfoByToken:(NSString*)access_token andTaskID:(NSString*)taskID
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RootUrl,@"/api/user/current"]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"Get"];
    //[request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [request setDownloadCache:appDelegate.myCache];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];
}


-(void)RequestRatingByToken:(NSString*)access_token andCommentID:(NSString*)commentId andRateDic :(NSDictionary*)rateDic andTaskID:(NSString*)taskID
{
    NSString* urlstr = [[NSString stringWithFormat:@"%@/api/chunk/%@/rate",RootUrl,commentId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rateDic options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"PUT"];
    [request setPostBody:tempJsonData];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:rateDic];
    [dic setObject:taskID forKey:@"taskID"];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [request setDownloadCache:appDelegate.myCache];
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];
    
}

-(void)RequestAddCommentByToken:(NSString*)access_token andParentID:(NSString*)parentId andContent :(NSString*)content andTaskID:(NSString*)taskID
{
    NSData *encodeData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    
    NSDictionary* para = [[NSDictionary alloc] initWithObjectsAndKeys: parentId, @"parentId", @"claim", @"type", base64String, @"content", @"comment", @"parentRelation",  @"text/html", @"contentType", nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RootUrl,@"/api/chunk"]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:parentId, @"parentId", @"claim", @"type", base64String, @"content", @"comment", @"parentRelation",  @"text/html", @"contentType", taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    [request setDownloadCache:appDelegate.myCache];

    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];
    
}

-(void)RequestAddAnswerByToken:(NSString*)access_token andParentID:(NSString*)parentId andContent :(NSString*)content andTaskID:(NSString*)taskID
{
    NSData *encodeData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    
    NSDictionary* para = [[NSDictionary alloc] initWithObjectsAndKeys: /*[NSNumber numberWithBool:YES], @"publicVisibility",*/parentId, @"parentId", @"claim", @"type", base64String, @"content", @"hypothesis", @"parentRelation",  @"text/html", @"contentType", nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RootUrl,@"/api/chunk"]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:parentId, @"parentId", @"claim", @"type", base64String, @"content", @"hypothesis", @"parentRelation",  @"text/html", @"contentType", taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    [request setDownloadCache:appDelegate.myCache];

    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];
    
}


-(void)RequestAddQuestByToken:(NSString*)access_token andTitle:(NSString*)title andContent :(NSString*)content andTaskID:(NSString*)taskID
{
    NSData *encodeData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    
    NSDictionary* para = [[NSDictionary alloc] initWithObjectsAndKeys: @"question", @"type",  title, @"title",  base64String, @"content",  @"text/html", @"contentType", @"open", @"state", nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RootUrl,@"/api/chunk"]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"publicVisibility", @"question", @"type",  title, @"title",  base64String, @"content",  @"text/html", @"contentType", taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
  
    [request setDownloadCache:appDelegate.myCache];
 
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];

}

-(void)RequestSuggestedChangeByToken:(NSString*)access_token andChunkID:(NSString*)chunkID andTaskID:(NSString*)taskID
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",RootUrl,@"/api/chunk/",chunkID,@"/suggestedChange"]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"Get"];
   
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [request setDownloadCache:appDelegate.myCache];
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];

}

-(void)RequestCommentByToken:(NSString*)access_token andChunkID:(NSString*)chunkID andTaskID:(NSString*)taskID
{
    NSString* urlstr = [[NSString stringWithFormat:@"%@/api/chunk/%@/comment",RootUrl,chunkID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"Get"];
    //[request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [request setDownloadCache:appDelegate.myCache];
   
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];
    
}

-(void)RequestHypothesisByToken:(NSString*)access_token andChunkID:(NSString*)chunkID andTaskID:(NSString*)taskID
{
    NSString* urlstr = [[NSString stringWithFormat:@"%@/api/chunk/%@/hypothesis",RootUrl,chunkID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"Get"];
    //[request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
   
    [request setDownloadCache:appDelegate.myCache];
   
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];

}

-(void)RequestChunkDetailByToken:(NSString*)access_token andChunkID:(NSString*)chunkID andTaskID:(NSString*)taskID
{
    NSString* urlstr = [[NSString stringWithFormat:@"%@/api/chunk/%@",RootUrl,chunkID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"Get"];
    //[request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [request setDownloadCache:appDelegate.myCache];
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;
    
    
    [request startAsynchronous];
    
}

-(void)RequestChunkByToken:(NSString*)access_token andTaskID:(NSString*)taskID
{
   
    
    NSDictionary* para = [[NSDictionary alloc] initWithObjectsAndKeys: @"question", @"type",  nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RootUrl,@"/api/chunk?type=question"]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value: [NSString stringWithFormat:@"Bearer  %@", access_token]];
    [request setRequestMethod:@"Get"];
    //[request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:taskID, @"taskID", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
   
    [request setDownloadCache:appDelegate.myCache];
   
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;

    
    [request startAsynchronous];


    
}


-(void)RequestLoginByUsername:(NSString*)username andPassword:(NSString*)password andTaskID:(NSString*)taskID
{

    
    NSDictionary* para = [[NSDictionary alloc] initWithObjectsAndKeys: username, @"username", password, @"password",  nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RootUrl,@"/api/auth"]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:taskID, @"taskID", password, @"password", username, @"username", nil];
    
    request.userInfo = dic;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [request setDownloadCache:appDelegate.myCache];
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.delegate = self;

    
    [request startAsynchronous];


}




- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString* temp = [request.userInfo valueForKey:@"taskID"];
    NSString* responseStr = request.responseString;
    NSLog(@"%@",temp);
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    NSLog(@"%@:%@", temp, request.responseString);
    //NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:[responseStr JSONValue]];
    //[dic setObject:request.userInfo forKey:@"userInfo"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: temp object:responseStr];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[request.userInfo valueForKey:@"taskID"] object:nil];
}



@end

//
//  AppDelegate.m
//
//  Copyright 2012 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "AppDelegate.h"

#import <GoogleSignIn/GoogleSignIn.h>

#import "SignInViewController.h"

@implementation AppDelegate

// DO NOT USE THIS CLIENT ID. IT WILL NOT WORK FOR YOUR APP.
// Please use the client ID created for you by Google.
static NSString * const kClientID =
    @"883533509466-eh9ofno4hlsiqeakht146s03ljfanhn2.apps.googleusercontent.com";
    //@"589453917038-qaoga89fitj2ukrsq27ko56fimmojac6.apps.googleusercontent.com";

#pragma mark Object life-cycle.

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Set app's client ID for |GIDSignIn|.
  [GIDSignIn sharedInstance].clientID = kClientID;

    _myCache = [[ASIDownloadCache alloc]init];
    //缓存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [_myCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
    [_myCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];

    
  return YES;
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    
    NSLog(@"Scheme: %@", [url scheme]);
    NSLog(@"Host: %@", [url host]);
    NSLog(@"Port: %@", [url port]);
    NSLog(@"Path: %@", [url path]);
    NSLog(@"Relative path: %@", [url relativePath]);
    NSLog(@"Path components as array: %@", [url pathComponents]);
    NSLog(@"Parameter string: %@", [url parameterString]);
    NSLog(@"Query: %@", [url query]);
    NSLog(@"Fragment: %@", [url fragment]);
    NSLog(@"User: %@", [url user]);
    NSLog(@"Password: %@", [url password]);
    
    NSString* ttt=url.absoluteString;
    NSLog(@"%@", url.absoluteString);
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"kSafariViewControllerCloseNotification" object:url];
    
  return [[GIDSignIn sharedInstance] handleURL:url
                             sourceApplication:sourceApplication
                                    annotation:annotation];
}

@end

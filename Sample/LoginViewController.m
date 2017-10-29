//
//  LoginViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/2.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "LoginViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "AllDataManager.h"

@interface LoginViewController () <GIDSignInDelegate, GIDSignInUIDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GIDSignInButton class];
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;

    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signIn:(id)sender {
    
    //[[NetLogicInterface sharedNetLogicInterface] RequestChunkByTaskID:@""];
    
    NSString* username = _textUsername.text;
    NSString* password = _textPassword.text;
    
    if (![username isEqualToString:@""] && ![password isEqualToString:@""]) {
        [[NetLogicInterface sharedNetLogicInterface] RequestLoginByUsername:username andPassword:password andTaskID:@"RequestLoginByUsername"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestLoginByUsername" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestLoginFinished:) name:@"RequestLoginByUsername" object:nil];
    }
}

-(void)requestLoginFinished:(NSNotification*) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestLoginByUsername" object:nil];
    
    if (!notification.object) {
        return;
    }
    
    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"access_token"] && [jsonObj objectForKey:@"access_token"]!=[NSNull null]) {
        [AllDataManager sharedAllDataManager].dicToken = jsonObj;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[AllDataManager sharedAllDataManager].dicToken forKey:@"dicToken"];
        
        [userDefaults synchronize];
        
        [[NetLogicInterface sharedNetLogicInterface] RequestCurUserInfoByToken:[jsonObj objectForKey:@"access_token"] andTaskID:@"RequestChunkByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestChunkByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestCurUserInfoFinished:) name:@"RequestChunkByToken" object:nil];
        
        
    }
    else
    {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"login failed!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];

    }
}

-(void)requestCurUserInfoFinished:(NSNotification*) notification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestLoginByUsername" object:nil];
    
    if (!notification.object) {
        return;
    }
    
    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"id"] && [jsonObj objectForKey:@"id"]!=[NSNull null]) {
        [AllDataManager sharedAllDataManager].userInfo = jsonObj;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[AllDataManager sharedAllDataManager].userInfo forKey:@"userInfo"];
        
        [userDefaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        NSLog(@"didSignInForUser failed!");
        return;
    }
    
    NSLog(@"didSignInForUser ok!");
    
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        NSLog(@"didDisconnectWithUser failed!");
    } else {
        NSLog(@"didDisconnectWithUser ok!");
    }
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    [[self navigationController] pushViewController:viewController animated:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_textPassword resignFirstResponder];
    [_textUsername resignFirstResponder];
}


@end

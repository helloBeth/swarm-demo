//
//  UserInfoViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/4.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AllDataManager.h"
#import "UIImageView+WebCache.h"
#import <SafariServices/SFSafariViewController.h>
#import "NetRequestConst.h"

@interface UserInfoViewController ()<SFSafariViewControllerDelegate>

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_reputationNum.text = [[AllDataManager sharedAllDataManager].userInfo objectForKey:<#(nonnull id)#>];
    
    
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginok:) name:@"kSafariViewControllerCloseNotification" object:nil];
    
    //UIImage* img = [UIImage imageNamed:@"g-element-applies-rotation.svg"];
//    NSString* headUrl = [[AllDataManager sharedAllDataManager].userInfo objectForKey:@"avatar"];
//    NSString* schame = [headUrl substringToIndex:4];
//    if (![schame isEqualToString:@"http"]) {
//        headUrl = [NSString stringWithFormat:@"https://swarm-dev2.eresearch.unimelb.edu.au%@", headUrl];
//    }
//    
//    _headImage.dataDetectorTypes = UIDataDetectorTypeAll;
//    //[_headImage setDelegate:self];
//    //[_questBody loadHTMLString:decodedString baseURL:nil];
//    //[_headImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://swarm-dev2.eresearch.unimelb.edu.au/static/avatars/dingo2.svg"]]];
//
//    [_headImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:headUrl]]];
//    _username.text = [[AllDataManager sharedAllDataManager].userInfo objectForKey:@"displayName"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    NSString* headUrl = [[AllDataManager sharedAllDataManager].userInfo objectForKey:@"avatar"];
    NSString* schame = [headUrl substringToIndex:4];
    if (![schame isEqualToString:@"http"]) {
        headUrl = [NSString stringWithFormat:@"%@%@",RootUrl, headUrl];
    }
    
    headUrl = [headUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _headImage.dataDetectorTypes = UIDataDetectorTypeAll;
    //[_headImage setDelegate:self];
    //[_questBody loadHTMLString:decodedString baseURL:nil];
    //[_headImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://swarm-dev2.eresearch.unimelb.edu.au/static/avatars/dingo2.svg"]]];
    
    NSString* part = [headUrl substringFromIndex:[headUrl length]-3];
    part = [part lowercaseString];
    if ([part isEqualToString:@"png"]) {
        [_headImage2 sd_setImageWithURL:[NSURL URLWithString:headUrl]];
        _headImage2.hidden = NO;
        _headImage.hidden = YES;
    }
    else {
        [_headImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:headUrl]]];
        _headImage2.hidden = YES;
        _headImage.hidden = NO;
    }
    
    _username.text = [[AllDataManager sharedAllDataManager].userInfo objectForKey:@"displayName"];

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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

- (IBAction)clickTestLogin:(id)sender {
    
    NSString* urlstr = @"https://accounts.google.com/o/oauth2/v2/auth?client_id=957274897444-e7e4ael19q277mubhk1b1gicdg7vav7o.apps.googleusercontent.com&scope=email&redirect_uri=http://swarm-dev2.eresearch.unimelb.edu.au/api/oauth2callback/google&state=mobile-nzb67rQ5Vu&response_type=code";
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    SFSafariViewController* vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://swarm-dev2.eresearch.unimelb.edu.au/api/login/google?type=mobile"]];//@"https://swarm-dev2.eresearch.unimelb.edu.au/api/login/google?type=mobile"
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
    
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    
}


-(void)loginok:(NSNotification*) notification
{
    
}

- (IBAction)clickLogout:(id)sender {
    
    [AllDataManager sharedAllDataManager].userInfo = nil;
    [AllDataManager sharedAllDataManager].dicToken = nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"dicToken"];
    [userDefaults setObject:nil forKey:@"userInfo"];
    [userDefaults synchronize];
    
    [self performSegueWithIdentifier:@"userToLogin" sender:self];
    
}

@end

//
//  AddQuestViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/6.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "AddQuestViewController.h"
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "AllDataManager.h"

@interface AddQuestViewController ()

@end

@implementation AddQuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
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

- (IBAction)submit:(id)sender {
    
    //[[NetLogicInterface sharedNetLogicInterface] RequestChunkByTaskID:@""];
    
    NSString* title = _questTitle.text;
    NSString* content = _questContent.text;
    
    if (![title isEqualToString:@""] && ![content isEqualToString:@""]) {
        [[NetLogicInterface sharedNetLogicInterface] RequestAddQuestByToken:[[AllDataManager sharedAllDataManager].dicToken objectForKey:@"access_token"] andTitle:title andContent:content andTaskID:@"RequestAddQuestByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestAddQuestByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestAddQuestFinished:) name:@"RequestAddQuestByToken" object:nil];
    }
}

-(void)requestAddQuestFinished:(NSNotification*) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestAddQuestByToken" object:nil];
    
    if (!notification.object) {
        return;
    }
    
    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"chunk"] && [jsonObj objectForKey:@"chunk"]!=[NSNull null]) {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"adding question ok!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
    }
    else
    {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"operation failed!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
        
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_questTitle resignFirstResponder];
    [_questContent resignFirstResponder];
}


@end

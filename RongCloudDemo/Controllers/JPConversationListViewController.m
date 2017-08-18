//
//  JPConversationViewController.m
//  
//
//  Created by wjp on 2017/8/16.
//
//

#import "JPConversationListViewController.h"

@interface JPConversationListViewController ()

@end

@implementation JPConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.tableFooterView = [UIView new];
    self.showConnectingStatusOnNavigatorBar = YES;
    self.isShowNetworkIndicatorView = YES;
    self.displayConversationTypeArray = @[@(ConversationType_PRIVATE)];


    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"com.wang.token"];
    if (token.length > 0 && [[RCIM sharedRCIM] getConnectionStatus] == ConnectionStatus_Unconnected) {
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            
        } error:^(RCConnectErrorCode status) {
            [self showLoginVC];
        } tokenIncorrect:^{
            [self showLoginVC];
        }];
    } else {
        [self showLoginVC];
        
    }
}

- (IBAction)logoutAction:(UIBarButtonItem *)sender {
    [[RCIM sharedRCIM] logout];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.wang.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showLoginVC];

}

- (IBAction)addAction:(UIBarButtonItem *)sender {
    NSString *targetId = @"zhang";
    if ([[[RCIM sharedRCIM] currentUserInfo].userId isEqualToString:targetId]) {
       
        targetId = @"li";
    }
    
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = targetId;
    conversationVC.title = targetId;
    [self.navigationController pushViewController:conversationVC animated:YES];

}


- (void)showLoginVC {
    [self performSegueWithIdentifier:@"LoginVC" sender:nil];

}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.targetId;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
@end

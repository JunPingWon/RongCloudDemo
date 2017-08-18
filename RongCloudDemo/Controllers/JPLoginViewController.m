//
//  ViewController.m
//  RongCloudDemo
//
//  Created by wjp on 2017/8/15.
//  Copyright © 2017年 wjp. All rights reserved.
//

#import "JPLoginViewController.h"
#import <RongIMKit/RongIMKit.h>
#define Zhang_Token @"4oPXObNNFqbL70FMujJ+h50VfPiZ+aobPXphfeJaXo384a1OL48yXXbfVYcExh8lrD3SH4RXnZdyYqvIb1LFuw=="

#define Li_Token    @"MMZ/b7OPGvreLSZ3j9CFy8dfVC6OXpaROBn/QP+lDCkNWtF/t9tHewyX96wpT/9d/WHZyRmm1fAWq0dTEykwNg=="


@interface JPLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *zhangsanBtn;
@property (weak, nonatomic) IBOutlet UIButton *lisiBtn;

@end

@implementation JPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _zhangsanBtn.backgroundColor = [UIColor cyanColor];
    _lisiBtn.backgroundColor = [UIColor orangeColor];
}

- (IBAction)selectZhang:(UIButton *)sender {
    [self connectWithToken:Zhang_Token sender:sender];
}

- (IBAction)selectLi:(UIButton *)sender {
    [self connectWithToken:Li_Token sender:sender];
}


- (void)connectWithToken:(NSString *)token sender:(UIButton *)sender {
    sender.enabled = NO;
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        sender.enabled = YES;
        [self loginSuccess:token];
        
    } error:^(RCConnectErrorCode status) {
        sender.enabled = YES;
        if (status == RC_CONNECTION_EXIST) {//连接已存在的情况，也当做成功处理
            [self loginSuccess:token];
        } else {
            NSLog(@"[Error] RCConnectErrorCode %ld", (long)status);
        }
        
    } tokenIncorrect:^{
        sender.enabled = YES;
        NSLog(@"[Error] tokenIncorrect");
    }];
}

- (void)loginSuccess:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"com.wang.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end

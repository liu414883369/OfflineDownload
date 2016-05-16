//
//  TwoViewController.m
//  离线断点续传
//
//  Created by liujianjian on 16/5/13.
//  Copyright © 2016年 rdg. All rights reserved.
//

#import "TwoViewController.h"
#import "JJDownloadManager.h"

@interface TwoViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lab;
@end

@implementation TwoViewController


- (void)dealloc {
//    [super dealloc];
    NSLog(@"界面3释放了");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;

    [JJDownloadManager sharedInstances].downloadTool.progressBlock = ^(CGFloat progress){
//        self.lab.text = [NSString stringWithFormat:@"%f", progress];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.lab.text = [NSString stringWithFormat:@"%f", progress];
        });
        
    };
    
    
}


@end

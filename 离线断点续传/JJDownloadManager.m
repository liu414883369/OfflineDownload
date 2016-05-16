//
//  JJDownloadManager.m
//  离线断点续传
//
//  Created by liujianjian on 16/5/11.
//  Copyright © 2016年 rdg. All rights reserved.
//


#import "JJDownloadManager.h"

static id _instace;

@interface JJDownloadManager()<NSURLSessionDataDelegate>

@end

@implementation JJDownloadManager

#pragma mark - 单例

// ARC下的单例模式
+ (instancetype)sharedInstances; {
    // dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}
+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}
+ (id)copyWithZone:(struct _NSZone *)zone {
    return _instace;
}

- (JJDownloadTool *)downloadTool {
    if (!_downloadTool) {
        _downloadTool = [[JJDownloadTool alloc] init];
    }
    return _downloadTool;
}


- (void)downloadUrl:(NSString *)url progress:(void(^)(CGFloat))pro complete:(void(^)(NSError *, NSString *))comp {
    
    [self.downloadTool downloadUrl:url progress:^(CGFloat progress) {
        pro(progress);
    } complete:^(NSError *error, NSString *fileDownloadPath) {
        comp(error, fileDownloadPath);
    }];
    
}











@end

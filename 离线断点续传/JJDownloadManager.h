//
//  JJDownloadManager.h
//  离线断点续传
//
//  Created by liujianjian on 16/5/11.
//  Copyright © 2016年 rdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJDownloadTool.h"

@interface JJDownloadManager : NSObject

@property (nonatomic, strong)JJDownloadTool *downloadTool;

/// 单例初始化
+ (instancetype)sharedInstances;
/**
 *  下载管理
 *
 *  @param url      下载地址
 *  @param progress 下载进度
 *  @param complete 完成回调
 */
- (void)downloadUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress complete:(void(^)(NSError *error, NSString *filePath))complete;

@end

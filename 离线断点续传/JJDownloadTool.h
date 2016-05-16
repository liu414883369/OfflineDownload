//
//  JJDownloadTool.h
//  离线断点续传
//
//  Created by liujianjian on 16/5/11.
//  Copyright © 2016年 rdg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(NSError *, NSString *);
typedef void(^ProgressBlock)(CGFloat);

static inline NSString *cachesPath() {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

@interface JJDownloadTool : NSObject

@property (nonatomic, copy) ProgressBlock progressBlock;
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, copy) NSString      *downloadUrl;

- (void)downloadUrl:(NSString *)url progress:(void(^)(CGFloat))progress complete:(void(^)(NSError *, NSString *))complete;


/**
 * 开始下载
 */
- (void)start;

/**
 * 暂停下载
 */
- (void)pause;

@end

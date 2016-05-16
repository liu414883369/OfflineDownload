//
//  JJDownloadTool.m
//  离线断点续传
//
//  Created by liujianjian on 16/5/11.
//  Copyright © 2016年 rdg. All rights reserved.
//



#import "JJDownloadTool.h"
#import "NSString+Hash.h"

@interface JJDownloadTool()<NSURLSessionDataDelegate>

/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *task;
/** session */
@property (nonatomic, strong) NSURLSession *session;
/** 写文件的流对象 */
@property (nonatomic, strong) NSOutputStream *stream;
/** 文件的总长度 */
@property (nonatomic, assign) long long totalLength;

@end

@implementation JJDownloadTool
/**
 *  文件存放路径
 */
- (NSString *)fileDownloadPath {
    return [cachesPath() stringByAppendingPathComponent:self.downloadUrl.md5String];
}
/**
 *  下载文件总长度存储路径
 */
- (NSString *)fileTotalLengthPath {
    return [cachesPath() stringByAppendingPathComponent:@"fileTotalLengthInfo"];
}
/**
 *  已经下载的文件长度
 */
- (long long)fileDownloadedLength {
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:self.fileDownloadPath error:nil][NSFileSize] longLongValue];
}

#pragma mark - 懒加载

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}
- (NSOutputStream *)stream {
    if (!_stream) {
        _stream = [NSOutputStream outputStreamToFileAtPath:self.fileDownloadPath append:YES];
    }
    return _stream;
}
- (NSURLSessionDataTask *)task
{
    if (!_task) {
        long long totalLength = [[NSDictionary dictionaryWithContentsOfFile:self.fileTotalLengthPath][self.downloadUrl.md5String] longLongValue];
        if (totalLength && self.fileDownloadedLength == totalLength) {
            NSLog(@"----文件已经下载过了");
            return nil;
        }
        // 创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]];
        
        // 设置请求头
        // Range : bytes=xxx-xxx
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.fileDownloadedLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        // 创建一个Data任务
        _task = [self.session dataTaskWithRequest:request];
    }
    return _task;
}

/**
 * 开始下载
 */
- (void)start {
    // 启动任务
    [self.task resume];
}

/**
 * 暂停下载
 */
- (void)pause {
    [self.task suspend];
}

#pragma mark - <NSURLSessionDataDelegate>
/**
 * 1.接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 打开流
    [self.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    self.totalLength = [response.allHeaderFields[@"Content-Length"] longLongValue] + self.fileDownloadedLength;
    
    // 存储总长度
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:self.fileTotalLengthPath];
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    dict[self.downloadUrl.md5String] = @(self.totalLength);
    [dict writeToFile:self.fileTotalLengthPath atomically:YES];
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 2.接收到服务器返回的数据（这个方法可能会被调用N次）
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 写入数据
    [self.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSLog(@"%f", 1.0 * self.fileDownloadedLength / self.totalLength);
    !_progressBlock ? : _progressBlock(1.0 * self.fileDownloadedLength / self.totalLength);
}

/**
 * 3.请求完毕（成功\失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    !_completeBlock ? : _completeBlock(error, self.fileDownloadPath);
    // 关闭流
    [self.stream close];
    self.stream = nil;
    
    // 清除任务
    self.task = nil;
}

- (void)downloadUrl:(NSString *)url progress:(void(^)(CGFloat))progress complete:(void(^)(NSError *, NSString *))complete {
    self.downloadUrl   = url;
    self.progressBlock = progress;
    self.completeBlock = complete;
    [self start];
}

@end

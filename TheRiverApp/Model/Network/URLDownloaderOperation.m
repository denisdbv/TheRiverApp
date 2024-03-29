//
//  URLDownloaderOperation.m
//  MoreShowApp
//
//  Created by DenisDbv on 12.06.13.
//  Copyright (c) 2013 DenisDbv. All rights reserved.
//

#import "URLDownloaderOperation.h"

@implementation URLDownloaderOperation
{
    SuccessBlockDownloader successBlockDownloader;
    FailedBlockDownloader failedBlockDownloader;
    NSString *_eTagValue;
}

@synthesize url = _url;

- (id)initWithUrlString:(NSString *)urlPath
       withSuccessBlock:(SuccessBlockDownloader) succesBlock
         andFailedBlock:(FailedBlockDownloader) failedBlock
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _eTagValue = @"";
    
    _url = [urlPath copy];
    successBlockDownloader = [succesBlock copy];
    failedBlockDownloader = [failedBlock copy];
    
    _isExecuting = NO;
    _isFinished = NO;
    
    return self;
}

- (id)initWithUrlString:(NSString *)urlPath
              eTag:(NSString*)eTagValue
       withSuccessBlock:(SuccessBlockDownloader) succesBlock
         andFailedBlock:(FailedBlockDownloader) failedBlock
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _eTagValue = [eTagValue copy];
    
    _url = [urlPath copy];
    successBlockDownloader = [succesBlock copy];
    failedBlockDownloader = [failedBlock copy];
    
    _isExecuting = NO;
    _isFinished = NO;
    
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    NSLog(@"<UpdateManager> Downloader opeartion for <%@> started.", _url);
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self receiveJSONFromUrl:_url param:nil eTag:_eTagValue];
}

- (void)finish
{
    NSLog(@"<UpdateManager> Downloader operation for <%@> finished. ", _url);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

-(void) receiveJSONFromUrl:(NSString*)urlString param:(NSDictionary*)parameters eTag:(NSString*)eTagValue
{
    NSMutableDictionary *requestHeaders = [[NSMutableDictionary alloc] init];
    [requestHeaders setObject:@"application/json" forKey:@"Content-Type"];
    
    if(eTagValue.length > 0)    {
        [requestHeaders setObject:eTagValue forKey:@"If-None-Match"];
        NSLog(@"!! %@", requestHeaders);
    }
    
    [[LRResty client] get:urlString parameters:parameters headers:requestHeaders withBlock:^(LRRestyResponse *response)  {
        if(response.status == 200)  {
            
            [self finish];
            
            NSDictionary *resultJSON = [[response asString] objectFromJSONString];
            if( ([[resultJSON objectForKey:@"status"] boolValue] == NO) &&
               ([[resultJSON objectForKey:@"code"] integerValue] == 1))    {
                NSLog(@"Oops!!! Server error: %@", resultJSON);
                [AppDelegateInstance() showServerErrorMessage];
            }
            
            successBlockDownloader(response);
        }
        else
        {
            //NSLog(@"%@", response.asString);
            [self finish];
            failedBlockDownloader(response);
        }
    }];
}

@end

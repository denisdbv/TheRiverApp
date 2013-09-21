//
//  TRAuthManager.m
//  TheRiverApp
//
//  Created by DenisDbv on 21.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRAuthManager.h"
#import "URLPostOperation.h"
#import "TGArhiveObject.h"

@implementation TRAuthManager

@synthesize iamData;

const NSString *_fileHandler = @"user.data";

+ (instancetype)client
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

-(id) init
{
    _queueAuth = [[NSOperationQueue alloc] init];
    [_queueAuth setMaxConcurrentOperationCount:1];
    
    return [super init];
}

-(void) authByLogin:(NSString*)login
        andPassword:(NSString*)password
withSuccessOperation:(SuccessOperation) succesOperaion
 andFailedOperation:(FailedOperation) failedOperation
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:login forKey:kTGUserLoginKey];
    [params setObject:password forKey:kTGUserPasswordKey];
    
    URLPostOperation * operation = [[URLPostOperation alloc] initWithUrlString: kTG_API_AuthUrl
                                                                      andParam: params
                                                                     andHeader: nil
                                                              withSuccessBlock:^(LRRestyResponse *response) {
        
                                                                  if( succesOperaion != nil)
                                                                      succesOperaion(response);
                                                                  
                                                                  NSDictionary *resultAuthJSON = [[response asString] objectFromJSONString];
                                                                  
                                                                  iamData = [[TRAuthUserModel alloc] initWithDictionary:resultAuthJSON];
                                                                  [self saveUserData: iamData];
        
    } andFailedBlock:^(LRRestyResponse *response){
        
        if(failedOperation != nil)
            failedOperation(response);
        
        NSLog(@"Error: %@", response.asString);
    }];
    
    [_queueAuth addOperation:operation];
}

-(void) saveUserData:(TRAuthUserModel*)userModel
{
    [[TGArhiveObject class] saveArhiveFromObject:userModel toFile: (NSString*)_fileHandler];
}

-(TRAuthManager*) iamData
{
    return [[TGArhiveObject class] unarhiveObjectFromFile: (NSString*)_fileHandler];
}

-(void) logout
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *userFilePath = [[[TGArhiveObject class] documentsDirectory] stringByAppendingPathComponent: (NSString*)_fileHandler];
    
    [fileManager removeItemAtPath:userFilePath error:nil];
}

@end

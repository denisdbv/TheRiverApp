//
//  TRUserManager.h
//  TheRiverApp
//
//  Created by DenisDbv on 07.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ABMultiton/ABMultitonProtocol.h>

@interface TRUserManager : NSObject <ABMultitonProtocol>

@property (nonatomic, retain) NSArray *usersObject;

@end
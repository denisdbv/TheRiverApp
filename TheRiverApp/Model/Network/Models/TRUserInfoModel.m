//
//  TRUserInfoModel.m
//  TheRiverApp
//
//  Created by DenisDbv on 22.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRUserInfoModel.h"

@implementation TRUserInfoModel
@synthesize id, first_name, last_name, sex, age, city, logo, logo_profile, logo_cell, profit, email, business, contact_data, url;
@synthesize interests;

+ (Class)interests_class {
    return [TRUserResolutionModel class];
}

@end

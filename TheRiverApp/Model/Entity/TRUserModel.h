//
//  TRUserModel.h
//  TheRiverApp
//
//  Created by DenisDbv on 07.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUserModel : NSObject

@property (nonatomic, retain) NSString *logo;

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;

@property (nonatomic, retain) NSString *yearsOld;
@property (nonatomic, retain) NSString *city;

@property (nonatomic, retain) NSArray *hightResolutions;
@property (nonatomic, retain) NSArray *currentBusiness;

@property (nonatomic, retain) NSString *businessLogo;
@property (nonatomic, retain) NSString *businessTitle;
@property (nonatomic, retain) NSString *businessBeforeTitle;
@property (nonatomic, retain) NSString *businessAfterTitle;

@property (nonatomic, retain) NSString *contactPhone;
@property (nonatomic, retain) NSString *contactEmail;
@property (nonatomic, retain) NSString *contactVK;
@property (nonatomic, retain) NSString *contactFB;
@property (nonatomic, retain) NSString *contactTwitter;


@end

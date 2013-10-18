//
//  TRContactsListModel.h
//  TheRiverApp
//
//  Created by DenisDbv on 02.10.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "Jastor.h"

@interface TRContactsListModel : Jastor

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, retain) NSArray *user;

@end

//
//  JGRTransaction.h
//  Transactions
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGRTransaction : NSObject

@property (strong, nonatomic) NSString * skuCode;
@property (strong, nonatomic) NSString * currency;
@property (strong, nonatomic) NSNumber * amount;


@end

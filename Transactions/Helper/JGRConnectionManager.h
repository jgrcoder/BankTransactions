//
//  JGRConnectionManager.h
//  Transactions
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGRConnectionManager : NSObject


-(id)initWithURL: (NSString *) url;
-(void) requestItems: (void(^)(NSArray *transactions)) completionBlock;


@end

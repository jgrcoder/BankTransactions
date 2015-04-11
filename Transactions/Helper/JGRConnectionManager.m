//
//  JGRConnectionManager.m
//  Transactions
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import "JGRConnectionManager.h"

@interface JGRConnectionManager ()
@property (nonatomic, strong) NSURL * jsonURL;

@end

@implementation JGRConnectionManager


-(id)initWithURL: (NSString *) url {
  if (self = [super init]) {
    _jsonURL = [NSURL URLWithString:url];
  }
  return self;
}

-(void) requestItems: (void(^)(NSArray *transactions)) completionBlock {
  
  dispatch_queue_t download_queue = dispatch_queue_create("download_queue", 0);
  dispatch_async(download_queue, ^{
    NSData * jsonData = [NSData dataWithContentsOfURL:_jsonURL];
    
    NSError * error = nil;
    NSArray * transactions = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (!error){
      
      completionBlock(transactions);
      
    } else {
      NSLog(@"Error: %@", error.userInfo);
    }
  });
}


@end

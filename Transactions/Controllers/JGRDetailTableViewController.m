//
//  JGRDetailTableViewController.m
//  Transactions
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import "JGRDetailTableViewController.h"
#import "JGRTransaction.h"
#import "JGRTransactionCell.h"


NSString * const kDetailCellIdentifier = @"transactionCell";
@interface JGRDetailTableViewController ()

@property (strong, nonatomic) NSArray * selectedTransactions;
@property (strong, nonatomic) NSArray * currencies;

@end

@implementation JGRDetailTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"JGRTransactionCell" bundle:nil] forCellReuseIdentifier:kDetailCellIdentifier];
}

-(id) initWithTransactions: (NSArray *) transactions{
  if (self = [super initWithNibName:nil bundle:nil]){
    _selectedTransactions = transactions;
    self.title = [[_selectedTransactions objectAtIndex:0] skuCode];
    _currencies = [_selectedTransactions valueForKeyPath:@"@distinctUnionOfObjects.currency"];
  }
  return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_currencies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailCellIdentifier forIndexPath:indexPath];
  
  NSMutableArray * elementsWithCurrentCurrency = [[NSMutableArray alloc] init];
  
  for (JGRTransaction * transaction in _selectedTransactions) {
    if ([transaction.currency isEqualToString:_currencies[indexPath.row]]){
      [elementsWithCurrentCurrency addObject:transaction];
    }
  }
  
  cell.textLabel.text = _currencies[indexPath.row];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [elementsWithCurrentCurrency valueForKeyPath:@"@sum.amount"]];
  
  return cell;
}

@end

//
//  JGRTransactionTableViewController.m
//  Transactions
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import "JGRTransactionTableViewController.h"
#import "JGRTransaction.h"
#import "JGRConnectionManager.h"
#import "JGRDetailTableViewController.h"


NSString * const kTransactionsURL = @"https://dl.dropboxusercontent.com/u/11350806/remoteTransactions.json";
NSString * const cellIndentifier = @"transactionCell";
@interface JGRTransactionTableViewController()

@property (strong, nonatomic) NSArray * jgrTransactions;

@end

@implementation JGRTransactionTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"JGRTransactionCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(performRequest)];
  [self performRequest];
  
}

-(void) performRequest {
  JGRConnectionManager *connectorManager = [[JGRConnectionManager alloc] initWithURL:kTransactionsURL];
  [connectorManager requestItems:^(NSArray *transactions) {
    dispatch_async(dispatch_get_main_queue(), ^{
      
      self.jgrTransactions = [self convertTransactionsFromArray: transactions];
      
      [self.tableView reloadData];
    });
  }];
}

-(NSArray *) convertTransactionsFromArray: (NSArray *) dictsOfTransactions {
  NSMutableArray * transactions = [[NSMutableArray alloc] init];
  
  for (NSDictionary *dictTransaction in dictsOfTransactions) {
    JGRTransaction * transaction = [[JGRTransaction alloc] init];
    
    transaction.skuCode = [dictTransaction objectForKey:@"sku"];
    transaction.amount = [dictTransaction objectForKey:@"amount"];
    transaction.currency = [dictTransaction objectForKey:@"currency"];
    
    [transactions addObject:transaction];
  }
  
  return [[NSArray alloc] initWithArray:transactions];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  // Return the number of rows in the section.
  return [_jgrTransactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
  JGRTransaction * transaction = _jgrTransactions[indexPath.row];
  
  NSString * transactionDetail = [NSString stringWithFormat:@"%@ - %@ [%@]",
                                  transaction.skuCode, transaction.amount, transaction.currency];
  
  cell.textLabel.text = [NSString stringWithFormat:@"Item %ld", (indexPath.row + 1)];
  cell.detailTextLabel.text = transactionDetail;
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSMutableArray * selectedTransactions = [[NSMutableArray alloc ]init];
  for (JGRTransaction * transaction in _jgrTransactions) {
    
    if ([[_jgrTransactions[indexPath.row] skuCode] isEqualToString: transaction.skuCode]){
      [selectedTransactions addObject:transaction];
    }
  }
  
  NSArray * transactionsArray = [NSArray arrayWithArray:selectedTransactions];
  JGRDetailTableViewController * detailTVController = [[JGRDetailTableViewController alloc] initWithTransactions:transactionsArray];
  
  [self.navigationController pushViewController:detailTVController animated:YES];
}

@end

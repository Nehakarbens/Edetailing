//
//  MasterViewController.m
//  MarkRep
//
//  Created by virupaksh on 12/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation MasterViewController
@synthesize aDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *aDataSource = [[NSMutableArray alloc] initWithObjects:@"Row 1",@"Row 2",@"Row 3",@"Row 4",@"Row 5",@"Row 6",@"Row 7",@"Row 8",@"Row 9",@"Row 10", nil];
    self.dataSource = aDataSource;
    [aDataSource release];
    aDataSource = nil;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_masterTableView release];
    [super dealloc];
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.aDelegate respondsToSelector:@selector(didMasterOptionSelected:)]) {
        [self.aDelegate didMasterOptionSelected:indexPath.row];
    }
}

@end

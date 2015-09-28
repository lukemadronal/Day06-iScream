//
//  ViewController.m
//  iScream
//
//  Created by Thomas Crawford on 6/7/15.
//  Copyright (c) 2015 VizNetwork. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Flavors.h"
#import "InventoryItems.h"
#import "DetailedViewController.h";

@interface ViewController ()

@property (nonatomic, strong) AppDelegate            *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray                *flavorsArray;
@property (nonatomic,weak) IBOutlet UILabel *nameDisplayLabel;
@property (nonatomic,weak) IBOutlet UITableView *flavorsTableView;

@end

@implementation ViewController

#pragma mark - Core Methods

- (NSArray *)fetchFlavors {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Flavors" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"flavorName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchResults = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fetched %lu Flavors",(unsigned long)[fetchResults count]);

    return [NSMutableArray arrayWithArray:fetchResults];
}

- (float)totalInventoryForFlavor:(Flavors *)flavor {
    float totalInGallons = 0.0;
    NSArray *flavorInventoryArray = [[flavor relationshipFlavorInventoryItems] allObjects];
    for (InventoryItems *inventoryItem in flavorInventoryArray) {
        totalInGallons = totalInGallons + [[inventoryItem sizeInGallons] floatValue];
    }
    return totalInGallons;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _flavorsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Flavors *currentFlavor = _flavorsArray[indexPath.row];
    cell.textLabel.text = [currentFlavor flavorName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Gallons: %0.1f", [self totalInventoryForFlavor:currentFlavor]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",currentFlavor.flavorImage]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailedViewController *destController = [segue destinationViewController];
    NSIndexPath *indexPath = [_flavorsTableView indexPathForSelectedRow];
    Flavors *currentPerson=_flavorsArray[indexPath.row];
    destController.currentFlavor = currentPerson;
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = _appDelegate.managedObjectContext;
    _flavorsArray = [self fetchFlavors];
    for (Flavors *flavor in _flavorsArray) {
        NSLog(@"Flavor: %@ Gallons: %.2f",[flavor flavorName],[self totalInventoryForFlavor:flavor]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  ViewController.m
//  Example 004
//
//  Created by Aaron Brethorst on 1/13/18.
//  Copyright © 2018 Quickbytes.io. All rights reserved.
//

#import "ViewController.h"
@import Firebase;
@import SafariServices;

static NSString * const kTableViewCellReuseIdentifier = @"identifier";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray<NSDictionary*> *tableData;
@property(nonatomic,strong) FIRDatabaseReference *dbReference;

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.title = NSLocalizedString(@"Firebase Table Example",);
        _tableData = @[];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dbReference = [[FIRDatabase database] reference];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    [self loadData];
}

#pragma mark - Firebase

- (void)loadData {
    FIRDatabaseQuery *query = [[self.dbReference child:@"users"] queryOrderedByChild:@"username"];

    [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        // For the database structure that I have defined (see the data.json file in this project),
        // I will expect to see an array of dictionaries in snapshot.value.
        self.tableData = snapshot.value;
        self.title = [NSString stringWithFormat:NSLocalizedString(@"%@ Users",), @(self.tableData.count)];
        [self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error",) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss",) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // For the database structure that I have defined (see the data.json file in this project),
    // I will expect that the user dictionary below has three keys: name, username, and website.

    NSDictionary *user = self.tableData[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", user[@"name"], user[@"username"]];
    cell.detailTextLabel.text = user[@"website"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *user = self.tableData[indexPath.row];
    NSURL *URL = [NSURL URLWithString:user[@"website"]];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:URL];
    [self presentViewController:safariController animated:YES completion:nil];
}

@end

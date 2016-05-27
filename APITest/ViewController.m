//
//  ViewController.m
//  APITest
//
//  Created by MacUser on 14.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"

#import "VKUser.h"


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *friendsArray;

@property (assign, nonatomic) BOOL firstTimeAppear;

@end

@implementation ViewController

static NSInteger friendsInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.friendsArray = [NSMutableArray array];
    
    self.firstTimeAppear = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        [[ServerManager sharedManager] authorizeUser:^(VKUser *user) {
        
            NSLog(@"AUTHORIZED!");
            
        }];

    }
    
}

#pragma mark - API

- (void) getFriendsFromServer {
    
    [[ServerManager sharedManager] getFriendsWhithOffset:[self.friendsArray count] count:friendsInRequest
                                                onSuccess:^(NSArray *friends) {
                                                   
    [self.friendsArray  addObjectsFromArray:friends];
    
    NSMutableArray* newPath = [NSMutableArray array];
    
    for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++) {
        [newPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
     
}
    onFail:^(NSError *error, NSInteger statusCode) {
    NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
    }];
    
}

#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.friendsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row  == [self.friendsArray count]) {
        cell.textLabel.text = @"LOAD MORE";
        cell.imageView.image = nil;
    } else {
        
        VKUser* friend = [self.friendsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:friend.imageURL];
        
        
        __weak UITableViewCell *weakCell = cell;
        
        cell.imageView.image = nil;
        
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           weakCell.imageView.image = image;
                                           [weakCell layoutSubviews];
                                       }
                                       failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                       }];

            }
    
        return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row  == [self.friendsArray count]) {
        [self getFriendsFromServer];
    }
    
}

@end

//
//  GroupWallViewController.m
//  APITest
//
//  Created by MacUser on 19.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import "GroupWallViewController.h"
#import "ServerManager.h"

#import "VKUser.h"
#import "PostWall.h"
#import "PostCell.h"

@interface GroupWallViewController ()

@property (strong, nonatomic) NSMutableArray *postsArray;

@property (assign, nonatomic) BOOL firstTimeAppear;

@end

@implementation GroupWallViewController

static NSInteger postsInRequest = 20;

- (id) initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postsArray = [NSMutableArray array];
    self.firstTimeAppear = YES;
    
    
    UIRefreshControl* refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshWall) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    UIBarButtonItem* plus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(postOnWall:)];
    
    self.navigationItem.rightBarButtonItem = plus;
    
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

- (void) postOnWall: (id) sender {
    
    [[ServerManager sharedManager] postText:@"тест post wall 3 :)  " onGroupWall:@"24723019" nSuccess:^(id result) {
        
    } onFail:^(NSError *error, NSInteger statusCode) {
        
    }];
}


- (void) refreshWall {
    
    [[ServerManager sharedManager] getGroupWall:@"24723019"
                                    whithOffset:0
                                          count:MAX(postsInRequest, [self.postsArray count])
                                      onSuccess:^(NSArray *posts) {
                                          
                                          [self.postsArray  removeAllObjects];
                                          
                                          [self.postsArray  addObjectsFromArray: posts];
                                          
                                          [self.tableView reloadData];
                                          
                                          [self.refreshControl endRefreshing];
                                                                                }
                                        onFail:^(NSError *error, NSInteger statusCode) {
                                             
                                             NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
                                            
                                            [self.refreshControl endRefreshing];

                                         }];

}


- (void) getPostsFromServer {
    
    [[ServerManager sharedManager] getGroupWall:@"24723019"
                                    whithOffset:[self.postsArray count]
                                          count:postsInRequest
                                      onSuccess:^(NSArray *posts) {
                                          
                                          [self.postsArray  addObjectsFromArray: posts];
                                          //[self.tableView reloadData];
                                          
                                          NSMutableArray* newPath = [NSMutableArray array];
                                          
                                          for (int i = (int)[self.postsArray count] - (int)[posts count]; i < [self.postsArray count]; i++) {
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
    
    return [self.postsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row  == [self.postsArray count]) {
        
        static NSString* identifier = @"Cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = @"LOAD MORE";
        cell.imageView.image = nil;
        
        return cell;
        
    } else {
        
        static NSString* identifier = @"PostCell";
        
        PostCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];

        PostWall* post = [self.postsArray objectAtIndex:indexPath.row];
        
        cell.postTextLable.text = post.text;
        
        return cell;
    }
    
    return nil;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row  == [self.postsArray count]) {
        
        return 44.f;
        
    } else {
        
        PostWall* post = [self.postsArray objectAtIndex:indexPath.row];
        
        return [PostCell heightForText:post.text];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row  == [self.postsArray count]) {
        [self getPostsFromServer];
    }
    
}


@end

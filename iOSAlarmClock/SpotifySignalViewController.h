//
//  spotifySignalViewControllerTableViewController.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-09.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIHandler.h"
#import "SPTSessionHandler.h"


@interface SpotifySignalViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, APIRequestProtocol>

@property (readonly, nonatomic) SPTSessionHandler *spotifyRequest;
@property (weak, nonatomic) NSString *chosenSignal;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *songLoadButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;


@end

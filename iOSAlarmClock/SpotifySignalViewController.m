//
//  spotifySignalViewControllerTableViewController.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-09.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "SpotifySignalViewController.h"
#import "SPTSessionHandler.h"
#import "SpotifyObject.h"

@interface SpotifySignalViewController ()
@property (readwrite, nonatomic) SPTSessionHandler *spotifyRequest;
@end


@implementation SpotifySignalViewController

NSMutableArray *tableList;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    tableList = [[NSMutableArray alloc] init];
    self.songLoadButton = [[UIBarButtonItem alloc] initWithTitle:@"Load songs" style:UIBarButtonItemStylePlain target:self action:@selector(loadButtonPressed:)];
    self.loadButton.tag = 1;
    self.songLoadButton.tag = 2;
    
    self.navigationBar.rightBarButtonItems = @[self.songLoadButton, self.loadButton];
    self.spotifyRequest = [[SPTSessionHandler alloc] init];
    self.spotifyRequest.apiInSession = [[APIHandler alloc] init];
    self.spotifyRequest.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return tableList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"spotCell" forIndexPath:indexPath];
    
    cell.textLabel.text = tableList[indexPath.item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.spotifyRequest listChosen: (NSInteger)indexPath.row];
    
    self.chosenSignal = tableList[(int)indexPath.row];
    
    //Fördröjer segue för att spotifys asyncroniserade block ska hinna utföras.
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"unwindToAlarm" sender:self];
    });
    

    
}

- (IBAction)loadButtonPressed:(id)sender {
    UIBarButtonItem *which = (UIBarButtonItem *)sender;
    NSLog(@"%ld", (long)which.tag);
    [self.spotifyRequest sendRequest:which.tag];


}

-(void)returnRequest:(NSArray *)list {
    [tableList removeAllObjects];
    for (id pp in list) {
        if ([pp isMemberOfClass:[SPTPartialPlaylist class]]) {
            SPTPartialPlaylist *temp = (SPTPartialPlaylist *)pp;
            [tableList addObject:temp.name];
        } else {
            SPTPartialTrack *trackTemp = (SPTPartialTrack *)pp;
            SPTPartialArtist *artistTemp = trackTemp.artists[0];
        
            
            NSString *trackString = [trackTemp.name stringByAppendingFormat:@" - %@", artistTemp.name];
            [tableList addObject:trackString];


        }
        
        
            }
    [self.tableView reloadData];

}

@end

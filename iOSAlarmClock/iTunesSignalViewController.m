//
//  iTunesSignalViewController.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-23.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "iTunesSignalViewController.h"


@interface iTunesSignalViewController ()

@end

@implementation iTunesSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc]
     initWithMediaTypes: MPMediaTypeAnyAudio];                   // 1
    
    [picker setDelegate: self];                                         // 2
    [picker setAllowsPickingMultipleItems: YES];                        // 3
    picker.prompt =
    NSLocalizedString (@"Add songs to play",
                       "Prompt in media item picker");
    
    [self presentModalViewController: picker animated: YES];    // 4
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

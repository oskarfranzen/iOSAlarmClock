//
//  APIhandler.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-11.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <Foundation/Foundation.h>
@class APIHandler;

@protocol APIRequestProtocol <NSObject>

    @optional -(void)returnRequest:(NSArray *)list;
    @optional -(void)sortRequestReturned:(id)ret;
@end

@interface APIHandler : NSObject

@property (readonly, strong, nonatomic) NSArray *tempArray;
@property (weak, nonatomic) id<APIRequestProtocol> delegate;

-(void)playlistRequest;
-(void)songRequest;
-(void)echoNestRequest:(NSArray *)listToSort;

@end

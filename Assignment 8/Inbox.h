//
//  Inbox.h
//  Assignment 8
//
//  Created by Tom Hart on 3/11/15.
//  Copyright (c) 2015 Tom Hart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Inbox : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * imageLink;
@property (nonatomic, retain) NSString * permalink;
@property (nonatomic, retain) NSString * subreddit;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

@end

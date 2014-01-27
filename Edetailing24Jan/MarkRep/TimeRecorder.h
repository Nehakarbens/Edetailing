//
//  TimeRecorder.h
//  MyDay
//
//  Created by Akshay Kunila on 24/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol TimeRecorderDelegate;

@interface TimeRecorder : NSOperation

@property (nonatomic, assign) int contentTag;
@property (nonatomic, retain) NSTimer *timer;
@property(nonatomic, retain) NSDate *startTime;
@property (nonatomic, readonly) BOOL isExecuting;
@property (nonatomic, readonly) BOOL isFinished;

//- (void)startRecording:(int)childId doctorId:(int) docId;

- (NSTimeInterval)stopRecording;

@end

//@protocol TimeRecorderDelegate

//- (void)appImageDidLoad;

//@end
//
//  QueuePool.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueuePool : NSObject

@property NSOperationQueue *queue;

+ (QueuePool *)sharedQueuePool;

@end

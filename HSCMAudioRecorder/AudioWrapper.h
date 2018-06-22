//
//  AudioWrapper.h
//  HSCMAudioRecorder
//
//  Created by CM on 2018/6/22.
//  Copyright © 2018年 CM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioWrapper : NSObject

+ (void)audioPCMtoMP3 :(NSURL *)audioFileSavePath :(NSURL *)mp3FilePath;

@end

//
//  AudioWrapper.m
//  HSCMAudioRecorder
//
//  Created by CM on 2018/6/22.
//  Copyright © 2018年 CM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioWrapper.h"
#import "lame/lame.h"

@implementation AudioWrapper

+ (void)audioPCMtoMP3 :(NSURL *)audioFileSavePath :(NSURL *)mp3FilePath
{
    
    @try {
        int read, write;
        
        
        FILE *pcm = fopen([audioFileSavePath.absoluteString cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath.absoluteString cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
            } while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3 converted: %@",mp3FilePath);
    }
    
}
@end

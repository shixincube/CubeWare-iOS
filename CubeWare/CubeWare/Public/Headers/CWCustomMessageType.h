//
//  CWCustomMessageType.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#ifndef CWCustomMessageType_h
#define CWCustomMessageType_h

typedef NS_ENUM(NSInteger,CWCustomMessageType){
    CWCustomMessageTypeUnknown = 0,
    CWCustomMessageTypeTip = 1,
    CWNCustomMessageTypeNotity, //服务器通知
    CWNCustomMessageTypeChat,   //消息
};

#endif /* CWCustomMessageType_h */

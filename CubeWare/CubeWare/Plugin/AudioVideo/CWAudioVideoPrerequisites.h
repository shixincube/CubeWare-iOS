//
//  CWAudioVideoPrerequisites.h
//  CubeWare
//
//  Created by 美少女 on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#ifndef CWAudioVideoPrerequisites_h
#define CWAudioVideoPrerequisites_h

typedef enum _AudioType
{
    SingleAudioType  = 0,//单人音频通话
    GroupAudioType,      //多人音频通话
    ApplyAudioType, //申请加入多人音频通话
}AudioType;

typedef enum _AudioCallDirection
{
    AudioCallOut = 0,//呼出
    AudioCallIn,//出入
}AudioCallDirection;

typedef enum _AVShowViewStyle
{
    CallInStyle = 0,//呼入
    CallOutStyle,//呼出
    ConnectingStyle,//接听中
}AVShowViewStyle;

#endif /* CWAudioVideoPrerequisites_h */

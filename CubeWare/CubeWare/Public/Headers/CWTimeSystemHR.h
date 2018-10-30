//
//  CWTimeSystemHR.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/5.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#ifndef CWTimeSystemHR_h
#define CWTimeSystemHR_h

/**
 系统的时制
 
 - CWTimeSystemUnKnown: 未知
 - CWTimeSystem24HR: 24小时制
 - CWTimeSystem12HR: 12小时制
 */
typedef NS_ENUM (int ,CWTimeSystemHR) {
    CWTimeSystemUnKnown,
    CWTimeSystem24HR,
    CWTimeSystem12HR
};

#endif /* CWTimeSystemHR_h */

//
//  CWNetworkUpdateType.h
//  CubeWare
//
//  Created by Mario on 2017/8/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#ifndef CWNetworkUpdateType_h
#define CWNetworkUpdateType_h

/**
 *  消息布局类型
 */
typedef NS_ENUM(NSInteger, CWNetworkUpdateType){
    /**
     *  通话质量良好
     */
    CWNetworkUpdateTypeGood = 0,
    /**
     *  通话质量一般
     */
    CWNetworkUpdateTypeNoraml = 1,
    /**
     *  通话质量较差
     */
    CWNetworkUpdateTypePoor = 2,
    /**
     *  通话质量未知
     */
    CWNetworkUpdateTypeUnkown = 3
};

#endif /* CWNetworkUpdateType_h */

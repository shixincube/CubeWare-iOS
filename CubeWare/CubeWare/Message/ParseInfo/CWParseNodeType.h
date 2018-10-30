//
//  Header.h
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/9.
//  Copyright © 2018年 陆川. All rights reserved.
//

#ifndef Header_h
#define Header_h

typedef NS_ENUM(int, CWParseNodeType) {
	CWParseNodeTypeText,	//普通文本
	CWParseNodeTypeEmoji,  //表情
	CWParseNodeTypeAt,    	//@
	CWParseNodeTypeAtAll, 	//@all
	CWParseNodeTypeLink,   //链接
	CWParseNodeTypeImage,  //图片
};

#endif /* Header_h */

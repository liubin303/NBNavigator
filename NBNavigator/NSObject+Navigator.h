//
//  NSObject+Navigator.h
//  Pods
//
//  Created by 刘彬 on 2017/7/13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Navigator)

/*!
 @method
 @abstract      执行selector方法
 @param         aSelector: 要执行的方法
 @param         objects: 参数
 @return        id
 */
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

@end

//
//  Teacher+CoreDataProperties.h
//  LVCoreDataDemo
//
//  Created by meipai_lv on 2018/4/8.
//  Copyright © 2018年 Meipai_Lv. All rights reserved.
//
//

#import "Teacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *sex;

@end

NS_ASSUME_NONNULL_END

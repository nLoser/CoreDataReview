//
//  President+CoreDataProperties.h
//  LVCoreDataDemo
//
//  Created by meipai_lv on 2018/4/8.
//  Copyright © 2018年 Meipai_Lv. All rights reserved.
//
//

#import "President+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface President (CoreDataProperties)

+ (NSFetchRequest<President *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t age;
@property (nonatomic) int16_t height;

@end

NS_ASSUME_NONNULL_END

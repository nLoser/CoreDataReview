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

@property (nonatomic) int16_t age;
@property (nonatomic) int16_t height;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t weight;

@end

NS_ASSUME_NONNULL_END

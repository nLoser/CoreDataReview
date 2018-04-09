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
@property (nullable, nonatomic, retain) NSSet<Student *> *student;

@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addStudentObject:(Student *)value;
- (void)removeStudentObject:(Student *)value;
- (void)addStudent:(NSSet<Student *> *)values;
- (void)removeStudent:(NSSet<Student *> *)values;

@end

NS_ASSUME_NONNULL_END

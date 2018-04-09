//
//  Student+CoreDataProperties.m
//  LVCoreDataDemo
//
//  Created by meipai_lv on 2018/4/9.
//  Copyright © 2018年 Meipai_Lv. All rights reserved.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic age;
@dynamic height;
@dynamic name;
@dynamic number;
@dynamic sex;
@dynamic weight;
@dynamic teacher;

@end

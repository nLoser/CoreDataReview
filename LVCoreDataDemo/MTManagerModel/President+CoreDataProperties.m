//
//  President+CoreDataProperties.m
//  LVCoreDataDemo
//
//  Created by meipai_lv on 2018/4/9.
//  Copyright © 2018年 Meipai_Lv. All rights reserved.
//
//

#import "President+CoreDataProperties.h"

@implementation President (CoreDataProperties)

+ (NSFetchRequest<President *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"President"];
}

@dynamic age;
@dynamic height;
@dynamic name;
@dynamic weight;

@end

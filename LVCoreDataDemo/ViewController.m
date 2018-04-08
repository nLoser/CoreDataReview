//
//  ViewController.m
//  LVCoreDataDemo
//
//  Created by meipai_lv on 2018/4/8.
//  Copyright © 2018年 Meipai_Lv. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>

#import "Student+CoreDataProperties.h"

@interface ViewController ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSqlite];
    for (int i = 0; i < 10; i ++) {
        [self insertToStudentTable:@(i)];
    }
    [self deleteData];
    [self updateData];
    [self queryData];
    [self sortData];
}

#pragma mark - Private

//排序
- (void)sortData {
    //创建排序请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    //实例化排序对象
    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    NSSortDescriptor *numberSort = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    request.sortDescriptors = @[ageSort, numberSort];
    
    NSError * error = nil;
    NSArray *sortArray = [_context executeFetchRequest:request error:&error];
    if (error == nil) {
        for (Student *stu in sortArray) {
            NSLog(@"age:%d - number:%d - %@",stu.age, stu.number, stu.name);
        }
    }else {
        NSLog(@"Sort Student data failed! %@",error);
    }
}

//查询
- (void)queryData {
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"sex = 'GG'"];
    request.predicate = pre;
    
    //从第几页开始显示
    //通过这个属性实现分页
    request.fetchOffset = 0;
    request.fetchLimit = 6;
    
    NSArray *queryArray = [_context executeFetchRequest:request error:nil];
    
    for (Student *stu in queryArray) {
        NSLog(@"%@",stu.name);
    }
}

//更新修改
- (void)updateData {
    //创建更新请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"sex = 'GG'"];

    request.predicate = pre;
    
    //返回更新的数据库数组
    NSArray * updateArray = [_context executeFetchRequest:request error:nil];
    for (Student *stu in updateArray) {
        stu.name = @"Stay hurgy stay foolish";
    }
    NSError *error = nil;
    if ([_context save:&error]) {
        NSLog(@"Update Student data success.");
    }else {
        NSLog(@"Update Student data failed! %@",error);
    }
}

//删除数据
- (void)deleteData {
    //创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < %d",10];
    deleRequest.predicate = pre;
    
    //返回需要删除的数据库数组
    NSArray *deleArray = [_context executeFetchRequest:deleRequest error:nil];
    
    for (Student *stu in deleArray) {
        [_context deleteObject:stu];
    }
    
    NSError *error = nil;
    if ([_context save:&error]) {
        NSLog(@"Delete Student data success.");
    }else {
        NSLog(@"Delete Student data failed! %@",error);
    }
}

//写入数据
- (void)insertToStudentTable:(id)data {
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_context];
    student.name = [NSString stringWithFormat:@"Mr-%d",arc4random()%100];
    student.age = arc4random()%20;
    student.sex = arc4random()%2 == 0 ? @"MM":@"GG";
    student.height = arc4random()%180;
    student.number = arc4random()%100;
    
    NSError *error = nil;
    if ([_context save:&error]) {
        NSLog(@"Insert new Student data success.");
    }else {
        NSLog(@"Insert new Student datas failed! %@",error);
    }
}



//1.需要手动生成上下文、关联数据库
- (void)createSqlite {
//    NSManagedObjectContext *context; ///< 管理对象、上下文、持久化存储模型对象、处理数据和应用的交互
//    NSManagedObjectModel *model; ///< 被管理的数据模型、数据结构
//    NSPersistentStoreCoordinator *coordinator; ///< 添加数据库，设置数据的名字、位置、存储方式
//    NSFetchRequest *request; ///< 数据请求
//    NSEntityDescription *description; ///< 表格实体结构
    
    //1.创建模型对象
    //获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //2.创建持久化存储协调器:数据库
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //数据库名称、位置
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlpath = [docStr stringByAppendingPathComponent:@"coreData.sqlite"];
    NSURL *sqlURL = [NSURL fileURLWithPath:sqlpath];
    //添加数据库
    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlURL options:nil error:&error];
    
    if (error) {
        NSLog(@"Add Database failed! %@",error);
    }else {
        NSLog(@"Add Database success.");
    }
    
    //3.管理对象、上下文、持久化存储模型对象、处理数据和应用的交互
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //关联持久化协调器
    context.persistentStoreCoordinator = coordinator;
    _context = context;
}

//2.自己创建模型文件时候需要

@end

















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
    //NOTE:Version 1.0版本数据库初始化
    //[self createSqlite];
    
    //NOTE:Version 2.0版本数据库升级
    [self upgradeDatabase];
    
    for (int i = 0; i < 10; i ++) {
        [self insertToStudentTable:@(i)];
    }
    [self deleteData];
    [self updateData];
    [self queryData];
    [self sortData];
    [self fetchRequest];
}

#pragma mark - Private - Fetch Requests

- (void)fetchRequest {
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"]];
    NSFetchRequest *studentFR = [model fetchRequestTemplateForName:@"StudentFR"];
    NSArray *rtArray = [_context executeFetchRequest:studentFR error:nil];
    NSLog(@"result:\n%@",rtArray);
}

#pragma mark - Private - Database upgrade and data migration light weight
//使用于数据库增加新表、新增实体属性，等简单的，系统能推断出来的迁移方式
//1.首先给予原有的model。xcdataModel取名一个新的版本xcdataModel
//2.xcode中点击Model.xcdatamodel选中，在右侧的Model Version选中Current模板为Model2
//3.操作：新增表、新增实体属性（并且一定要删除原来旧的类文件，然后重新生成新的实体类文件）
//4.设置数据库参数options，打开数据库升级迁移开关

- (void)upgradeDatabase {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //请求自动化轻量数据库升级，数据迁移
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption:@(YES)};
    
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"coreData.sqlite"];
    NSURL *sqlURL = [NSURL fileURLWithPath:sqlPath];
    
    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlURL options:options error:&error];
    
    if (error) {
        NSLog(@"Database upgrade and data migration failed! %@",error);
    }else {
        NSLog(@"Database upgrade and data migration success.");
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = coordinator;
    _context = context;
}

#pragma mark - Private - Base CoreData Operation

//1.需要手动生成上下文、关联数据库
- (void)createSqlite {
    //    NSManagedObjectContext *context; ///< 托管对象上下文，进行数据操作
    //    NSManagedObjectModel *model; ///< 被管理的数据模型，关联一个(.xcdatamodeld)，存储着数据结构
    //    NSPersistentStoreCoordinator *coordinator; ///< 添加数据库，设置数据的名字、位置、存储方式
    //    NSFetchRequest *request; ///< 数据请求
    //    NSManagedObject * object; ///< 托管对象类，所有CoreData中的托管对象都必须是这个子类
    //    NSEntityDescription *description; ///< 表格实体结构
    
    //1.创建模型对象
    //根据模型文件创建模型对象
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //2.持久化存储协调器，负责协调存储区和上下文之间的关系
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

@end

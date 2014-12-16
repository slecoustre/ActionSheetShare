//
//  ViewController.m
//  Sample
//
//  Created by Stephane on 16/12/2014.
//  Copyright (c) 2014 slecoustre. All rights reserved.
//

#import "ViewController.h"
#import "ActionSheetShareView.h"

@interface ViewController ()<ActionSheetShareViewDataSource,ActionSheetShareViewDelegate>

@property (strong, nonatomic) ActionSheetShareView *actions;
@property (strong, nonatomic) NSArray* dataString;
@property (strong, nonatomic) NSArray* dataImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataString = @[
                        @[@"Remove All"],
                        @[@"Mail un peu plus long", @"Message", @"Facebook", @"Twitter", @"Google +"],
                        @[@"Add homepage",@"Add bookmark"]
                        ];
    
    self.dataImage = @[
                        @[@""],
                        @[@"mail", @"message", @"facebook", @"twitter", @"google-plus"],
                        @[@"home",@"Bookmark"]
                        ];
    
    self.actions = [[ActionSheetShareView alloc]initWithFrame:self.view.frame];
    self.actions.delegate = self;
    self.actions.dataSource = self;
    self.actions.buttonText = @"Cancel";
    [self.view addSubview:self.actions];
}
- (IBAction)showAction:(id)sender {
    
    [self.actions show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfRowsInActionShareView:(ActionSheetShareView *)actionShareView{
    return [self.dataString count];
}

-(NSInteger)actionShareView:(ActionSheetShareView *)actionShareView numberOfCellsInRow:(NSInteger)row{
    NSArray* array = self.dataString[row];
    return [array count];
}

- (NSString *)actionShareView:(ActionSheetShareView *)actionShareView buttonTextForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* array = self.dataString[indexPath.row];
    return array[indexPath.section];
}

- (UIImage *)actionShareView:(ActionSheetShareView *)actionShareView imageForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* array = self.dataImage[indexPath.row];
    return [UIImage imageNamed:array[indexPath.section]];
}

- (void)actionShareView:(ActionSheetShareView *)actionShareView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select row : %ld, cell : %ld",indexPath.row,indexPath.section);
}

@end

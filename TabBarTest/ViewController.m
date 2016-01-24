//
//  ViewController.m
//  TabBarTest
//
//  Created by 林勇 on 16/1/24.
//  Copyright (c) 2016年 Leonly91. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController ()
{
    NSString *cellUseId;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self->cellUseId = @"XFCell";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self->cellUseId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40)];
    searchBar.placeholder  = @"Search";
    searchBar.delegate = self;
    searchBar.showsBookmarkButton = YES;//是否在右侧显示书图标
    searchBar.showsCancelButton = NO;//是否显示取消
    searchBar.prompt = @"Prompt";//上面显示的文本
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.tableView.tableHeaderView = searchBar;
    
    [self.view addSubview:self.tableView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [self.dataArray addObject: [NSString stringWithFormat:@"Data-%d", i]];
    }
    
    self.searchArray = [[NSMutableArray alloc] init];
    [self.searchArray addObjectsFromArray:self.dataArray];
    
    self.searchController = [[UISearchDisplayController alloc]  initWithSearchBar:searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchController.searchResultsTableView)
    {
        return [self.searchArray count];
    }else
    {
        return [self.dataArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:self->cellUseId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self->cellUseId];
    }
    if (tableView == self.searchController.searchResultsTableView)
    {
        cell.textLabel.text = self.searchArray[indexPath.row];
    }else
    {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    
    return cell;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    NSLog(@"searchStirng:%@", searchString);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString ];
    [self.searchArray removeAllObjects];

    self.searchArray = [NSMutableArray arrayWithArray: [self.dataArray filteredArrayUsingPredicate:predicate]];
    return YES;
}

@end

//
//  ViewController.m
//  SFRefreshView
//
//  Created by Cai.flower on 2018/4/13.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+SFRefresh.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView.refreshWrapper addHeaderRefreshWithHandler:^{
        
        [self tableViewDidTriggerHeaderRefresh:YES];
    }];
    
    [self.tableView.refreshWrapper beginHeaderRefresh];
    
    [self.tableView.refreshWrapper addFooterRefreshWithhandler:^{
        [self tableViewDidTriggerHeaderRefresh:NO];
    }];
    
}

- (void)tableViewDidTriggerHeaderRefresh:(BOOL)isHeader
{
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isHeader) {
            [weakself.dataSource removeAllObjects];
        }
        for (NSInteger i = 0; i < 5; i++) {
            NSString * str = [NSString stringWithFormat:@"%zd",i];
            [weakself.dataSource addObject:str];
        }
        if (isHeader) {
            [weakself.tableView.refreshWrapper resetNoMoreData];
            [weakself.tableView.refreshWrapper endHeaderRefresh];
        } else {
            if (weakself.dataSource.count >= 20) {
                [weakself.tableView.refreshWrapper endWithNoMoreData];
            } else {
                [weakself.tableView.refreshWrapper endFooterRefresh];
            }
        }
       
        [weakself.tableView reloadData];
    });
    
}

- (IBAction)navToNext:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    return cell;
    
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


@end

# iOS UITableView定制系统左滑删除按钮的样式

开发的时候，经常会遇到 tableView 左滑删除按钮，UI设计的是各种各样的，系统提供的根本满足不了需求，也不想导入一些第三方的东西，然后各种属性设置，太麻烦了，效果也不怎么样。那怎么来修改系统自带的呢？

下面进入正题：
![141498637142.jpg](http://upload-images.jianshu.io/upload_images/2168220-0ea8c70098e90e89.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

看到Cell上有这个视图，那就一定能找的到
我们在```点击删除的代理方法``` 里边遍历cell的子视图
```
// 编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// 点击删除的代理方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView * sv in cell.subviews) {
        NSLog(@"%@", sv);
    }
}
```
下面看打印信息
![191498639007.jpg](http://upload-images.jianshu.io/upload_images/2168220-1b9897d0a57a0ea7.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

有一个一个名字叫```UITableViewCellDeleteConfirmationView```的类，就是它了！

为什么我们要在```点击删除的代理方法```里边找，原因看图

![181498637669.jpg](http://upload-images.jianshu.io/upload_images/2168220-c6d443720fb30bb1.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
当删除按钮没有显示的情况下，cell子视图里是没有这个视图的，那可断定是在左滑的时候系统把它加上去的，我们可重写cell的 ```insertSubview:atIndex:``` 这个方法，当添加 delete view 的时候，会进这个方法，我们可以在此方法中对它进行修改。

下面我们看下它的层级关系

![151498637270.jpg](http://upload-images.jianshu.io/upload_images/2168220-741c246f5cdf1dcc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

UITableViewCellDeleteConfirmationView > _UITableViewCellActionButton

图中可看到里边是一个 UIButton 的子类，好，我们就可以想怎么改就怎么改了！

下面我们来修改它：
```
// 重写 insertSubview:atIndex 方法
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [super insertSubview:view atIndex:index];
    
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
        for (UIButton *btn in view.subviews) {

            if ([btn isKindOfClass:[UIButton class]]) {
                [btn setBackgroundColor:[UIColor orangeColor]];

                [btn setTitle:nil forState:UIControlStateNormal];

                UIImage *img = [image_name(@"del") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [btn setImage:img forState:UIControlStateNormal];
                [btn setImage:img forState:UIControlStateHighlighted];
                
                [btn setTintColor:[UIColor whiteColor]];
            }
        }
    }
}
```
好了，我们运行看效果
![Simulator Screen Shot.png](http://upload-images.jianshu.io/upload_images/2168220-017a4711381ff0fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)

至此，系统的删除按钮定制完成，我们拿到了这个view就可以随心所欲了，想定制什么样式，发挥你的想象吧！

查看原文 http://www.jianshu.com/p/f942f203f824

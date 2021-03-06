//
//  BinaryTree.m
//  LeetCode
//
//  Created by 58 on 2020/11/12.
//

#import "BinaryTree.h"
#import "MyStack.h"
#import "ListNode_C.h"



static id object = NULL;

@interface BTNode : NSObject

// ************************* BTNode *******************************
@property(assign, nonatomic)int data;
@property(strong, nonatomic,nullable)BTNode *parent;
@property(strong, nonatomic,nullable)BTNode *left;
@property(strong, nonatomic,nullable)BTNode *right;
@end
@implementation BTNode

- (instancetype)init{
    self = [super init];
    if (self) {
        self.data=0;
        self.parent=nil;
        self.left=nil;
        self.right=nil;
    }
    return self;
}
@end

// ************************* BTNode1 *******************************
@interface BTNode1 : NSObject

@property(assign, nonatomic)NSInteger data;
@property(strong, nonatomic,nullable)BTNode1 *parent;
@property(strong, nonatomic,nullable)BTNode1 *left;
@property(strong, nonatomic,nullable)BTNode1 *right;
@property(strong, nonatomic,nullable)BTNode1 *next;
@end
@implementation BTNode1
- (instancetype)init{
    self = [super init];
    if (self) {
        self.data=0;
        self.parent=nil;
        self.left=nil;
        self.right=nil;
    }
    return self;
}
@end

// ************************* Info *******************************
@interface Info : NSObject
@property(strong, nonatomic)BTNode *root;
@property(assign, nonatomic)NSInteger size;
@property(assign, nonatomic)NSInteger max;
@property(assign, nonatomic)NSInteger min;
- (instancetype)initWithRoot:(BTNode *)root
                        size:(NSInteger)size
                         max:(NSInteger)max
                         min:(NSInteger)min;
@end
@implementation Info
- (instancetype)initWithRoot:(BTNode *)root
                        size:(NSInteger)size
                         max:(NSInteger)max
                         min:(NSInteger)min{
    
    self = [super init];
    if (self) {
        self.root=root;
        self.size=size;
        self.max=max;
        self.min=min;
    }
    return self;
}

@end

// ************************* BinaryTree *******************************
@interface BinaryTree ()
// 处理99题需要的属性
@property(nonatomic,strong)BTNode *prev; // 上一次中序遍历过的节点
@property(nonatomic,strong)BTNode *firstWrong; // 第一个错误节点
@property(nonatomic,strong)BTNode *secondWrong; // 第二个错误节点
// 处理124题需要的属性
@property(assign, nonatomic)int maxValue;


@end
@implementation BinaryTree
- (instancetype)init
{
    self = [super init];
    if (self) {
        object=self;
        self.maxValue=INT_MIN;
    }
    return self;
}
/**
 写递归算法的关键是要明确函数的「定义」是什么，然后相信这个定义，利用这个定义推导最终结果，
 绝不要试图跳入递归。
 怎么理解呢，我们用一个具体的例子来说，比如说让你计算一棵二叉树共有几个节点：
 int count(TreeNode root) {
     // base case
     if (root == null) return 0;
     // 自己加上子树的节点数就是整棵树的节点数
     return 1 + count(root.left) + count(root.right);
 }
 左右子树的节点数怎么算？其实就是计算根为root.left和root.right两棵树的节点数呗，按照定义，递归调用count函数即可算出来。
 */
// 定义：count(root) 返回以 root 为根的树有多少节点
-(int)count:(BTNode *)root {
    // base case
    if (root == nil) return 0;
    // 自己加上子树的节点数就是整棵树的节点数
    return 1 + [self count:root.left] + [self count:root.right];
}




#pragma mark - 226 反转二叉树
//************************* 226 反转二叉树 *************************
/**
 难度 简单
 翻转一棵二叉树。
 https://leetcode-cn.com/problems/invert-binary-tree/
 示例：

 输入：

      4
    /   \
   2     7
  / \   / \
 1   3 6   9
 输出：
      4
    /   \
   7     2
  / \   / \
 9   6 3   1
 
 我们发现只要把二叉树上的每一个节点的左右子节点进行交换，最后的结果就是完全翻转之后的二叉树。
 */
//1、递归处理。三种遍历方式都可以
-(BTNode *)invertTree1:(BTNode *)root{
    if (root == NULL) return root;
    
    /**** 前序遍历位置 ****/
    // root 节点需要交换它的左右子节点
    BTNode *node=root.left;
    root.left=root.right;
    root.right=node;
    
    // 让左右子节点继续翻转它们的子节点
    [self invertTree1:root.left];
    [self invertTree1:root.right];
    return root;
}
//把交换左右子节点的代码放在中序遍历的位置需要有些改动的
-(BTNode *)invertTree2:(BTNode *)root{
    if (root == NULL) return root;
    
    [self invertTree2:root.left];
    // 中序遍历位置
    BTNode *node=root.left;
    root.left=root.right;
    root.right=node;
    
    [self invertTree2:root.left]; // 注意此处，传入的依然是root.left
    return root;
}
//如果把交换左右子节点的代码放在后序遍历的位置也是可以的
-(BTNode *)invertTree3:(BTNode *)root{
    if (root == NULL) return root;
    [self invertTree3:root.left];
    [self invertTree3:root.right];
    
    BTNode *node=root.left;
    root.left=root.right;
    root.right=node;
    return root;
}
//迭代-使用队列这里使用数组代替,其实就是二叉树的层序遍历
-(BTNode *)invertTree4:(BTNode *)root{
    if (root == NULL) return root;
    NSMutableArray *queue=[NSMutableArray array];
    [queue addObject:root];
    
    while (queue.count != 0) {
        BTNode *node = queue.firstObject;
        BTNode *tmp = node.left;
        node.left = node.right;
        node.right = tmp;
        [queue removeObjectAtIndex:0];
        
        if (node.left != NULL) {
            [queue addObject:node.left];
        }
        if (node.right != NULL) {
            [queue addObject:node.right];
        }
    }
    return root;
}
#pragma mark - 116 填充二叉树节点的右侧指针
//************************* 116 填充二叉树节点的右侧指针 *************************
/**
 116. 填充每个节点的下一个右侧节点指针 ¥
 难度 中等
 https://leetcode-cn.com/problems/populating-next-right-pointers-in-each-node/
给定一个完美二叉树，其所有叶子节点都在同一层，每个父节点都有两个子节点。二叉树定义如下：

 struct Node {
   int val;
   Node *left;
   Node *right;
   Node *next;
 }
 填充它的每个 next 指针，让这个指针指向其下一个右侧节点。如果找不到下一个右侧节点，则将 next 指针设置为 NULL。

 初始状态下，所有 next 指针都被设置为 NULL。
 */

-(BTNode1 *)connect:(BTNode1 *)root{
    if (root == nil) return root;
    [self connectTwoNode:root.left node:root.right];
    return root;
}
-(void)connectTwoNode:(BTNode1 *)node1 node:(BTNode1 *)node2{
    if (node1 == nil || node2 == nil) return;
    
    /**** 前序遍历位置 ****/
    // 将传入的两个节点连接
    node1.next = node2;
    
    // 连接相同父节点的两个子节点
    [self connectTwoNode:node1.left node:node1.right];
    [self connectTwoNode:node2.left node:node2.right];
    
    // 连接跨越父节点的两个子节点
    [self connectTwoNode:node1.right node:node2.left];
}
#pragma mark - 114 二叉树展开为连表
//************************* 114 二叉树展开为连表 *************************
/**
 114. 二叉树展开为链表 ¥
 https://leetcode-cn.com/problems/flatten-binary-tree-to-linked-list/
给定一个二叉树，原地将它展开为一个单链表。
 例如，给定二叉树

     1
    / \
   2   5
  / \   \
 3   4   6
 将其展开为：

 1
  \
   2
    \
     3
      \
       4
        \
         5
          \
           6
 */
/**
 我们尝试给出这个函数的定义：
 给flatten函数输入一个节点root，那么以root为根的二叉树就会被拉平为一条链表。
 我们再梳理一下，如何按题目要求把一棵树拉平成一条链表？很简单，以下流程：
 1、将root的左子树和右子树拉平。
 2、将root的右子树接到左子树下方，然后将整个左子树作为右子树。
 看起来最难的应该是第一步对吧，如何把root的左右子树拉平？其实很简单，按照flatten函数的定义，对root的左右子树递归调用flatten函数即可：
 */
// 定义：将以 root 为根的树拉平为链表
-(void)flatten:(BTNode *)root{
    // base case
    if (root == nil) return;

    [self flatten:root.left];
    [self flatten:root.right];

    /**** 后序遍历位置 ****/
    // 1、左右子树已经被拉平成一条链表
    BTNode *left = root.left;
    BTNode *right = root.right;

    // 2、将左子树作为右子树
    root.left = nil;
    root.right = left;

    // 3、将原先的右子树接到当前右子树的末端
    BTNode *p = root;
    while (p.right != nil) {
        p = p.right;
    }
    p.right = right;
    
    // 这就是递归的魅力，你说flatten函数是怎么把左右子树拉平的？不容易说清楚，
    // 但是只要知道flatten的定义如此，相信这个定义，让root做它该做的事情，
    // 然后flatten函数就会按照定义工作。
    // 递归算法的关键要明确函数的定义，相信这个定义，而不要跳进递归细节。
}
#pragma mark - 654 最大二叉树
/**
 先来复习一下，我们说过写树的算法，关键思路如下：
 把题目的要求细化，搞清楚根节点应该做什么，然后剩下的事情抛给前/中/后序的遍历框架就行了，我们千万不要跳进递归的细节里，你的脑袋才能压几个栈呀。
 */
//************************* 654 最大二叉树 *************************
/**
 654. 最大二叉树
 https://leetcode-cn.com/problems/maximum-binary-tree/
 给定一个不含重复元素的整数数组。一个以此数组构建的最大二叉树定义如下：
 二叉树的根是数组中的最大元素。
 左子树是通过数组中最大值左边部分构造出的最大二叉树。
 右子树是通过数组中最大值右边部分构造出的最大二叉树。
 通过给定的数组构建最大二叉树，并且输出这个树的根节点。
 示例 ：
 输入：[3,2,1,6,0,5]
 输出：返回下面这棵树的根节点：

       6
     /   \
    3     5
     \    /
      2  0
        \
         1
 */

/**
 肯定要遍历数组把找到最大值 maxVal，把根节点 root 做出来，然后对 maxVal 左边的数组和右边的数组进行递归调用，作为 root 的左右子树。
  伪代码如下所示：
 TreeNode constructMaximumBinaryTree([3,2,1,6,0,5]) {
     // 找到数组中的最大值
     TreeNode root = new TreeNode(6);
     // 递归调用构造左右子树
     root.left = constructMaximumBinaryTree([3,2,1]);
     root.right = constructMaximumBinaryTree([0,5]);
     return root;
 }
 */
/* 主函数 */
-(BTNode *)constructMaximumBinaryTree:(NSArray *)array {
    
    return [self build:array left:0 right:(int)array.count];
}

/* 将 [l, r) 构造成符合条件的树，返回根节点 */
-(BTNode *)build:(NSArray *)array left:(int)l right:(int)r{
    // base case
    if (l == r) return nil;

    // 找到数组中的最大值和对应的索引
    int maxIndex = -1, maxVal = INT_MIN;
    for (int i = l; i < r; i++) {
        if (maxVal < [array[i] intValue]) {
            maxIndex = i;
            maxVal = [array[i] intValue];
        }
    }
    BTNode *root=[[BTNode alloc]init];
    root.data=maxVal;
    // 递归调用构造左右子树
    root.left = [self build:array left:l right:maxIndex];
    root.right = [self build:array left:maxIndex+1 right:r];

    return root;
}

/**
 题目变形：返回一个数组，数组里面存着每个节点的父节点的索引（如果没有父节点，就存 -1）
 index: 0 1 2  3 4 5
 value: 3 2 1  6 0 5
return: 3 0 1 -1 5 3
 
 思路：利用栈求左、右边第一个比它大的数，这个栈从底到顶是降序的。
 */
int *parentIndexes(int *nums, int length) {
    if (nums == NULL || length == 0) return NULL;
    /*
     * 1.扫描一遍所有的元素
     * 2.保持栈从栈底到栈顶是单调递减的
     */
    
    //存储某个数它左边第一个比它大的数的索引
    int *lis=(int *)malloc(sizeof(int)*length);
    //存储某个数它右边第一个比它大的数的索引
    int *ris=(int *)malloc(sizeof(int)*length);
    // 初始化
    for (int i = 0; i < length; i++) {
        ris[i] = -1; // 索引默认为-1，也就是nums[i]左边没有比nums[i]大的数
        lis[i] = -1; // 索引默认为-1，也就是nums[i]右边没有比nums[i]大的数
    }

    MyStack *stack=[[MyStack alloc]init]; // 栈中存储的是数组索引
    
    for (int i = 0; i < length; i++) {
        // 1 首先栈不为空
        // 2 看一下栈顶元素和将要入栈的元素nums[i]谁大，
        // 2.1 如果将要入栈的元素更大：则需要把站定元素弹出，
        // 那么这个栈顶元素的右边第一个最大的数就是nums[i]
        while (!stack.isEmpty && nums[i] > nums[stack.peek]) {
            ris[stack.pop] = i; // 栈顶元素的右边第一个最大的数就是nums[i]，存储索引。
        }
        // 2.2 如果将要入栈的元素比栈顶元素小：那么这个将要入栈的元素左边第一个比它大的数就是栈顶元素
        if (!stack.isEmpty) {
            lis[i] = stack.peek; // 这个将要入栈的元素左边第一个比它大的数就是栈顶元素 。存储索引
        }
        // 3 如果将要入栈的元素比栈顶元素小或者栈则继续入栈
        [stack push:i];
    }
    // 到此 lis[i] 和 ris[i] 数组就存著着nums[i]这个数左边第一个比它大的数/右边第一个比它大的数的索引。
    // 而最大二叉树的原理就是每个节点都比左右子节点大。
    // 只需要找出lis[i]和ris[i]两者比较小的那个，就是nums[i]的父节点
    // 为什么找lis[i]和ris[i]两者比较小的那个，
    // 因为比较大的那个是祖父节点甚至更高层次的节点。不是直接父节点
    int *pis=(int *)malloc(sizeof(int)*length);
    
    for (int i = 0; i < length; i++) {
        if (lis[i] == -1 && ris[i] == -1) {
            // i位置的是根节点
            pis[i] = -1;
            continue;
        }
        if (lis[i] == -1) { // lis[i] 等于-1 表示nums[i]左边没有比nums[i]大的数，只能选右边ris[i]
            pis[i] = ris[i];
        } else if (ris[i] == -1) { // ris[i] 等于-1 表示nums[i]右边没有比nums[i]大的数，只能选左边lis[i]
            pis[i] = lis[i];
        } else if (nums[lis[i]] < nums[ris[i]]) { // lis[i]和ris[i] 都存在，取较小者
            pis[i] = lis[i];
        } else {
            pis[i] = ris[i];
        }
    }
    return pis;
}
#pragma mark - 105. 从前序与中序遍历序列构造二叉树
//************************* 105. 从前序与中序遍历序列构造二叉树 *************************
/**
 105. 从前序与中序遍历序列构造二叉树 ¥¥¥¥¥
 难度 中等
 https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/
 根据一棵树的前序遍历与中序遍历构造二叉树。
 注意:
 你可以假设树中没有重复的元素。

 例如，给出

 前序遍历 preorder = [3,9,20,15,7]
 中序遍历 inorder = [9,3,15,20,7]
 返回如下的二叉树：

     3
    / \
   9  20
     /  \
    15   7
 */
/**
 首先思考，根节点应该做什么。
 类似上一题，我们肯定要想办法确定根节点的值，把根节点做出来，然后递归构造左右子树即可。
 找到根节点是很简单的，前序遍历的第一个值preorder[0]就是根节点的值，关键在于如何通过根节点的值，
 将preorder和postorder数组划分成两半，构造根节点的左右子树？
 */
-(BTNode *)buildTree:(int *)preorder preorderSize:(int)preorderSize inorder:(int *)inorder inorderSize:(int)inorderSize{
    
    return [self build:preorder
              preStart:0
                preEnd:preorderSize-1
               inorder:inorder
               inStart:0
                 inEnd:inorderSize-1];
}
-(BTNode *)build:(int *)preorder
        preStart:(int)preStart
          preEnd:(int)preEnd
         inorder:(int *)inorder
         inStart:(int)inStart
           inEnd:(int)inEnd{
    if (preStart > preEnd) {
        return nil;
    }
    // root 节点对应的值就是前序遍历数组的第一个元素
    int rootVal = preorder[preStart];
    // rootVal 在中序遍历数组中的索引
    int index = 0;
    for (int i = inStart; i <= inEnd; i++) {
        if (inorder[i] == rootVal) {
            index = i;
            break;
        }
    }
    
    //中序数组中可以拿到leftSize
    int leftSize = index - inStart;
    
    // 先构造出当前根节点
    BTNode *root = [[BTNode alloc]init];
    root.data=rootVal;
    
    // 递归构造左子树
    //preorder 左子树[preStart+1,  preStart+leftSize]
    //inorder 左子树[inStart,  index-1]
    root.left = [self build:preorder
                   preStart:preStart+1
                     preEnd:preStart+leftSize
                    inorder:inorder
                    inStart:inStart
                      inEnd:index-1];
    
    // 递归构造右子树
    //preorder 右子树[preStart + leftSize + 1,  preEnd]
    //inorder 右子树[index + 1,  inEnd]
    root.right = [self build:preorder
                    preStart:preStart + leftSize + 1
                      preEnd:preEnd
                     inorder:inorder
                     inStart:index + 1
                       inEnd:inEnd];
    return root;
    
}
#pragma mark - 106. 从中序与后序遍历序列构造二叉树
//************************* 106. 从中序与后序遍历序列构造二叉树 *************************
/**
 106. 从中序与后序遍历序列构造二叉树
 难度 中等
 https://leetcode-cn.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/
 根据一棵树的中序遍历与后序遍历构造二叉树
 注意:
 你可以假设树中没有重复的元素。

 例如，给出

 中序遍历 inorder = [9,3,15,20,7]
 后序遍历 postorder = [9,15,7,20,3]
 返回如下的二叉树：

     3
    / \
   9  20
     /  \
    15   7
 */
/**
 解法和上题类似.有了前一题的铺垫，这道题很快就解决了，无非就是rootVal变成了最后一个元素，
 再改改递归函数的参数而已，只要明白二叉树的特性，也不难写出来。
 */
-(BTNode *)buildTree:(int *)inorder inorderSize:(int)inorderSize postorder:(int *)postorder postorderSize:(int)postorderSize{
    
    return [self build:inorder
               inStart:0
                 inEnd:inorderSize-1
             postorder:postorder
             postStart:0
               postEnd:postorderSize-1];
}
-(BTNode *)build:(int *)inorder
         inStart:(int)inStart
           inEnd:(int)inEnd
       postorder:(int *)postorder
       postStart:(int)postStart
         postEnd:(int)postEnd{
    if (inStart > inEnd) {
        return nil;
    }
    // root 节点对应的值就是后序遍历数组的最后一个元素
    int rootVal = postorder[postEnd];
    // rootVal 在中序遍历数组中的索引
    int index = 0;
    for (int i = inStart; i <= inEnd; i++) {
        if (inorder[i] == rootVal) {
            index = i;
            break;
        }
    }
    
    //中序数组中可以拿到leftSize
    int leftSize = index - inStart;
    
    // 先构造出当前根节点
    BTNode *root = [[BTNode alloc]init];
    root.data=rootVal;
    
    // 递归构造左子树
    //inorder     左子树[inStart,  index-1]
    //postorder   左子树[postStart,  postStart+leftSize-1]
    root.left = [self build:inorder
                    inStart:inStart
                      inEnd:index-1
                  postorder:postorder
                  postStart:postStart
                    postEnd:postStart+leftSize-1];
    
    // 递归构造右子树
    //inorder   右子树[index+1,  inEnd]
    //postorder 右子树[postStart+leftSize, postEnd]
    root.right = [self build:inorder
                     inStart:index+1
                       inEnd:inEnd
                   postorder:postorder
                   postStart:postStart+leftSize
                     postEnd:postEnd];
    return root;
    
}
#pragma mark - 513 找树左下角的值
//************************* 513 找树左下角的值 *************************
/**
 给定一个二叉树，在树的最后一行找到最左边的值。
 示例 1:
 输入:
     2
    / \
   1   3
 输出:
 1
 示例 2:
 输入:
         1
        / \
       2   3
      /   / \
     4   5   6
        /
       7
 输出:
 7
 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/find-bottom-left-tree-value
 著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。
 */
/**
 1 层序遍历
 时间复杂度：O（n）
 空间复杂度：O（1）
 */
-(int)findBottomLeftValue:(BTNode *)root{
    NSMutableArray *queue=[NSMutableArray array];
    [queue addObject:root];
    int size = 1;
    int leftValue = 0;
    while (queue.count != 0) {
        BTNode *node=(BTNode *)queue.firstObject;
        [queue removeLastObject];
        size--;
        if (node.left) {
            [queue addObject:node.left];
        }
        if (node.right) {
            [queue addObject:node.right];
        }
        if (size == 0) {
            size=(int)queue.count;
            BTNode *node=(BTNode *)queue.firstObject;
            leftValue=(int)node.data;
        }
    }
    return leftValue;
}
#pragma mark - 129. 求根到叶子节点数字之和
//************************* 129. 求根到叶子节点数字之和 *************************
/**
 129. 求根到叶子节点数字之和
 给定一个二叉树，它的每个结点都存放一个 0-9 的数字，每条从根到叶子节点的路径都代表一个数字。
 例如，从根到叶子节点路径 1->2->3 代表数字 123。
 计算从根到叶子节点生成的所有数字之和。
 说明: 叶子节点是指没有子节点的节点。
 
 示例 1:
 输入: [1,2,3]
     1
    / \
   2   3
 输出: 25
 解释:
 从根到叶子节点路径 1->2 代表数字 12.
 从根到叶子节点路径 1->3 代表数字 13.
 因此，数字总和 = 12 + 13 = 25.
 
 示例 2:
 输入: [4,9,0,5,1]
     4
    / \
   9   0
  / \
 5   1
 输出: 1026
 解释:
 从根到叶子节点路径 4->9->5 代表数字 495.
 从根到叶子节点路径 4->9->1 代表数字 491.
 从根到叶子节点路径 4->0 代表数字 40.
 因此，数字总和 = 495 + 491 + 40 = 1026.
 https://leetcode-cn.com/problems/sum-root-to-leaf-numbers/
 
 */
/**
 递归
 1 我们要遍历整个二叉树，且需要要返回值做逻辑处理，所有返回值为void
 参数只需要把根节点传入，此时还需要定义两个全局遍历，一个是result，记录最终结果，一个是数组path，数组方便
 删除最后一个元素，回到上一个节点。这就是回溯
 2 当然是遇到叶子节点，此时要收集结果了，通知返回本层递归，因为单条路径的结果使用数组，
 我们需要一个函数arrayToInt把数组转成int。
 3 这里主要是当左节点不为空，path收集路径，并递归左孩子，右节点同理。
 */
static NSMutableArray *path = nil;
static int result = 0;
// 把数组里都的存储的一条路径的所有数字转化为int
-(int)arrayToInt:(NSArray *)array{
    int sum = 0;
    for (int i = 0; i < array.count; i++) {
        sum = sum * 10 + [array[i] intValue];
    }
    return sum;
}
-(void)traversal:(BTNode*)cur {
    if (!cur.left && !cur.right) { // 遇到了叶子节点
        result += [self arrayToInt:path];
        return;
    }
    if (cur.left) { // 左 （空节点不遍历）
        [path addObject:@(cur.left.data)];// 处理节点
        [self traversal:cur.left];//递归
        //来到这里说明前面一条路径处理完了，把数组最后一个元素删掉也就是删掉叶子结点cur.left
        //删除后最后一个元素是cur
        [path removeLastObject];// 回溯，撤销
    }
    if (cur.right) { // 右 （空节点不遍历）
        [path addObject:@(cur.right.data)];// 处理节点
        [self traversal:cur.right];// 递归
        [path removeLastObject];// 回溯，撤销
    }
    return ;
}
/**
 时间复杂度：O(n)，其中n 是二叉树的节点个数。对每个节点访问一次。
 空间复杂度：O(H)，其中H 是树的高度。空间复杂度主要取决于递归时栈空间的开销，最坏情况下，树呈现链状，
 空间复杂度为O(N)。平均情况下树的高度与节点数的对数正相关，空间复杂度为O(logN)。
 */
-(int)sumNumbers:(BTNode *)root {
    path=[NSMutableArray array];
    if (root == nil) return 0;
    [path addObject:@(root.data)];
    [self traversal:root];
    return result;
}
#pragma mark - 112. 路径总和
//************************* 112. 路径总和 *************************
/**
 112. 路径总和 ¥¥¥¥
 给定一个二叉树和一个目标和，判断该树中是否存在根节点到叶子节点的路径，这条路径上所有节点值相加等于目标和。
 说明: 叶子节点是指没有子节点的节点。
 示例:
 给定如下二叉树，以及目标和 sum = 22，
               5
              / \
             4   8
            /   / \
           11  13  4
          /  \      \
         7    2      1
 返回 true, 因为存在目标和为 22 的根节点到叶子节点的路径 5->4->11->2。
 https://leetcode-cn.com/problems/path-sum/
 */
/**
 递归
1 可以使用深度优先遍历的方式，确定递归函数的参数和返回类型
 参数：需要二叉树的根节点，还需要一个计数器，这个计数器用来计算二叉树的一条边之和是否正好是目标和，计数器为int型。来看返回值，递归函数什么时候需要返回值？什么时候不需要返回值？
 在《二叉树：我的左下角的值是多少？》中得出结论：如果需要搜索整颗二叉树，那么递归函数就不要返回值，如果要搜索其中一条符合条件的路径，递归函数就需要返回值，因为遇到符合条件的路径了就要及时返回。
 在《二叉树：我的左下角的值是多少？》因为要遍历树的所有路径，找出深度最深的叶子节点，所以递归函数不要返回值。而本题我们要找一条符合条件的路径，所以递归函数需要返回值，及时返回，
2 确定终止条件
 首先计数器如何统计这一条路径的和呢？
 不要去累加然后判断是否等于目标和，那么代码比较麻烦，可以用递减，让计数器count初始为目标和，然后每次减去遍历路径节点上的数值。如果最后count == 0，同时到了叶子节点的话，说明找到了目标和。
 如果遍历到了叶子节点，count不为0，就是没找到。
 3 确定单层递归的逻辑
 因为终止条件是判断叶子节点，所以递归的过程中就不要让空节点进入递归了。
 递归函数是有返回值的，如果递归函数返回true，说明找到了合适的路径，应该立刻返回。
 
 时间复杂度：O(N)，其中N 是树的节点数。对每个节点访问一次。
 空间复杂度：O(H)，其中H 是树的高度。空间复杂度主要取决于递归时栈空间的开销，最坏情况下，树呈现链状，
 空间复杂度为O(N)。平均情况下树的高度与节点数的对数正相关，空间复杂度为O(logN)。
 
 */

//回溯隐藏在traversal(cur->left, count - cur->left->val)这里， 因为把count - cur->left->val 直接作为参数传进去，函数结束，count的数值没有改变。
//为了把回溯的过程体现出来，可以改为如下代码：
-(BOOL)traversal_112:(BTNode*)cur count:(int)count {
    if (!cur.left && !cur.right && count == 0) return true; // 遇到叶子节点，并且计数为0
    if (!cur.left && !cur.right) return false; // 遇到叶子节点直接返回
    if (cur.left) { // 左
        count -= cur.left.data; // 递归，处理节点;
        if ([self traversal_112:cur.left count:count]) return true;
        count += cur.left.data; // 回溯，撤销处理结果
    }
    if (cur.right) { // 右
        count -= cur.right.data; // 递归，处理节点;
        if ([self traversal_112:cur.right count:count]) return true;
        count += cur.right.data; // 回溯，撤销处理结果
    }
    return false;
}
-(BOOL)hasPathSum1:(BTNode*)root sum:(int)sum {
    if (root == nil) return false;
    return [self traversal_112:root count:sum-root.data];
}
//以上代码精简之后如下
-(BOOL)hasPathSum2:(BTNode*)root sum:(int)sum {
    if (root == NULL) return false;
    if (!root.left && !root.right && sum == root.data) return true;
    return [self hasPathSum2:root.left sum:sum-root.data] || [self hasPathSum2:root.right sum:sum-root.data];
}

/**
 解法2 前序遍历迭代
 */
-(BOOL)hasPathSum3:(BTNode*)root sum:(int)sum {
    if (root == NULL) return false;
    NSMutableArray *stack=[NSMutableArray array];
    // 此时栈里要放的是<节点指针, 还要记录从头结点到该节点的路径数值总和>
    NSDictionary *dict=@{
        @"node":root,
        @"count":@(root.data)
    };
    [stack addObject:dict];
    while (stack.count != 0) {
        //访问节点
        NSDictionary *dict =(NSDictionary *)stack.lastObject;
        [stack removeLastObject];
        // 如果该节点是叶子节点了，同时该节点的路径数值等于sum，那么就返回true
        BTNode *node=dict[@"node"];
        int count=[dict[@"count"] intValue];
        if (!node.left && !node.right && sum == count) return true;
        // 右节点，压进去一个节点的时候，将该节点的路径数值也记录下来
        if (node.right) {
            NSDictionary *right=@{
                @"node":node.right,
                @"count":@(count+node.right.data)
            };
            [stack addObject:right];
        }
        // 左节点，压进去一个节点的时候，将该节点的路径数值也记录下来
        if (node.left) {
            NSDictionary *left=@{
                @"node":node.left,
                @"count":@(count+node.left.data)
            };
            [stack addObject:left];
        }
    }
    return false;
}
#pragma mark - 113. 路径总和II
//************************* 113. 路径总和II *************************
/**
 113. 路径总和 II
 https://leetcode-cn.com/problems/path-sum-ii/
 给定一个二叉树和一个目标和，找到所有从根节点到叶子节点路径总和等于给定目标和的路径。
 说明: 叶子节点是指没有子节点的节点。
 示例:
 给定如下二叉树，以及目标和 sum = 22，
               5
              / \
             4   8
            /   / \
           11  13  4
          /  \    / \
         7    2  5   1
 返回:
 [
    [5,4,11,2],
    [5,8,4,5]
 ]
 */


/**
 因为要遍历整个树，找到所有路径，所以递归函数不要返回值，112题目只是找到一个路径即可。
 */
static NSMutableArray *path_113 = nil;
static NSMutableArray *result_113 = nil;
-(void)traversal_113:(BTNode*)cur count:(int)count {
    if (!cur.left && !cur.right && count == 0) {
        // 遇到了叶子节点切找到了和为sum的路径
        // result_113 的元素是数组，是满足要求的节点路径
        [result_113 addObject:[NSArray arrayWithArray:path_113]];
        return ;
    }
    
    if (!cur.left && !cur.right) return ; // 遇到叶子节点而没有找到合适的边，直接返回
    
    if (cur.left) { // 左  空节点不遍历
        [path_113 addObject:@(cur.left.data)];
        count -= cur.left.data; // 递归，处理节点;
        [self traversal_113:cur.left count:count];
        count += cur.left.data; // 回溯，撤销处理结果
        [path_113 removeLastObject]; // 回溯
    }
    if (cur.right) { // 右 空节点不遍历
        [path_113 addObject:@(cur.right.data)];
        count -= cur.right.data; // 递归，处理节点;
        [self traversal_113:cur.right count:count];
        count += cur.right.data; // 回溯，撤销处理结果
        [path_113 removeLastObject]; // 回溯
    }
    return ;
}
-(BOOL)hasPathSum113:(BTNode*)root sum:(int)sum {
    if (root == nil) return false;
    path_113=[NSMutableArray array];
    result_113=[NSMutableArray array];
    
    [path_113 addObject:@(root.data)];
    [self traversal_113:root count:sum-root.data];
    return result_113;
}
#pragma mark - 101 二叉树是否对称 ¥¥
//************************* 101 二叉树是否对称 *************************
/**
 101. 对称二叉树 ¥¥
给定一个二叉树，检查它是否是镜像对称的。
 例如，二叉树 [1,2,2,3,4,4,3] 是对称的。
     1
    / \
   2   2
  / \ / \
 3  4 4  3
 但是下面这个 [1,2,2,null,3,null,3] 则不是镜像对称的:
     1
    / \
   2   2
    \   \
    3    3
 
 https://leetcode-cn.com/problems/symmetric-tree/
 */

/**
 迭代法
 对于二叉树是否对称，要比较的是根节点的左子树与右子树是不是相互翻转的，理解这一点就知道了「其实我们要比较的是两个树（这两个树是根节点的左右子树）」，所以在递归遍历的过程中，也是要同时遍历两棵树。比较的是两个子树的里侧和外侧的元素是否相等.
 
 首先我们引入一个队列，这是把递归程序改写成迭代程序的常用方法。每次提取两个结点并比较它们的值（队列中每两个连续的结点应该是相等的，而且它们的子树互为镜像），然后将两个结点的左右子结点按相反的顺序插入队列中。当队列为空时，或者我们检测到树不对称（即从队列中取出两个不相等的连续结点）时，该算法结束。
 
 复杂度分析

 时间复杂度：O(n)
 空间复杂度：这里需要用一个队列来维护节点，每个节点最多进队一次，出队一次，队列中最多不会超过n 个点，故渐进空间复杂度为O(n)。
 */

-(BOOL)isSymmetric:(BTNode*)root{
    if (root == NULL) return true;
    NSMutableArray *queue=[NSMutableArray array];
    NSObject* l=(root.left) ? root.left : [NSNull null];
    NSObject* r=(root.right) ? root.right : [NSNull null];
    [queue addObject:l];// 将左子树头结点加入队列
    [queue addObject:r];// 将右子树头结点加入队列
    while (queue.count != 0) {  // 接下来就要判断这这两个树是否相互翻转
        //出对
        NSObject* leftNode = (NSObject *)queue.firstObject;
        [queue removeObjectAtIndex:0];
        NSObject* rightNode = (NSObject *)queue.firstObject;
        [queue removeObjectAtIndex:0];
        // 左节点为空、右节点为空，此时说明是对称的
        if ( !leftNode && !rightNode) continue;
        // 左右一个节点不为空 返回false
        if (!leftNode || !rightNode) return false;
        // 都不为空但数值不相同 返回false
        if (((BTNode *)leftNode).data != ((BTNode *)rightNode).data) return false;
        
        
        //来到此处说明 leftNode 和 rightNode都有值且相等
        l = (((BTNode *)leftNode).left) ? ((BTNode *)leftNode).left : [NSNull null];
        [queue addObject:l];// 加入左节点左孩子
        
        r = (((BTNode *)rightNode).right) ? ((BTNode *)rightNode).right : [NSNull null];
        [queue addObject:r];// 加入右节点右孩子
        
        r = (((BTNode *)leftNode).right) ? ((BTNode *)leftNode).right : [NSNull null];
        [queue addObject:r];// 加入左节点右孩子
        
        l = (((BTNode *)rightNode).left) ? ((BTNode *)rightNode).left : [NSNull null];
        [queue addObject:l];// 加入右节点左孩子
    }
    return true;
}

//递归
/**
 要遍历两棵树而且要比较内侧和外侧节点,
 所以准确的来说是一个树的遍历顺序是「 左 右 中 」，一个树的遍历顺序是「 右 左 中 」，可以理解算是后序遍历。
 
 1 确定递归函数的参数和返回值
 要比较的是根节点的两个子树是否是相互翻转的，进而判断这个树是不是对称树，所以要比较的是两个树，参数自然也是左子树节点和右子树节点，返回值自然是bool类型。
 2 确定终止条件
 节点为空的情况有：
    a 左节点为空，右节点不为空，不对称，return false
    b 左不为空，右为空，不对称 return  false
    c 左右都为空，对称，返回true
 左右节点不为空：
    a 左右都不为空，比较节点数值，不相同就return false
    b 左右都不为空，且数值相同，则进入单层递归逻辑：
        a 比较二叉树外侧是否对称：传入的是左节点的左孩子，右节点的右孩子。
        b 比较内测是否对称，传入左节点的右孩子，右节点的左孩子。
        c 如果左右都对称就返回true ，有一侧不对称就返回false
 
 假设树上一共n 个节点。
 时间复杂度：这里遍历了这棵树，渐进时间复杂度为O(n)。
 空间复杂度：这里的空间复杂度和递归使用的栈空间有关，这里递归层数不超过n，故渐进空间复杂度为O(n)。
 */
-(BOOL)isSymmetric2:(BTNode*)root{
    if (root == nil) return true;
    return [self compareLeft:root.left right:root.right];
}
-(BOOL)compareLeft:(BTNode*)left right:(BTNode*) right {
    // 首先排除空节点的情况
    if (left == nil && right != nil) return false;
    else if (left != nil && right == nil) return false;
    else if (left == nil && right == nil) return true;
    // 排除了空节点，再排除数值不相同的情况
    else if (left.data != right.data) return false;

    // 此时就是：左右节点都不为空，且数值相同的情况
    // 此时才做递归，做下一层的判断
    
    // 左子树：左、 右子树：右
    bool outside = [self compareLeft:left.left right:right.right];
    // 左子树：右、 右子树：左
    bool inside = [self compareLeft:left.right right:right.left];
    // 左子树：中、 右子树：中 （逻辑处理）
    bool isSame = outside && inside;
    
    return isSame;
}
#pragma mark - 100  相同的树
//************************* 100. 相同的树 ¥ *************************
/**
 100. 相同的树
 给定两个二叉树，编写一个函数来检验它们是否相同。
 如果两个树在结构上相同，并且节点具有相同的值，则认为它们是相同的。
 示例 1:
 输入:       1         1
           / \       / \
          2   3     2   3

         [1,2,3],   [1,2,3]
 输出: true
 示例 2:
 输入:      1          1
           /           \
          2             2

         [1,2],     [1,null,2]
 输出: false
 示例 3:
 输入:       1         1
           / \       / \
          2   1     1   2

         [1,2,1],   [1,1,2]
 输出: false
 
 链接：https://leetcode-cn.com/problems/same-tree/
 */

/**
 思想： 深度优先搜索 递归
 如果两个二叉树都为空，则两个二叉树相同。如果两个二叉树中有且只有一个为空，则两个二叉树一定不相同。
 如果两个二叉树都不为空，那么首先判断它们的根节点的值是否相同，若不相同则两个二叉树一定不同，若相同，再分别判断两个二叉树的左子树是否相同以及右子树是否相同。这是一个递归的过程，因此可以使用深度优先搜索，递归地判断两个二叉树是否相同。
 
 1. 确定递归函数的参数和返回值
 我们要比较的是两个树是否是相互相同的，参数也就是两个树的根节点，返回值自然是bool类型。
 2. 确定终止条件
 要比较两个节点数值相不相同，首先要把两个节点为空的情况弄清楚！否则后面比较数值的时候就会操作空指针了。
 节点为空的情况有：
    a. tree1为空，tree2不为空，不对称，return false
    b. tree1不为空，tree2为空，不对称 return false
    c. tree1，tree2都为空，对称，返回true
 
 此时tree1、tree2都不为空，比较节点数值，不相同就return false
 3. 确定单层递归的逻辑
    a. 比较二叉树是否相同 ：传入的是tree1的左孩子，tree2的右孩子。
    b. 如果左右都相同就返回true ，有一侧不相同就返回false 。
 
 时间复杂度：O(min(m,n))，其中m 和n 分别是两个二叉树的节点数。对两个二叉树同时进行深度优先搜索，
 只有当两个二叉树中的对应节点都不为空时才会访问到该节点，因此被访问到的节点数不会超过较小的二叉树的节点数。
 空间复杂度：O(min(m,n))，其中m 和n 分别是两个二叉树的节点数。空间复杂度取决于递归调用的层数，
 递归调用的层数不会超过较小的二叉树的最大高度，最坏情况下，二叉树的高度等于节点数。

 */
-(BOOL)isSameTree1:(BTNode*)root{
    if (root == nil) return true;
    return [self compareLeft:root.left right:root.right];
}
-(BOOL)compareTree1:(BTNode*)tree1 tree2:(BTNode*)tree2{
    // 首先排除空节点的情况
    if (tree1 == nil && tree2 != nil) return false;
    else if (tree1 != nil && tree2 == nil) return false;
    else if (tree1 == nil && tree2 == nil) return true;
    // 排除了空节点，再排除数值不相同的情况
    else if (tree1.data != tree2.data) return false;

    // 此时就是：左右节点都不为空，且数值相同的情况
    // 此时才做递归，做下一层的判断
    // 左子树：左、 右子树：左
    bool outside = [self compareTree1:tree1.left tree2:tree1.left];
    // 左子树：右、 右子树：右
    bool inside = [self compareTree1:tree1.right tree2:tree1.right];
    //逻辑处理 左右都得相等
    bool isSame = outside && inside;
    return isSame;
}
#pragma mark - 236. 二叉树的最近公共祖先
//************************* 236. 二叉树的最近公共祖先 ¥¥ *************************
/**
 236. 二叉树的最近公共祖先 $$
 https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/
 难度 中等
 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。
 百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

 例如，给定如下二叉树:  root = [3,5,1,6,2,0,8,null,null,7,4]
 示例 1:
 输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
 输出: 3
 解释: 节点 5 和节点 1 的最近公共祖先是节点 3。
 示例 2:
 输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
 输出: 5
 解释: 节点 5 和节点 4 的最近公共祖先是节点 5。因为根据定义最近公共祖先节点可以为节点本身。
 说明:
 所有节点的值都是唯一的。
 p、q 为不同节点且均存在于给定的二叉树中。
 */

/**
 * 去以root为根节点的二叉树中查找p、q的最近公共祖先
 * ① 如果p、q同时存在于这棵二叉树中，就能成功返回它们的最近公共祖先
 * ② 如果p、q都不存在于这棵二叉树中，返回null
 * ③ 如果只有p存在于这棵二叉树中，返回p
 * ④ 如果只有q存在于这棵二叉树中，返回q
 */
-(BTNode *)lowestCommonAncestor_OC:(BTNode *)root p:(BTNode *)p q:(BTNode *)q{
    if (root == nil || root == p || root == q) return root;
    // 去以root.left为根节点的二叉树中查找p、q的最近公共祖先
    BTNode *left = [self lowestCommonAncestor_OC:root.left p:p q:q];
    // 去以root.right为根节点的二叉树中查找p、q的最近公共祖先
    BTNode *right = [self lowestCommonAncestor_OC:root.right p:p q:q];;
    
    // 如果left 和 right 都不为空，那么p和q 一定在 根结点两侧，且left=right=root
    if (left != nil && right != nil) return root;
    // 如果left和right有一个为空，
    return (left != nil) ? left : right;
}
#pragma mark - 333 最大BST子树
//************************* 333 最大BST子树 *************************
/**
 给定一个二叉树，找到其中最大的二叉搜索树子树，其中最大指的是子树节点数最多的。
 难度 中等
 https://leetcode-cn.com/problems/largest-bst-subtree/
 注意：子树必须包含气所有后代
 输入：[10,5,15,1,8,null,7]
    10
    / \
    5  15
   / \   \
   1  8   7
 
 输出：3
 因为其中
  5
 / \
 1  8
 构成最大BST子树
 
 能用O（n）的时间复杂度解决嘛
 */

-(NSInteger)largestBSTSubtree:(BTNode *)root{
    return (root == NULL) ? 0:[self getInfo:root].size;
}
-(Info *)getInfo:(BTNode *)root{
    if (root == nil) return nil;
    // li(left info)：左子树的最大BST子树信息
    Info *li = [self getInfo:root.left];

    // ri(right info)：右子树的最大BST子树信息
    Info *ri = [self getInfo:root.right];
    /*
    有4种情况，以root为根节点的二叉树就是一棵BST，最大BST子树就是其本身
    ① li != null && ri != null //左右子树不为空且都是BST
    && li.root == root.left && root.val > li.max // 且根结点的值正好大于左BST中的最大值
    && ri.root == root.right && root.val < ri.min // 且根结点的值正好小于左BST中的最小值 那么以root为根结点的树就是一颗更大的BST

    ② li != null && ri == null // 右子树为空
    && li.root == root.left && root.val > li.max // 且根结点的值正好大于左BST中的最大值，那么root也算是一个更大的BST

    ③ li == null && ri != null // 左子树为空
    && ri.root == root.right && root.val < ri.min // 且根结点的值正好小于左BST中的最小值，那么root也算是一个更大的BST

    ④ li == null && ri == null。// 左右子树都是空，那么一个节点也是一个BST
     */

    NSInteger leftBstSize = -1, rightBstSize = -1, max = root.data, min = root.data;
    if (li == nil) { // 左为空
        leftBstSize = 0;
    } else if (li.root == root.left && root.data > li.max) {
        // 左不为空，且左子树是BST，那么leftBstSize和min就有值了
        leftBstSize = li.size;
        min = li.min;
    }// 这里往后虽然左也不为空，但左不是BST了

    if (ri == nil) { // 右为空
        rightBstSize = 0;
    } else if (ri.root == root.right && root.data < ri.min) {
        // 右不为空，且右子树是BST，那么rightBstSize和max就有值了
        rightBstSize = ri.size;
        max = ri.max;
    }// 这里往后虽然右也不为空，但右不是BST了
    
    
    if (leftBstSize >= 0 && rightBstSize >= 0) {
        // 来到这里肯定li 和 ri 都是bst了， li和ri的父节点都是root
        Info *new_info = [[Info alloc]initWithRoot:root
                                              size:1 + leftBstSize + rightBstSize
                                               max:max
                                               min:min];
        return new_info;
    } // 这里代表leftBstSize 和 rightBstSize 等于-1 也就是li和ri不是bst
    
    // 以root为根节点的二叉树并不是BST
    // 返回最大BST子树的节点数量较多的那个Info
    if (li != nil && ri != nil) return (li.size > ri.size) ? li : ri;
    // 这里就代表其中一个为空。返回li、ri中不为null的那个Info
    return (li != nil) ? li : ri;
}
#pragma mark - 99. 恢复二叉搜索树
//************************* 99. 恢复二叉搜索树 ¥ *************************
/**
 99. 恢复二叉搜索树
 https://leetcode-cn.com/problems/recover-binary-search-tree/
 难度 困难
 给你二叉搜索树的根节点 root ，该树中的两个节点被错误地交换。请在不改变其结构的情况下，恢复这棵树。
 进阶：使用 O(n) 空间复杂度的解法很容易实现。你能想出一个只使用常数空间的解决方案吗？
 示例 1：
 输入：root = [1,3,null,null,2]
 输出：[3,1,null,null,2]
 解释：3 不能是 1 左孩子，因为 3 > 1 。交换 1 和 3 使二叉搜索树有效。
 示例 2：
 输入：root = [3,1,4,null,null,2]
 输出：[2,1,4,null,null,3]
 解释：2 不能在 3 的右子树中，因为 2 < 3 。交换 2 和 3 使二叉搜索树有效。
 
 */

/**
 思路：
 既然是二叉搜索树，那么中序遍历得到的是一个升序的序列
 只需要找到那个逆序对 就可以恢复了。
 1 如果两个对调的节点，其中序遍历不是挨着的，也就是会出现两个逆序对， 那么第一个错误节点是第一个逆序对中较大者，第二个错误节点是第二个逆序对中较小者。
 2 如果两个对调的节点，其中序遍历是挨着的，也就是只有一个逆序对，
 那么第一个错误节点是逆序对中较大者，第二个错误节点就是逆序对中较小者。
 */


/**
  二叉树的Morris遍历
  时间复杂度O（n）
  空间复杂度O（1）
  以下是Morris中序遍历：
 假设便利到当前节点N：
 1 如果N.left != null，则找到N的前驱节点就是左孩子P=N.left
    如果P.right == null，则P.right = N，也就是对原二叉树添加了一个指针，孩子的右孩子指向了自己。
    然后N=N.left, 然后再回到1
 2 如果N.left == null
    打印N，然后N=N.right，再然后回到1
 如果P.right == N
    则P.right = null //这是把刚才加上的指针断掉，恢复原有二叉树
    然后打印N，然后N=N.right，再回到1
 重复1 和 2 知道N== NULL
 */
-(void)recoverTree:(BTNode *)root{
    BTNode *node = root;
    while (node != nil) {
        if (node.left != nil) { //1 如果N.left != null
            // 找到前驱节点(predecessor)、后继节点(successor)
            BTNode *pred = node.left; // 找到N的前驱节点就是左孩子P=N.left
            while (pred.right != nil && pred.right != node) {
                pred = pred.right;
            }
            if (pred.right == nil) { // 如果P.right == null，
                pred.right = node; // 则P.right = N
                node = node.left; // 然后N=N.left, 然后再回到1
            } else { // 如果 pred.right == N
                [self find:node]; // 访问
                pred.right = nil; // 则P.right=null这是把刚才加上的指针断掉，恢复原有二叉树
                node = node.right; // 然后N=N.right，再回到1
            }
        } else { // 2 如果N.left == null
            [self find:node]; // 访问N
            node = node.right;
        }
    }
    // 交换2个错误节点的值
    int tmp = self.firstWrong.data;
    self.firstWrong.data = self.secondWrong.data;
    self.secondWrong.data = tmp;
}
// 递归
// 时间复杂度：O(N) N 为二叉搜索树的节点个数。
// 空间复杂度：O(H)，其中H 为二叉搜索树的高度。中序遍历的时候栈的深度取决于二叉搜索树的高度。
-(void)recoverTree2:(BTNode *)root{
    if (root == nil) return;
    [self findWrongNodes:root];
    // 交换2个错误节点的值
    int tmp = self.firstWrong.data;
    self.firstWrong.data = self.secondWrong.data;
    self.secondWrong.data = tmp;
    NSLog(@"");
}
-(void)findWrongNodes:(BTNode *)root {
   if (root == nil) return;
    [self findWrongNodes:root.left];
    [self find:root]; // 中序便利
    [self findWrongNodes:root.right];
}
-(void)find:(BTNode *)node{
    // 出现了逆序对
    if (self.prev != nil && self.prev.data > node.data) {
        // 第2个错误节点：最后一个逆序对中较小的那个节点
        self.secondWrong = node;
        // 第1个错误节点：第一个逆序对中较大的那个节点
        self.firstWrong=(self.firstWrong == nil)?self.prev:self.firstWrong;
    }
    self.prev = node;
}
+(void)recoverTreeTest{
   
    BinaryTree *bt=[[BinaryTree alloc]init];
    
    BTNode *root=[[BTNode alloc]init];
    root.data=3;
    
    BTNode *node1=[[BTNode alloc]init];
    node1.data=1;
    
    BTNode *node2=[[BTNode alloc]init];
    node2.data=4;
    
    BTNode *node3=[[BTNode alloc]init];
    node3.data=2;
    
    root.left=node1;
    root.right=node2;
    
    node2.left=node3;
    
    [bt recoverTree2:root];
    
}

#pragma mark - 124. 二叉树中的最大路径和
//************************* 124. 二叉树中的最大路径和 ¥¥ *************************
/**
 124. 二叉树中的最大路径和
 难度 困难
 https://leetcode-cn.com/problems/binary-tree-maximum-path-sum/
 给定一个非空二叉树，返回其最大路径和。
 本题中，路径被定义为一条从树中任意节点出发，沿父节点-子节点连接，达到任意节点的序列。该路径至少包含一个节点，且不一定经过根节点。
 示例 1：
 输入：[1,2,3]
       1
       / \
      2   3
 输出：6
 示例 2：
 输入：[-10,9,20,null,null,15,7]
    -10
    / \
   9  20
     /  \
    15   7
 输出：42
 */
/**
 定义 dfs 函数：求出当前子树能向父节点“提供”的最大路径和。即，一条从父节点延伸下来的路径，
 能在当前子树中捞取的最大收益。它分为三种情况：
 路径停在当前子树的根节点，收益：root.val
 走入左子树，最大收益：root.val + dfs(root.left)
 走入右子树，最大收益：root.val + dfs(root.right)
 最大收益取三者中的最大值。
 再次提醒：一条从父节点延伸下来的路径，不能走入左子树又掉头走右子树，不能两头收益。
 当遍历到null节点时，返回 0，代表收益为 0。
 如果一个子树提供的最大路径和为负，路径走入它，收益不增反减，我们希望这个子树不被考虑，让它返回 0，像砍掉一样。
 题目说，路径不一定经过根节点，说明，最大路径和可能产生于局部子树中
 因此每次递归调用，都求一下「当前子树内部的最大路径和」，每个子树都求，取最大的。
 注意，一个子树内部的路径，要包含当前子树的根节点。如果不包括根节点，那还算什么当前子树的路径，而是当前子树的子树的内部路径。
 所以，一个子树内部的最大路径和 = 左子树提供的最大路径和 + 根节点值 + 右子树提供的最大路径和。即 dfs(root.left) + root.val + dfs(root.right);
 时间复杂度O(N)，每个节点都要遍历，空间复杂度是O(H)，递归树的深度。
 */
-(int)maxPathSum:(BTNode *)root{
    if (root == nil) return 0;
    int maxSum=INT_MIN;
    [self dfs:root max:&maxSum];
    return maxSum;
}
-(int)dfs:(BTNode *)root max:(int *)maxSum{
    if (root == nil) {
        return 0;
    }
    int left = [self dfs:root.left max:maxSum]; // 左子树提供的最大收益
    int right = [self dfs:root.right max:maxSum]; // 右子树提供的最大收益
    // 此处也就是二叉树的后序遍历位置
    // 当前子树内部的最大路径和
    int innerMaxSum=left + root.data + right;
    // 挑战一下最大纪录
    *maxSum = max(*maxSum, innerMaxSum);
    // 对外提供的最大和
    int outputMaxSum = root.data + max(left, right);
    if (outputMaxSum < 0) return 0; // 对外提供的路径和为负，直接返回0
    return outputMaxSum; // 否则正常返回
}
+(void)binaryTreeTest{
    BinaryTree *bt=[[BinaryTree alloc]init];
    BTNode *root=[[BTNode alloc]init];
    root.data=1;
    BTNode *node1=[[BTNode alloc]init];
    node1.data=2;
    root.left=node1;
    BTNode *node2=[[BTNode alloc]init];
    node2.data=3;
    root.right=node2;
    
    int maxv = [bt maxPathSum:root];
    NSLog(@"maxPathSum: %d",maxv);
}
#pragma mark - 98. 验证二叉搜索树 $$
//************************* 98. 验证二叉搜索树 ¥¥ *************************
/**
 98. 验证二叉搜索树
 难度 中等
 https://leetcode-cn.com/problems/validate-binary-search-tree/
 给定一个二叉树，判断其是否是一个有效的二叉搜索树。
 假设一个二叉搜索树具有如下特征：
 节点的左子树只包含小于当前节点的数。
 节点的右子树只包含大于当前节点的数。
 所有左子树和右子树自身必须也是二叉搜索树。
 示例 1:
 输入:
     2
    / \
   1   3
 输出: true
 示例 2:
 输入:
     5
    / \
   1   4
      / \
     3   6
 输出: false
 解释: 输入为: [5,1,4,null,null,3,6]。
      根节点的值为 5 ，但是其右子节点值为 4 。
 */

bool isValidBST(BTNode *root) {
    return verifyBST(NULL, root, NULL);
}
/* 限定以 root 为根的子树节点必须满足 max.val > root.val > min.val */
bool verifyBST(BTNode * min, BTNode *root, BTNode * max) {
    // base case
    if (root == NULL) return true;
    // 若 root.val 不符合 max 和 min 的限制，说明不是合法 BST
    if (min != NULL && root.data <= min.data) return false;
    if (max != NULL && root.data >= max.data) return false;
    // 限定左子树的最大值是 root.val，右子树的最小值是 root.val
    return verifyBST(min, root.left, root) && verifyBST(root, root.right, max);
}

// 迭代。中序遍历
// 如果中序遍历得到的节点的值小于等于前一个节点的值，说明不是二叉搜索树
bool isValidBST2(BTNode* root) {
    if (root == NULL) {
        return false;
    }
    MyStack *stack=[[MyStack alloc]init];
    int preVal = INT_MIN; // 前一个节点。
    BTNode *n=root;
    while (true) {
        if (n != NULL) {
            [stack push_obj:n];
            // 向左走,一直把所有最左侧的节点入栈，知道最左侧的节点为null
            n = n.left;
        } else if (stack.size == 0) {
            break;
        } else { //最左侧的节点为null时
            n=stack.pop_obj; //取出栈顶元素，此时这个node正好是为空的那个节点的父节点。
            if (root.data < preVal) {
                return false;
            }
            preVal = n.data;
            // 让右节点进行中序遍历
            n = n.right; //在赋值栈顶节点的右节点，下一轮开始
        }
    }
    return true;
}

#pragma mark - 在 BST 中搜索一个数
//************************* 在 BST 中搜索一个数 *************************
//在二叉树中寻找一个数。 这个适合所有二叉树
bool isInBinaryTree(BTNode *root, int target){
    if (root == NULL) return false;
    if (root.data == target) return true;
    // 当前节点没找到就递归地去左右子树寻找
    return isInBinaryTree(root.left, target) || isInBinaryTree(root.right, target);
}
// 那么应该如何充分利用信息，把 BST 这个「左小右大」的特性用上？
bool isInBST(BTNode *root, int target) {
    if (root == NULL) return false;
    if (root.data == target) return true;
    if (root.data < target) return isInBST(root.right, target);
    if (root.data > target) return isInBST(root.left, target);
    return false;
}

//于是，我们对原始框架进行改造，抽象出一套针对 BST 的遍历框架：
//这个代码框架其实和二叉树的遍历框架差不多，无非就是利用了 BST 左小右大的特性而已。
void BST(BTNode * root, int target) {
    if (root.data == target){
        // 找到目标，做点什么。。。
    }else if (root.data< target){
        // 去右子树。。。todo
        BST(root.right, target);
    }else if (root.data > target){
        // 去左子树。。。todo
        BST(root.left, target);
    }else{
        
    }
}
#pragma mark - 在 BST 中插入一个数
//************************* 在 BST 中插入一个数 *************************
BTNode * insertIntoBST(BTNode * root, int val) {
    // 找到空位置插入新节点
    if (root == NULL){
        BTNode *new=[[BTNode alloc]init];
        new.data=val;
        return new;
    }
    // if (root.val == val)
    // BST 中一般不会插入已存在元素
    if (root.data < val) root.right = insertIntoBST(root.right, val);
    if (root.data > val) root.left = insertIntoBST(root.left, val);
    return root;
}

#pragma mark - 在 BST 中删除一个数
//************************* 在 BST 中删除一个数 *************************
/**
 注意一下，这个删除操作并不完美，因为我们一般不会通过 root.val = minNode.val 修改节点内部的值来交换节点，而是通过一系列略微复杂的链表操作交换 root 和 minNode 两个节点。
 因为具体应用中，val 域可能会是一个复杂的数据结构，修改起来非常麻烦；而链表操作无非改一改指针，而不会去碰内部数据。
 */
BTNode *deleteNodeInBST(BTNode * root, int key) {
    if (root == NULL) return NULL;
    if (root.data == key) {
        // 找到了。删除节点的同时不能破坏 BST 的性质。有三种情况
        // 1 恰好是末端节点，两个子节点都为空，那么它可以当场去世了。
        // 2 只有一个非空子节点，那么它要让这个孩子接替自己的位置
        // 3 有两个子节点，麻烦了，为了不破坏 BST 的性质，A 必须找到左子树中最大的那个节点，或者右子树中最小的那个节点来接替自己。我们以第二种方式讲解。
        
        // 这两个 if 把情况 1 和 2 都正确处理了
        if (root.left == NULL) return root.right;
        if (root.right == NULL) return root.left;
        
        // 处理情况 3
        BTNode *minNode = getRightMin(root.right);
        root.data = minNode.data; //把root.data 直接替换成minNode的值
        // 下一步就是删除那个minNode
        root.right = deleteNodeInBST(root.right, minNode.data);
    } else if (root.data > key) {
        // 去左子树中
        root.left = deleteNodeInBST(root.left, key);
    } else if (root.data < key) {
        // 去右子树中
        root.right = deleteNodeInBST(root.right, key);
    }
    return root;
}
BTNode *getRightMin(BTNode * node) {
    // BST 最左边的就是最小的
    while (node.left != NULL) node = node.left;
    return node;
}

#pragma mark - 222. 完全二叉树的节点个数¥¥
//************************* 222. 完全二叉树的节点个数¥ *************************
/**
 222. 完全二叉树的节点个数
 难度 中等
 https://leetcode-cn.com/problems/count-complete-tree-nodes/
 给出一个完全二叉树，求出该树的节点个数。
 */
// 如果是一个普通二叉树，显然只要向下面这样遍历一边即可，时间复杂度 O(N)
int countNodes(BTNode *root) {
    if (root == NULL) return 0;
    return 1 + countNodes(root.left) + countNodes(root.right);
}
// 那如果是一棵满二叉树，节点总数就和树的高度呈指数关系：
int countNodes1(BTNode * root) {
    int h = 0;
    // 计算树的高度
    while (root != NULL) {
        root = root.left;
        h++;
    }
    // 节点总数就是 2^h - 1
    return (int)pow(2, h) - 1;
}
// 完全二叉树比普通二叉树特殊，但又没有满二叉树那么特殊，计算它的节点总数，
// 可以说是普通二叉树和完全二叉树的结合版，先看代码：
// 算法的递归深度就是树的高度 O(logN)，每次递归所花费的时间就是 while 循环，需要 O(logN)，所以总体的时间复杂度是 O(logN*logN)。
int countNodes2(BTNode * root) {
    BTNode * l = root, *r = root;
    // 记录左、右子树的高度
    int hl = 0, hr = 0;
    while (l != NULL) { // (logN)
        l = l.left;
        hl++;
    }
    while (r != NULL) { // (logN)
        r = r.right;
        hr++;
    }
    // 如果左右子树的高度相同，则是一棵满二叉树
    if (hl == hr) {
        // 完全二叉树也有一部分是满二叉树，一定会来到这里。
        return (int)pow(2, hl) - 1;
    }
    // 如果左右高度不同，则按照普通二叉树的逻辑计算
    // 这两个递归只有一个会真的递归下去，另一个一定会触发 hl == hr 而立即返回，不会递归下去。
    // 因为完全二叉树有一半是满二叉树，一定会触发hl == hr 然乎就返回了。
    // 消耗 O(logN) 的复杂度而不会继续递归。
    // 算法的递归深度就是树的高度 O(logN)，每次递归所花费的时间就是 while 循环，需要 O(logN)，所以总体的时间复杂度是 O(logN*logN)。
    return 1 + countNodes2(root.left) + countNodes2(root.right);
}

#pragma mark - 110. 平衡二叉树 ¥
//************************* 110. 平衡二叉树 ¥ *************************
/**
 110. 平衡二叉树 ¥
 难度 简单
 链接：https://leetcode-cn.com/problems/balanced-binary-tree/
 给定一个二叉树，判断它是否是高度平衡的二叉树。

 本题中，一棵高度平衡二叉树定义为：一个二叉树每个节点 的左右两个子树的高度差的绝对值不超过 1
 
 自底向上递归的做法类似于后序遍历，对于当前遍历到的节点，先递归地判断其左右子树是否平衡，再判断以当前节点为根的子树是否平衡。如果一棵子树是平衡的，则返回其高度（高度一定是非负整数），否则返回−1。如果存在一棵子树不平衡，则整个二叉树一定不平衡。

 时间复杂度：O(n)，其中n 是二叉树中的节点个数。使用自底向上的递归，每个节点的计算高度和判断是否平衡都只需要处理一次，
 最坏情况下需要遍历二叉树中的所有节点，因此时间复杂度是O(n)。
 空间复杂度：O(n)，其中n 是二叉树中的节点个数。空间复杂度主要取决于递归调用的层数，递归调用的层数不会超过
 n。
 */
int height(BTNode* root) {
    if (root == NULL) {
        return 0;
    }
    int leftHeight = height(root.left);
    int rightHeight = height(root.right);
    if (leftHeight == -1 || rightHeight == -1 || abs(leftHeight - rightHeight) > 1) {
        return -1;
    } else {
        return max(leftHeight, rightHeight) + 1;
    }
}
bool isBalanced(BTNode* root) {
    return height(root) >= 0;
}







@end

//
//  BinarySearchTree.c
//  二叉搜索树
//
//  Created by 王启正 on 2019/9/17.
//  Copyright © 2019 58. All rights reserved.
//

#include "BinarySearchTree.h"

static int count=0;//节点个数
BinarySearchNode *root=NULL;//根节点
//前序遍历
void print_preorder(BinarySearchNode *node);
//中序遍历
void print_inorder(BinarySearchNode *node);
//后序遍历
void print_backorder(BinarySearchNode *node);
//层序遍历
void print_levelorder(BinarySearchNode *node);

void add(int ele){
    if (!root) {
        root = (BinarySearchNode *)malloc(sizeof(BinarySearchNode));
        root->data=ele;
        root->parent=NULL;
        root->left=NULL;
        root->right=NULL;
        count++;
        return;
    }
    BinarySearchNode *parent_node=root;
    BinarySearchNode *node=root;
    int cmp=0;
    while (node!=NULL) {
        cmp=compare(node->data, ele);
        if (cmp<0) {
            //父节点指针随之跟着变换
            parent_node=node;
            //ele大于node->data，所以在右子树中找。直到node为null时，
            //说明找到了右子树中最大的那个node, 那么此时node的父节点就被定位了。
            //后面直接父节点->right=新节点
            node=parent_node->right;
        }else if (cmp>0){
            //父节点指针随之跟着变换
            parent_node=node;
            //ele小于node->data，所以在左子树中找
            node=parent_node->left;
        }else{
            //相等
            printf("重复添加了：%d",ele);
            return;
        }
    }
    
    BinarySearchNode *new_node=(BinarySearchNode *)malloc(sizeof(BinarySearchNode));
    new_node->data=ele;
    new_node->left=NULL;
    new_node->right=NULL;
    if (cmp<0) {
        parent_node->right=new_node;
    }else{
        parent_node->left=new_node;
    }
    count++;
}
void delete_ele(int ele){
    
}
void clearTree(void){
    
}
bool contains(int ele){
    
    return 0;
}

int size_of_tree(void){
    return count;
}
bool is_empty(void){
    return count==0;
}
int compare(int current, int next){
    return current-next;//返回负数放右侧，返回正数放左侧。返回0直接替换。
}
void print_tree_preorder(void){
    printf("***前序遍历如下：***\n");
    print_preorder(root);
}
void print_tree_inorder(void){
    printf("***中序遍历如下：***\n");
    print_inorder(root);
}
void print_tree_backorder(void){
    printf("***后序遍历如下：***\n");
    print_backorder(root);
}
void print_tree_levelorder(void){
    printf("***层序遍历如下：***\n");
    print_levelorder(root);
}
void print_preorder(BinarySearchNode *node){
    if (node==NULL) return;
    printf("%d\n",node->data);
    print_preorder(node->left);
    print_preorder(node->right);
}
void print_inorder(BinarySearchNode *node){
    if (node==NULL) return;
    print_inorder(node->left);
    printf("%d\n",node->data);
    print_inorder(node->right);
}
void print_backorder(BinarySearchNode *node){
    if (node==NULL) return;
    print_backorder(node->left);
    print_backorder(node->right);
    printf("%d\n",node->data);
}
void print_backorder_1(BinarySearchNode *node){
    BinarySearchNode *stack[100];
    BinarySearchNode *current=node;
    int i=0;
    stack[i++]=node;
    int length=sizeof(stack)/sizeof(BinarySearchNode *);
    while (length != 0) {
        BinarySearchNode *node=stack[i--];
        if (node->right) {
            stack[i++]=node->right;
        }else if (node->left){
            stack[i++]=node->left;
        }else{
            printf("%d \n",node->data);
            node=stack[i--];
        }
    }
}
void print_levelorder(BinarySearchNode *node){
//    if (node==NULL) return;
//    enQueue(node->data);
//    while (!isEmpty()) {
//        DoubleLink delete_node=NULL;
//
//        int data=deQueue();
//        printf("%d\n",data);
//        if (node->left != NULL) {
//            enQueue(node->left->data);
//        }
//        if (node->right != NULL) {
//            enQueue(node->right->data);
//        }
//    }
}
BinarySearchNode* getNode(int ele){
    if (!root) return NULL;
    BinarySearchNode *node = root;
    while (node->data != ele) {
        int cmp=compare(node->data, ele);
        if (cmp < 0) {
            node=node->right;
            if (!node) break;
        }else if (cmp >0){
            node=node->left;
            if (!node) break;;
        }else{
            break;
        }
    }
    return node;
}


/**
 《二叉搜索树的最近公共祖先》
 算法思想：
 1、从根节点开始遍历；
 2、如果当前节点的值大于p和q的值，说明p和q应该在当前节点的左子树，因此将当前节点移动到它的左子节点
 3、如果当前节点的值小于p和q的值，说明p和q应该在当前节点的右子树，因此将当前节点移动到它的右子节点
 4、如果当前节点的值不满足上述两条要求，那么说明当前节点就是「分岔点」。此时p和q要么在当前节点的不同的子树中，要么其中一个就是当前节点。
 
 链接：https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/solution/er-cha-sou-suo-shu-de-zui-jin-gong-gong-zu-xian-26/
 来源：力扣（LeetCode）
 */
BinarySearchNode* lowestCommonAncestor(BinarySearchNode* root,
                                       BinarySearchNode* p,
                                       BinarySearchNode* q) {
    BinarySearchNode *ancestor=root;
    while (true){
        if(p->data<ancestor->data && q->data<ancestor->data){
            //当前节点的值大于p和q的值，说明p和q应该在当前节点的左子树
            ancestor=ancestor->left;
        }else if(p->data>ancestor->data && q->data>ancestor->data){
            //当前节点的值小于p和q的值，说明p和q应该在当前节点的右子树
            ancestor=ancestor->right;
        }else{
            //当前节点的值不满足上述两条要求，那么说明当前节点就是「分岔点」
            break;
        }
    }
    return ancestor;
}


/**
 《填充每个节点的下一个右侧节点指针》
 
 思路算法：
 这道题希望我们把二叉树各个层的点组织成链表，一个非常直观的思路是层次遍历。树的层次遍历基于广度优先搜索，它按照层的顺序遍历二叉树，在遍历第i层前，一定会遍历完第i−1层。
 
 初始化一个队列q，将根结点放入队列中。当队列不为空的时候，记录当前队列大小为n，从队列中以此取出n 个元素并通过这n个元素拓展新节点。如此循环，直到队列为空。
 这样做可以保证每次遍历的n 个点都是同一层的。我们可以在遍历每一层的时候修改这一层节点的next指针，
 这样就可以把每一层都组织成链表。
 
 记树上的点的个数为N。

 时间复杂度：O(N)。我们需要遍历这棵树上所有的点，时间复杂度为O(N)。
 空间复杂度：O(N)。即队列的空间代价。

 链接：https://leetcode-cn.com/problems/populating-next-right-pointers-in-each-node-ii/solution/tian-chong-mei-ge-jie-dian-de-xia-yi-ge-you-ce-15/
 来源：力扣（LeetCode）
 */
struct Node0 * connects(struct Node0 *root) {
    if (!root) {
        return NULL;
    }
    // 以数组当做队列
    struct Node0* q[10001];
    int left = 0, right = 0;
    q[right++] = root; //根节点是对头先入队列。
    while (left < right) {
        int n = right - left;
        struct Node0 *last = NULL;
        for (int i = 1; i <= n; ++i) {
            struct Node0 *f = q[left++]; //取出最前面的node
            if (f->left) {
                q[right++] = f->left; //左子树入队
            }
            if (f->right) {
                q[right++] = f->right; //右子树入队
            }
            if (i != 1) {
                last->next = f;
            }
            last = f;
        }
    }
    return root;
}




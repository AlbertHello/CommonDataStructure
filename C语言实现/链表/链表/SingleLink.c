//
//  SingleLink.c
//  链表
//
//  Created by 58 on 2019/8/18.
//  Copyright © 2019 58. All rights reserved.
//

#include "SingleLink.h"

//1、初始化一个链表
Status init_link(Link *head){
    (*head)=(Link)malloc(sizeof(struct Node));
    if (head) {
        (*head)->data=0;
        (*head)->next=NULL;
        g_size=0;
        return Success;
    }else{
        return Error;
    }
}

//2、增加一个元素
int insert_element(Element elem,Link head){
    insert_element_at_index(elem,g_size, head);
    return Success;
}
bool is_empty(Link head){
    return (head->next == NULL);
}

Status insert_element_at_index(Element elem, int index, Link head){
    if (boundary_check(index)) return Error;
    //头结点
    Link head_node=head->next;
    //新节点
    struct Node * new_node=(struct Node *)malloc(sizeof(struct Node));
    if (index==0) {//插入到最前面
        new_node->data=elem;//新节点赋值
        new_node->next=head_node;//设置新节点->头结点
        head->next=new_node;//头指针指向这个新节点，那么这个新节点就成了新的头结点。
    }else{//插入到其他位置
        struct Node *pre_node;
        node_of_index(index-1, head, &pre_node);//获取要插入点的前一个节点pre_node
        new_node->next=pre_node->next;//新节点下一个节点是pre_node的下一个节点。
        new_node->data=elem;//新节点赋值
        pre_node->next=new_node;//pre_node的下一个节点修改为这个新节点
    }
    g_size++;
    printf("insert one node at index=%d,size=%d\n",index,g_size);
    return Success;
}

//3、删除一个元素
Status delete_element(int index,Element *data,Link head){
    struct Node *pre_node;
    struct Node *delete_node;
    node_of_index(index-1, head, &pre_node);
    delete_node=pre_node->next;
    Element delete_data=delete_node->data;
    pre_node->next=pre_node->next->next;
    *data=delete_data;
    free(delete_node);
    printf("delete one node,index=%d.size=%d\n",index,g_size);
    g_size--;

    return Success;
}
//4、修改一个元素
Status update_ele(int index, Element ele, Link head){

    struct Node *node;
    node_of_index(index, head, &node);
    node->data=ele;
    return Success;
}
//5、获取链表长度
int get_link_length(){
    return g_size;
}
//6、根据下标index查找元素Element
Status node_of_index(int index, Link head, struct Node** node){
    //    if (boundary_check(index)) return struct NULL;
    (*node) = head->next;//此时node表示头结点
    int i=0;
    while ((*node) && i<index) {
        (*node)= (*node)->next;
        i++;
    }
    return Success;
}
//7、根据元素Element查找下标index
int locate_ele_with_element(Element ele, Link head){
    int index=-1;
    struct Node*node=head->next;
    for (int i=0; i<g_size; i++) {
        if ((node->data == ele) && node) {
            index=i;
            break;
        }
        node=node->next;
    }
    return index;
}
//8、清空链表
Status clearLink(Link head){
    Link head_node=head->next;
    while (head_node) {
        Link temp=head_node;
        head_node=head_node->next;
        printf("删除%d\n",temp->data);
        free(temp);
        g_size--;
    }
    head->next=NULL;
    g_size =0;
    return Success;
}
//9、检查是否越界
bool boundary_check(int index){
    if (index<0 || index>g_size) {
        printf("index out of bounds \n");
        return true;
    }else{
        return false;
    }
}
//10、打印链表
void printLink(Link link){
    int i=0;
    struct Node *node=link->next;
    while (node) {
        printf("第%d个节点：data=%d, next=%p\n",i,node->data,node->next);
        node=node->next;
        i++;
    }
    printf("size=%d\n",g_size);
}

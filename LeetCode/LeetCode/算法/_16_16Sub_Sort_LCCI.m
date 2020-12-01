//
//  _16_16Sub_Sort_LCCI.m
//  LeetCode
//
//  Created by 58 on 2020/11/30.
//

#import "_16_16Sub_Sort_LCCI.h"

@implementation _16_16Sub_Sort_LCCI

/**
 面试题 16.16. 部分排序
 给定一个整数数组，编写一个函数，找出索引m和n，只要将索引区间[m,n]的元素排好序，整个数组就是有序的。注意：n-m尽量最小，也就是说，找出符合条件的最短序列。函数返回值为[m,n]，若不存在这样的m和n（例如整个数组是有序的），请返回[-1,-1]。

 示例：
 输入： [1,2,4,7,10,11,7,12,6,7,16,18,19]
 输出： [3,9]
 https://leetcode-cn.com/problems/sub-sort-lcci/
 
 */

/**
 思路：
 1 从左往右比较，设置一个最大元素max，依次和max比较，找到一个逆序对就记录下标。同时要更新max值，
 到最后最右边的逆序对就能定位到。
 2 从右往左比较，设置一个最小值min，其他同理。
 时间复杂度：O（n）。 数组元素个数。便利两次。因该是n+n=2n，其实也是O（n）。
 空间复杂度：O（1）。新建了一个两个元素的数组
 */
int* subSort(int* array, int arraySize, int* returnSize){
    if (arraySize == 0){
        int *res=(int *)malloc(sizeof(int)*2);
        res[0]=-1;
        res[1]=-1;
        *returnSize=2;
        return res;
    }
    // 从左扫描到右寻找逆序对（正序：逐渐变大）
    int max = array[0];
    // 用来记录最右的那个逆序对位置
    int r = -1;
    for (int i = 1; i < arraySize; i++) {
        if (array[i] >= max) {
            max = array[i];
        } else {
            r = i;
        }
    }
    // 提前结束
    if (r == -1) {
        int *res=(int *)malloc(sizeof(int)*2);
        res[0]=-1;
        res[1]=-1;
        *returnSize=2;
        return res;
    }
    
    // 从右扫描到左寻找逆序对（正序：逐渐变小）
    int min = array[arraySize - 1];
    // 用来记录最左的那个逆序对位置
    int l = -1;
    for (int i = arraySize - 2; i >= 0; i--) {
        if (array[i] <= min) {
            min = array[i];
        } else {
            l = i;
        }
    }
    int *res=(int *)malloc(sizeof(int)*2);
    res[0]=l;
    res[1]=r;
    *returnSize=2;
    return res;
}
//int* subSort2(int* array, int arraySize, int* returnSize){
//    if (arraySize == 0){
//        int *res=(int *)malloc(sizeof(int)*2);
//        res[0]=-1;
//        res[1]=-1;
//        *returnSize=2;
//        return res;
//    }
//    int left=-1;
//    for (int i = 0; i < arraySize-1; i++) {
//        if (array[i] > array[i+1]) {
//            left=i;
//            break;
//        }
//    }
//    int right=-1;
//    for (int i = arraySize-1; i > 0; i--) {
//        if (array[i] < array[i-1]) {
//            right=i;
//            break;
//        }
//    }
//    int *res=(int *)malloc(sizeof(int)*2);
//    res[0]=left;
//    res[1]=right;
//    *returnSize=2;
//    return res;
//}
+(void)subSortTest{
    int num[]={-796,-795,-791,-790,-790,-789,-787,-783,-782,-781,-778,-778,-771,-769,-766,-764,-763,-762,-760,-757,-754,-751,-750,-750,-738,-735,-735,-732,-731,-729,-728,-725,-723,-721,-719,-713,-713,-711,-707,-704,-702,-700,-699,-697,-697,-696,-696,-696,-696,-695,-695,-690,-690,-689,-688,-688,-688,-687,-685,-685,-683,-682,-680,-679,-679,-677,-677,-675,-674,-673,-665,-664,-662,-660,-659,-655,-654,-654,-654,-652,-652,-651,-650,-650,-644,-643,-641,-641,-639,-639,-639,-638,-637,-637,-637,-628,-625,-621,-615,-611,-608,-605,-601,-600,-594,-594,-592,-589,-587,-582,-582,-581,-579,-579,-578,-577,-574,-570,-569,-568,-566,-566,-565,-560,-555,-552,-547,-540,-538,-535,-535,-535,-534,-534,-530,-529,-528,-526,-522,-520,-520,-519,-512,-509,-508,-506,-505,-505,-502,-502,-497,-490,-489,-488,-481,-481,-474,-474,-473,-472,-471,-470,-468,-467,-466,-465,-463,-460,-457,-456,-455,-451,-451,-450,-450,-449,-448,-448,-447,-446,-443,-440,-438,-438,-435,-434,-433,-424,-422,-416,-415,-412,-411,-410,-408,-407,-407,-406,-404,-402,-395,-391,-390,-390,-385,-383,-379,-379,-379,-373,-372,-367,-361,-360,-353,-344,-343,-343,-339,-338,-336,-333,-332,-332,-332,-330,-329,-328,-326,-324,-319,-317,-317,-311,-311,-305,-305,-302,-302,-302,-301,-298,-298,-296,-293,-292,-290,-290,-289,-285,-284,-282,-280,-277,-277,-273,-272,-271,-266,-264,-262,-254,-251,-250,-248,-246,-244,-241,-240,-239,-237,-237,-235,-233,-229,-220,-220,-216,-214,-212,-211,-209,-207,-205,-199,-199,-198,-196,-196,-195,-194,-194,-193,-192,-191,-185,-185,-185,-182,-182,-179,-172,-170,-167,-162,-161,-160,-156,-155,-155,-153,-152,-150,-148,-147,-141,-140,-139,-138,-134,-134,-130,-127,-127,-124,-122,-116,-115,-112,-104,-101,-100,-99,-98,-96,-96,-92,-92,-87,-84,-84,-79,-77,-75,-75,-73,-71,-70,-67,-66,-65,-61,-61,-60,-59,-59,-59,-58,-58,-55,-54,-51,-50,-43,-42,-40,-37,-35,-33,-32,-29,-28,-27,-26,-23,-21,-20,-18,-14,-11,-6,-4,-3,-1,2,3,7,8,8,9,9,11,19,21,29,29,31,31,32,33,36,38,43,48,48,50,50,51,52,61,62,66,67,69,70,71,78,79,82,82,83,83,84,89,89,92,92,93,93,96,96,98,98,99,99,103,107,109,112,119,120,121,122,123,125,125,130,147,148,151,153,154,154,156,156,158,160,162,164,166,167,170,175,176,177,177,179,182,184,185,188,190,191,192,194,195,198,198,201,203,204,205,207,208,209,210,216,217,218,219,222,227,227,231,231,232,243,245,248,249,257,257,260,261,263,264,267,270,273,275,282,289,298,299,299,299,300,302,303,303,307,308,309,310,310,311,312,313,313,318,318,319,320,321,327,328,328,329,335,336,339,340,342,342,343,344,346,347,349,352,358,360,361,363,363,366,367,369,369,371,371,372,376,378,378,378,379,379,380,383,384,385,392,394,395,395,397,397,397,400,402,405,411,414,415,415,416,421,424,426,427,428,430,431,435,437,438,440,441,447,448,448,449,449,449,451,453,453,458,459,459,461,466,467,470,477,479,482,483,485,485,486,487,494,498,504,504,508,508,510,510,510,511,512,514,517,518,525,526,527,527,527,528,528,529,531,536,537,539,539,540,545,546,546,547,549,549,551,551,553,554,554,558,560,560,602,773,791,662,789,642,598,643,781,626,666,633,668,715,576,752,632,637,579,626,768,638,677,652,685,626,724,619,578,567,637,766,765,684,563,690,785,747,596,686,653,642,696,639,647,641,698,747,710,617,642,595,730,566,595,582,596,723,775,574,767,750,678,767,598,738,761,715,692,683,651,779,627,726,627,688,639,563,704,636,717,755,783,661,680,748,656,763,683,675,604,637,631,679,598,642,710,723,686,697,781,605,588,771,744,737,608,686,757,687,778,659,753,666,778,578,757,762,745,718,751,579,585,748,589,575,662,598,665,629,794,797};
    
    int returnSize=0;
    int *newNum=subSort(num, sizeof(num)/sizeof(int), &returnSize);
    printf("%d %d",newNum[0], newNum[1]);
}












@end

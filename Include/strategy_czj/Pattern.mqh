//+------------------------------------------------------------------+
//|                                                      Pattern.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
enum ENUM_BULL_BEAR
  {
   BULL,
   BEAR,
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PatternRecognizeFibonacci
  {
public:
   double            max_price;
   double            min_price;
   double            price_range;
   int               bar_num;
   ENUM_BULL_BEAR    bull_or_bear;

   bool              pattern_valid;
   int               pattern_life;
   bool              pattern_used;
                     PatternRecognizeFibonacci(void);

   int               pattern_life_max;
   virtual void      pattern_detect(const double &array_for_max[],const double &array_for_min[],const int bar_num_max,const double price_range_min);//模式检测
   virtual void      pattern_detect(const int zig_zag_handle,const int num_zigzag,const int num_extreme,const int bar_num_max,const double price_range_min);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PatternRecognizeFibonacci::pattern_detect(const double &array_for_max[],const double &array_for_min[],const int bar_num_max,const double price_range_min)
  {
//计算给定数据下的模式基本数据
   int max_loc,min_loc;
   int new_bar_num;
   double new_max_price,new_min_price,new_price_range;
   ENUM_BULL_BEAR new_bull_or_bear;

   max_loc=ArrayMaximum(array_for_max);
   min_loc=ArrayMinimum(array_for_min);
   new_max_price=array_for_max[max_loc];
//new_min_price=array_for_min[min_loc];
   new_min_price=array_for_max[min_loc];
   new_price_range=new_max_price-new_min_price;
   new_bar_num=MathAbs(max_loc-min_loc);
   new_bull_or_bear=(max_loc>min_loc)?BULL:BEAR;

//判断模式是否存在
   if(new_bar_num>bar_num_max||new_price_range<price_range_min||new_price_range>5*price_range_min)
     {
      pattern_life++;
      if(pattern_life>pattern_life_max) pattern_valid=false;
      return;
     }

//判断模式是否与之前的一致
   bool pattern_is_same=(new_max_price==max_price && new_min_price==min_price);

   if(pattern_is_same)//相同模式的处理
     {
      pattern_life++;
      if(pattern_life>pattern_life_max) pattern_valid=false;
     }
   else//新模式的处理
     {
      max_price=new_max_price;
      min_price=new_min_price;
      price_range=new_price_range;
      bar_num=new_bar_num;
      bull_or_bear=new_bull_or_bear;
      pattern_valid=true;
      pattern_life=0;
      pattern_used=false;
     }
  }
//+------------------------------------------------------------------+
//|           使用zigzag来辅助进行上涨和下跌行情判断                 |
//+------------------------------------------------------------------+
void PatternRecognizeFibonacci::pattern_detect(const int zig_zag_handle,const int num_zigzag,const int num_extreme,const int bar_num_max,const double price_range_min)
  {
   double zigzag_values[], extreme_values[],  extreme_range[];
   int index_values[],bar_range[];
   int counter=0;
   ArrayResize(zigzag_values,num_zigzag);
   CopyBuffer(zig_zag_handle,0,0,num_zigzag,zigzag_values);
   for(int i=num_zigzag-1;i>=0;i--)
     {
      if(zigzag_values[i]==0) continue;
      if(counter==num_extreme) break;
      counter++;
      ArrayResize(extreme_values,counter);
      ArrayResize(index_values,counter);
      extreme_values[counter-1]=zigzag_values[i];
      index_values[counter-1]=i;
      if(counter<=1) continue;
      ArrayResize(extreme_range,counter-1);
      ArrayResize(bar_range,counter-1);
      extreme_range[counter-2]=zigzag_values[counter-2]-zigzag_values[counter-1];
      bar_range[counter-2]=index_values[counter-2]-index_values[counter-1];
     }
     
   int new_bar_num;
   double new_max_price,new_min_price,new_price_range;
   ENUM_BULL_BEAR new_bull_or_bear;
   
   int max_range_up_loc=ArrayMaximum(extreme_range);  //涨幅最大位置
   int max_range_down_loc=ArrayMinimum(extreme_range);//跌幅最大位置
   double max_range_down=extreme_range[max_range_down_loc];//最大涨幅
   double max_range_up=extreme_range[max_range_up_loc];//最大跌幅
   if(MathAbs(max_range_up)>MathAbs(max_range_down))
      {
       new_bull_or_bear=BULL;
       new_bar_num=bar_range[max_range_up_loc];
       new_max_price=extreme_values[max_range_up_loc];
       new_min_price=extreme_values[max_range_up_loc+1];
      }
   else
      {
       new_bull_or_bear=BEAR;
       new_bar_num=bar_range[max_range_down_loc];
       new_max_price=extreme_values[max_range_down_loc+1];
       new_min_price=extreme_values[max_range_down_loc];
      }
   new_price_range=new_max_price-new_min_price;
   if(new_bar_num>bar_num_max||new_price_range<price_range_min||new_price_range>5*price_range_min)
    {
      pattern_life++;
      if(pattern_life>pattern_life_max) pattern_valid=false;
      return;
     }
   
   
   //判断模式是否与之前的一致
   bool pattern_is_same=(new_max_price==max_price && new_min_price==min_price);

   if(pattern_is_same)//相同模式的处理
     {
      pattern_life++;
      if(pattern_life>pattern_life_max) pattern_valid=false;
     }
   else//新模式的处理
     {
      max_price=new_max_price;
      min_price=new_min_price;
      price_range=new_price_range;
      bar_num=new_bar_num;
      bull_or_bear=new_bull_or_bear;
      pattern_valid=true;
      pattern_life=0;
      pattern_used=false;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PatternRecognizeFibonacci::PatternRecognizeFibonacci(void)
  {
   max_price=0;
   min_price=0;
   price_range=0;
   bar_num=0;
   bull_or_bear=BULL;
   pattern_valid=false;
   pattern_life=0;
   pattern_used=false;
   pattern_life_max=600;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                               Cointergration.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include "RiBuffStat.mqh"
#include <Math\Stat\Normal.mqh>
//+------------------------------------------------------------------+
//|                   枚举计算协整关系的类型                         |
//+------------------------------------------------------------------+
enum CointergrationCalType
  {
   ENUM_COINTERGRATION_TYPE_PLUS=1,
   ENUM_COINTERGRATION_TYPE_MINUS=2,
   ENUM_COINTERGRATION_TYPE_MULTIPLY=3,
   ENUM_COINTERGARTION_TYPE_DIVIDE=4,
   ENUM_COINTERGRATION_TYPE_LINEAR_FIXED=5,
   ENUM_COINTERGRATION_TYPE_LINEAR_FREE=6,
   ENUM_COINTERGRATION_TYPE_GARCH=7
  };
//+------------------------------------------------------------------+
//|      枚举相关关系类型(正相关/负相关)                             |
//+------------------------------------------------------------------+
enum RelationType
  {
   ENUM_RELATION_TYPE_POSITIVE=1,
   ENUM_RELATION_TYPE_NEGATIVE=-1
  };
//+------------------------------------------------------------------+
//|    枚举用于计算入场分位数的指标类型                              |
//+------------------------------------------------------------------+
enum PValueType
  {
   ENUM_PVALUE_TYPE_ORIGIN=11,
   ENUM_PVALUE_TYPE_BIAS=12
  };
//+------------------------------------------------------------------+
//|            协整关系处理类                                        |
//+------------------------------------------------------------------+
class CCointergration
  {
private:
   int               buffer_max;
   CRiBuffDbl        ts_x;
   CRiBuffDbl        ts_y;
   CRiBuffStats      ts_x_y;
   CointergrationCalType coin_type;
   PValueType        type_p;
   RelationType   type_relation;
protected:
   void              JudgeRelationType(void);
   void              AddValueTsXY(double x_value,double y_value,CRiBuffStats &x_y_buffer);

public:
                     CCointergration(void);//无参构造函数
   void              SetParameters(int max_buffer_num,CointergrationCalType type_coin,PValueType p_type);//设置参数
                    ~CCointergration(void){};//析构函数
   void              AddValue(double x_value,double y_value);//协整序列添加新值
   double            CDF(double x_value,double y_value);//给定值在协整序列中的累积概率分布结果
   RelationType   GetRelation(void){return type_relation;}//返回相关类型
   bool Valid(void);//判断当前协整序列是否有效(达到缓存最大数)
  };
//+------------------------------------------------------------------+
//|                默认构造函数                                      |
//+------------------------------------------------------------------+
CCointergration::CCointergration(void)
  {
   //buffer_max=1000;
   //ts_x.SetMaxTotal(buffer_max);
   //ts_y.SetMaxTotal(buffer_max);
   //ts_x_y.SetMaxTotal(buffer_max);
   //coin_type=ENUM_COINTERGRATION_TYPE_PLUS;
   //JudgeRelationType();
  }
//+------------------------------------------------------------------+
//|               参数设置                                           |
//+------------------------------------------------------------------+
void CCointergration::SetParameters(int max_buffer_num,CointergrationCalType type_coin,PValueType p_type)
  {
   buffer_max=max_buffer_num;
   ts_x.SetMaxTotal(buffer_max);
   ts_y.SetMaxTotal(buffer_max);
   ts_x_y.SetMaxTotal(buffer_max);
   coin_type=type_coin;
   type_p=p_type;
   JudgeRelationType();
  }
void  CCointergration::JudgeRelationType(void)
   {
    switch(coin_type)
     {
      case ENUM_COINTERGRATION_TYPE_PLUS: type_relation=ENUM_RELATION_TYPE_NEGATIVE; break;
      case ENUM_COINTERGRATION_TYPE_MULTIPLY: type_relation=ENUM_RELATION_TYPE_NEGATIVE; break;
      case ENUM_COINTERGRATION_TYPE_MINUS: type_relation=ENUM_RELATION_TYPE_POSITIVE; break;
      case ENUM_COINTERGARTION_TYPE_DIVIDE:type_relation=ENUM_RELATION_TYPE_POSITIVE; break;
      default:Print("Cointergration type not defined! Use plus method instead!");type_relation=ENUM_RELATION_TYPE_NEGATIVE; break;
     }
   }
//+------------------------------------------------------------------+
//|               协整序列缓存增加新的值                             |
//+------------------------------------------------------------------+
void CCointergration::AddValue(double x_value,double y_value)
  {
   ts_x.AddValue(x_value);
   ts_y.AddValue(y_value);
   AddValueTsXY(x_value,y_value,ts_x_y);
  }
//+------------------------------------------------------------------+
//|    往给定的缓存中添加新值(根据类定义的协整序列计算方法)          |
//+------------------------------------------------------------------+
void CCointergration::AddValueTsXY(double x_value,double y_value,CRiBuffStats &x_y_buffer)
  {
   switch(coin_type)
     {
      case ENUM_COINTERGRATION_TYPE_PLUS: x_y_buffer.AddValue(x_value+y_value); break;
      case ENUM_COINTERGRATION_TYPE_MULTIPLY: x_y_buffer.AddValue(x_value*y_value); break;
      case ENUM_COINTERGRATION_TYPE_MINUS: x_y_buffer.AddValue(x_value-y_value);break;
      case ENUM_COINTERGARTION_TYPE_DIVIDE:x_y_buffer.AddValue(x_value/y_value);break;
      default:Print("Cointergration type not defined! Use plus method instead!");x_y_buffer.AddValue(x_value+y_value);break;
     }
  }
//+------------------------------------------------------------------+
//|               根据给定的新值计算当前的分位数                     |
//+------------------------------------------------------------------+
double CCointergration::CDF(double x_value,double y_value)
  {
   CRiBuffStats ts_x_y_check(ts_x_y);
   AddValueTsXY(x_value,y_value,ts_x_y_check);
   double cdf;
   int error_code;
   switch(type_p)
     {
      case ENUM_PVALUE_TYPE_ORIGIN:
         cdf=MathCumulativeDistributionNormal(ts_x_y_check.GetValue(ts_x_y_check.GetTotal()-1),ts_x_y.Mu(),ts_x_y.Sigma(),error_code);
         break;
      default:
         Print("indicator type not defined! Use Origin time series intead!");
         cdf=MathCumulativeDistributionNormal(ts_x_y_check.GetValue(ts_x_y_check.GetTotal()-1),ts_x_y.Mu(),ts_x_y.Sigma(),error_code);
         break;
     }
   return cdf;
  }
bool CCointergration::Valid(void)
   {
    return(ts_x_y.GetMaxTotal()==ts_x_y.GetTotal());
   }
//+------------------------------------------------------------------+

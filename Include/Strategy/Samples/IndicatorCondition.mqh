//+------------------------------------------------------------------+
//|                                           IndicatorCondition.mqh |
//|                                      Copyright 2017,Daixiaorong. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017,Daixiaorong."
#property link      "https://www.mql5.com"
#include <Object.mqh>
#include <Strategy\PositionMT5.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CIndicatorCondition:public CObject
  {
protected:
   int               m_long_in_pattern;
   int               m_long_out_pattern;
   int               m_short_in_pattern;
   int               m_short_out_pattern;
public:
                     CIndicatorCondition(void);
                    ~CIndicatorCondition(void);
   void              SetPattern(const int LongInPattern,const int LongOutPattern,
                                const int ShortInPattern,const int ShortOutPattern);
   virtual void      RefreshState() {return;}     //更新各类指标对象
   virtual bool      LongInCondition(){return false;}
   virtual bool      LongOutCondition(CPosition *pos){return false;}
   virtual bool      ShortInCondition(){return false;}
   virtual bool      ShortOutCondition(CPosition *pos){return false;}
   int               LongInPattern(void) {return m_long_in_pattern;}
   int               LongOutPattern(void){return m_long_out_pattern;}
   int               ShortInPattern(void) {return m_short_in_pattern;}
   int               ShortOutPattern(void) {return m_short_out_pattern;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CIndicatorCondition::CIndicatorCondition(void)
  {
   m_long_in_pattern=1;
   m_long_out_pattern=1;
   m_short_in_pattern=1;
   m_short_out_pattern=1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CIndicatorCondition::~CIndicatorCondition(void)
  {

  }
//+------------------------------------------------------------------+
//|设置进场的模式                                                                  |
//+------------------------------------------------------------------+
CIndicatorCondition::SetPattern(const int LongInPattern,const int LongOutPattern,
                                const int ShortInPattern,const int ShortOutPattern)
  {
   m_long_in_pattern=LongInPattern;
   m_long_out_pattern=LongOutPattern;
   m_short_in_pattern=ShortInPattern;
   m_short_out_pattern=ShortOutPattern;
  }

//+------------------------------------------------------------------+

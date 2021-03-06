//+------------------------------------------------------------------+
//|                                          FibonacciPatternOpt.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include <strategy_czj\Pattern.mqh>
#include <Strategy\Strategy.mqh>
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

struct PositionStates
  {
   int               open_buy;
   int               open_sell;
   int               open_total;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class StrategyOpt:public CStrategy
  {
public:
   //用于判断模式的参数
   int               num_pattern_recognize; //模式识别需要的周期
   int               num_pattern_max;//模式允许的最大周期
   int               point_range;//模式允许的最小点差
   int               handle_zigzag;//判断模式用的zigzag指标句柄 
                                   //控制进出场的参数
   double            open_ratio;//入场的Fibonacci比例
   double            tp_ratio;//止盈的Fibonacci比例
   double            sl_ratio;//止损的Fibonacci比例

   double            lots;//下单手数

   PatternRecognizeFibonacci prf;   // Fibonacci 模式识别器
   PositionStates    p_states;//仓位状态

   MqlTick           latest_price;   //最新的tick报价
                     StrategyOpt(void);
   void              InitStrategyParameter(const int recognize_num,const int num_pattern,const int points,const double open,const double tp,const double sl,const double size);
   void              SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame);//监听事件
protected:
   virtual void      InitBuy(const MarketEvent &event);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      OnEvent(const MarketEvent &event);
   virtual void      IsTrackEvents(const MarketEvent &event);
   void              RefreshPositionStates(PositionStates &states);   //获取当前仓位信息

  };
//+------------------------------------------------------------------+
StrategyOpt::StrategyOpt(void)
  {
   num_pattern_recognize=100;
   num_pattern_max=26;
   point_range=380;
   open_ratio=0.382;
   tp_ratio=0.618;
   sl_ratio=-0.618;
   lots=1;
   handle_zigzag=iCustom(ExpertSymbol(),Timeframe(),"Examples\\ZigZag");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StrategyOpt::InitStrategyParameter(const int recognize_num,const int num_pattern,const int points,const double open,const double tp,const double sl,const double size)
  {
   num_pattern_recognize=recognize_num;
   num_pattern_max=num_pattern;
   point_range=points;
   open_ratio=open;
   tp_ratio=tp;
   sl_ratio=sl;
   lots=size;
   handle_zigzag=iCustom(ExpertSymbol(),Timeframe(),"Examples\\ZigZag");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StrategyOpt::InitBuy(const MarketEvent &event)
  {
   if(p_states.open_buy!=0) return;
   if(prf.pattern_valid && prf.bull_or_bear==BULL)//模式有效且是涨的模式
     {
      int digits=SymbolInfoInteger(ExpertSymbol(),SYMBOL_DIGITS);
      double open_price=NormalizeDouble(prf.min_price+open_ratio*prf.price_range,digits);
      double tp_price=NormalizeDouble(prf.min_price+tp_ratio*prf.price_range,digits);
      double sl_price=NormalizeDouble(prf.min_price+sl_ratio*prf.price_range,digits);
      if(latest_price.ask<open_price && latest_price.ask>sl_price && latest_price.ask<tp_price)//入场价格达到要求
        {
         string comment_record ="max_price:"+string(prf.max_price)+" min_price:"+string(prf.min_price);
         Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_BUY,lots,latest_price.ask,sl_price,tp_price,comment_record);
         prf.pattern_valid=false;
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StrategyOpt::InitSell(const MarketEvent &event)
  {
   if(p_states.open_sell!=0) return;
   if(prf.pattern_valid && prf.bull_or_bear==BEAR)//模式有效且是跌的模式
     {
      int digits=SymbolInfoInteger(ExpertSymbol(),SYMBOL_DIGITS);
      double open_price=NormalizeDouble(prf.max_price-prf.price_range*open_ratio,digits);
      double tp_price=NormalizeDouble(prf.max_price-prf.price_range*tp_ratio,digits);
      double sl_price=NormalizeDouble(prf.max_price-prf.price_range*sl_ratio,digits);
      if(latest_price.bid>open_price && latest_price.bid<sl_price && latest_price.bid>tp_price)//入场价格达到要求
        {
        string comment_record ="max:"+string(prf.max_price)+" min:"+string(prf.min_price);
         Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_SELL,lots,latest_price.bid,sl_price,tp_price,comment_record);
         prf.pattern_valid=false;
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StrategyOpt::OnEvent(const MarketEvent &event)
  {
//当前监控的品种tick事件发生时需要进行处理的相关动作--更新tick价格
   if(event.symbol==ExpertSymbol() && event.type==MARKET_EVENT_TICK)
     {
      SymbolInfoTick(ExpertSymbol(),latest_price);
      RefreshPositionStates(p_states);
     }
//当前监控品种BAR事件发生时需要进行处理的相关动作--进行模式识别
   if(event.symbol==ExpertSymbol() && event.type==MARKET_EVENT_BAR_OPEN)
     {
      //double high_price[];
      //double low_price[];
      //ArrayResize(high_price,num_pattern_recognize);
      //ArrayResize(low_price,num_pattern_recognize);
      //CopyHigh(ExpertSymbol(),Timeframe(),0,num_pattern_recognize,high_price);
      //CopyLow(ExpertSymbol(),Timeframe(),0,num_pattern_recognize,low_price);
      //prf.pattern_detect(high_price,low_price,num_pattern_max,point_range*SymbolInfoDouble(ExpertSymbol(),SYMBOL_POINT));
      //prf.pattern_detect(handle_zigzag,1000,2,30,point_range*SymbolInfoDouble(ExpertSymbol(),SYMBOL_POINT));
      prf.pattern_detect(handle_zigzag,num_pattern_recognize,20,num_pattern_max,point_range*SymbolInfoDouble(ExpertSymbol(),SYMBOL_POINT));
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StrategyOpt::SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame)
  {
   AddBarOpenEvent(symbol,time_frame);
   AddTickEvent(symbol);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StrategyOpt::RefreshPositionStates(PositionStates &states)
  {
   states.open_buy=0;
   states.open_sell=0;
   for(int i=0;i<PositionsTotal();i++)
     {
      ulong ticket=PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=ExpertMagic()) continue;
      if(PositionGetString(POSITION_SYMBOL)!=ExpertSymbol()) continue;
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) states.open_buy++;
      else states.open_sell++;
      states.open_total++;
     }
  }
//+------------------------------------------------------------------+

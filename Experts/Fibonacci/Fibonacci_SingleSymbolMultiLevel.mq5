//+------------------------------------------------------------------+
//|                                                         test.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <strategy_czj\Fibonacci.mqh>
#include <Strategy\StrategiesList.mqh>

input int period_search_mode=500;   //搜素模式的大周期
input int range_point=300; //模式的最小点数差
input int range_period=50; //模式的最大数据长度

input double open_level1=0.618; //开仓点
input double tp_level1=0.882; //止盈平仓点
input double sl_level1=-1.0; //止损平仓点
input double open_lots1=0.1; //开仓手数

input double open_level2=0.5; //开仓点
input double tp_level2=0.786; //止盈平仓点
input double sl_level2=-1.0; //止损平仓点
input double open_lots2=0.5; //开仓手数

input double open_level3=0.382; //开仓点
input double tp_level3=0.5; //止盈平仓点
input double sl_level3=-1.0; //止损平仓点
input double open_lots3=1.0; //开仓手数

CStrategyList Manager;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ENUM_TIMEFRAMES period=_Period;
   string symbol=_Symbol;
   FibonacciRatioStrategy *strategy1=new FibonacciRatioStrategy();
   strategy1.ExpertMagic(1);
   strategy1.Timeframe(period);
   strategy1.ExpertSymbol(symbol);
   strategy1.ExpertName("Fibonacci Ratio Strategy");
   strategy1.SetPatternParameter(period_search_mode,range_period,range_point);
   strategy1.SetOpenRatio(open_level1);
   strategy1.SetCloseRatio(tp_level1,sl_level1);
   strategy1.SetLots(open_lots1);
   strategy1.SetEventDetect(symbol,period);
   
   FibonacciRatioStrategy *strategy2=new FibonacciRatioStrategy();
   strategy2.ExpertMagic(2);
   strategy2.Timeframe(period);
   strategy2.ExpertSymbol(symbol);
   strategy2.ExpertName("Fibonacci Ratio Strategy");
   strategy2.SetPatternParameter(period_search_mode,range_period,range_point);
   strategy2.SetOpenRatio(open_level2);
   strategy2.SetCloseRatio(tp_level2,sl_level2);
   strategy2.SetLots(open_lots2);
   strategy2.SetEventDetect(symbol,period);
   
   FibonacciRatioStrategy *strategy3=new FibonacciRatioStrategy();
   strategy3.ExpertMagic(3);
   strategy3.Timeframe(period);
   strategy3.ExpertSymbol(symbol);
   strategy3.ExpertName("Fibonacci Ratio Strategy");
   strategy3.SetPatternParameter(period_search_mode,range_period,range_point);
   strategy3.SetOpenRatio(open_level3);
   strategy3.SetCloseRatio(tp_level3,sl_level3);
   strategy3.SetLots(open_lots3);
   strategy3.SetEventDetect(symbol,period);
   
   Manager.AddStrategy(strategy1);
   Manager.AddStrategy(strategy2);
   Manager.AddStrategy(strategy3);
   //if(!Manager.AddStrategy(strategy)) delete strategy;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   Manager.OnTick();
  }
//+------------------------------------------------------------------+

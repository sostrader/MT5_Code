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

input int period_search_mode=100;   //搜素模式的大周期
input int range_point=380; //模式的最小点数差
input int range_period=26; //模式的最大数据长度
input double open_level=0.618; //开仓点
input double tp_level=0.882; //止盈平仓点
input double sl_level=-0.618; //止损平仓点
input double open_lots=0.1; //开仓手数

CStrategyList Manager;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   FibonacciRatioStrategy *strategy1=new FibonacciRatioStrategy();
   strategy1.ExpertMagic(1);
   strategy1.Timeframe(_Period);
   strategy1.ExpertSymbol(_Symbol);
   strategy1.ExpertName("Fibonacci Ratio Strategy");
   strategy1.SetPatternParameter(period_search_mode,range_period,range_point);
   strategy1.SetOpenRatio(open_level);
   strategy1.SetCloseRatio(tp_level,sl_level);
   strategy1.SetLots(open_lots);
   strategy1.SetEventDetect(_Symbol,_Period);
   
//   FibonacciRatioStrategy *strategy2=new FibonacciRatioStrategy();
//   strategy2.ExpertMagic(2);
//   strategy2.Timeframe(_Period);
//   strategy2.ExpertSymbol(_Symbol);
//   strategy2.ExpertName("Fibonacci Ratio Strategy");
//   strategy2.SetPatternParameter(period_search_mode,range_period,range_point);
//   strategy2.SetOpenRatio(0.5);
//   strategy2.SetCloseRatio(0.718,-0.618);
//   strategy2.SetLots(open_lots);
//   strategy2.SetEventDetect(_Symbol,_Period);
//   
//   FibonacciRatioStrategy *strategy3=new FibonacciRatioStrategy();
//   strategy3.ExpertMagic(3);
//   strategy3.Timeframe(_Period);
//   strategy3.ExpertSymbol(_Symbol);
//   strategy3.ExpertName("Fibonacci Ratio Strategy");
//   strategy3.SetPatternParameter(period_search_mode,range_period,range_point);
//   strategy3.SetOpenRatio(0.382);
//   strategy3.SetCloseRatio(0.618,-0.618);
//   strategy3.SetLots(open_lots);
//   strategy3.SetEventDetect(_Symbol,_Period);
   
   Manager.AddStrategy(strategy1);
   //Manager.AddStrategy(strategy2);
   //Manager.AddStrategy(strategy3);
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

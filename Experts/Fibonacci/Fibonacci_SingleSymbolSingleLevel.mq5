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
   FibonacciRatioStrategy *strategy=new FibonacciRatioStrategy();
   strategy.ExpertMagic(1);
   strategy.Timeframe(_Period);
   strategy.ExpertSymbol(_Symbol);
   strategy.ExpertName("Fibonacci Ratio Strategy");
   strategy.SetPatternParameter(period_search_mode,range_period,range_point);
   strategy.SetOpenRatio(open_level);
   strategy.SetCloseRatio(tp_level,sl_level);
   strategy.SetLots(open_lots);
   strategy.SetEventDetect(_Symbol,_Period);

   Manager.AddStrategy(strategy);
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

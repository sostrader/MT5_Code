//+------------------------------------------------------------------+
//|                                                   CustomMACD.mq5 |
//|                                      Copyright 2017,Daixiaorong. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017,Daixiaorong."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <Strategy\Samples\CustomMACD.mqh>

input ENUM_TIMEFRAMES time_frame=PERIOD_M1;
input double price_diverge=0.005; //价格偏离阀值
input double ind_diverge=0.005;   //指标偏离阀值
input int takeprofit=100;         //止盈点数
input int stoploss=100;           //止损点数
input double inp_lot=1.00;           //手数
input bool inp_every_tick=true;    //每个Tick是否检查出场条件
input int long_in_pattern=3;        //多单进场模式
input int long_out_pattern=1;       //多单出场模式
input int short_in_pattern=3;       //空单进场模式
input int short_out_pattern=1;      //空单出场模式

CStrategyList Manager;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   CustomMACD *m_siganl=new CustomMACD();
   m_siganl.ExpertMagic(8111);
   m_siganl.Timeframe(time_frame);
   m_siganl.ExpertSymbol(Symbol());
   m_siganl.ExpertName("MACD Strategy"+(string)Period());
   m_siganl.TakeProfit(takeprofit);
   m_siganl.StopLoss(stoploss);
   m_siganl.EveryTick(inp_every_tick);
   m_siganl.Lots(inp_lot);
   m_siganl.SetPattern(long_in_pattern,long_out_pattern,short_in_pattern,short_out_pattern);
   
   if(!Manager.AddStrategy(m_siganl))
      delete m_siganl;
   return(INIT_SUCCEEDED);
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

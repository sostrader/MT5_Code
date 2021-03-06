//+------------------------------------------------------------------+
//|                                                       czj_Fi.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//#include<Arrays\ArrayDouble.mqh>

input int period=50;
input int out_time=5000;
input int range_point=300;
input int EA_Magic=12345;
input double lots=0.1;
input double buy_in_fi=0.618;
input double buy_out_fi_win=1;
input double buy_out_fi_loss=-2.0;
input double sell_in_fi=0.618;
input double sell_out_fi_win=1;
input double sell_out_fi_loss=-2.0;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      //检查bar数是否足够
      if(Bars(_Symbol,_Period)<period)
            return;
      
      //检查仓位，持仓则判断是否需要平仓
      bool Buy_Opened=false;
      bool Sell_Opened=false;
      if(PositionSelect(_Symbol)==true)
      {
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
            {
               Buy_Opened=true;
            }
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
            {
               Sell_Opened=true;
            }   
      }
     
     if(Buy_Opened || Sell_Opened)
         {
            return;
         }
         
     
      double price[];
      double take_profit;
      double stop_loss;
      int max_loc;
      int min_loc;
      double max_price;
      double min_price;
      MqlTick latest_price;
      MqlTradeRequest mrequest;
      MqlTradeResult mresult;
      ZeroMemory(mrequest);
      
      if(!SymbolInfoTick(_Symbol,latest_price))
         {
            Alert("获取最新报价错误：", GetLastError());
            return;
         }
      CopyClose(_Symbol,_Period,0,period,price);   
      max_loc = ArrayMaximum(price);
      min_loc = ArrayMinimum(price);
      max_price = price[max_loc];
      min_price = price[min_loc];
      
      bool buy_condition_1 = max_loc>min_loc;
      bool buy_condition_2 = max_price-min_price>range_point*_Point;
      bool buy_condition_3 = latest_price.ask<buy_in_fi*(max_price-min_price)+min_price;
      
      bool sell_condition_1 = max_loc<min_loc;
      bool sell_condition_2 = max_price-min_price>range_point*_Point;
      bool sell_condition_3 = latest_price.bid>max_price-sell_in_fi*(max_price-min_price);

      
      if(buy_condition_1&&buy_condition_2)
         if(buy_condition_3)
         {     
            take_profit=buy_out_fi_win*(max_price-min_price)+min_price;
            stop_loss=buy_out_fi_loss*(max_price-min_price)+min_price;
            mrequest.action=TRADE_ACTION_DEAL;
            mrequest.price=NormalizeDouble(latest_price.ask,_Digits);
            mrequest.tp=NormalizeDouble(take_profit,_Digits);
            mrequest.sl=NormalizeDouble(stop_loss, _Digits);
            mrequest.symbol=_Symbol;
            mrequest.volume=lots;
            mrequest.magic=EA_Magic;
            mrequest.type=ORDER_TYPE_BUY;
            mrequest.type_filling=ORDER_FILLING_FOK;
            mrequest.deviation=100;
            OrderSend(mrequest, mresult);
            if(mresult.retcode==10009||mresult.retcode==10008)
               {
                  Alert("买入订单已经成功下单，订单#:", mresult.order,"!!");
               }
            else
               {
                  Alert("买入订单请求无法完成,", GetLastError());
                  ResetLastError();
                  return;
               } 
         }
         
         if(sell_condition_1&&sell_condition_2)
            if(sell_condition_3)
            {     
               take_profit=MathMax(max_price-sell_out_fi_win*(max_price-min_price), latest_price.bid - 1000*_Point);
               stop_loss=MathMin(max_price-sell_out_fi_loss*(max_price-min_price), latest_price.bid + 2000*_Point);
               Print("max:", max_price," min:", min_price, " open:",latest_price.bid, " tp:",take_profit, " sl:",stop_loss);
               mrequest.action=TRADE_ACTION_DEAL;
               mrequest.price=NormalizeDouble(latest_price.bid,_Digits);
               mrequest.tp=NormalizeDouble(take_profit,_Digits);
               mrequest.sl=NormalizeDouble(stop_loss, _Digits);
               mrequest.symbol=_Symbol;
               mrequest.volume=lots;
               mrequest.magic=EA_Magic;
               mrequest.type=ORDER_TYPE_SELL;
               mrequest.type_filling=ORDER_FILLING_FOK;
               mrequest.deviation=100;
               OrderSend(mrequest, mresult);
               if(mresult.retcode==10009||mresult.retcode==10008)
                  {
                     Alert("卖出订单已经成功下单，订单#:", mresult.order,"!!");
                  }
               else
                  {
                     Alert("卖出订单请求无法完成,", GetLastError());
                     ResetLastError();
                     return;
                  } 
            }
    
    
      
      
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+

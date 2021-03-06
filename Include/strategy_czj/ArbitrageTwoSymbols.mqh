//+------------------------------------------------------------------+
//|                                          ArbitrageTwoSymbols.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <Strategy\Strategy.mqh>
#include <Trade\Trade.mqh>
#include <RingBuffer\RiBuffDbl.mqh>
#include <Math\Stat\Normal.mqh>
#include <Trade\Trade.mqh>

CTrade my_trade;

//+------------------------------------------------------------------+
//|         计算环形缓存中的正态分布值                                  |
//+------------------------------------------------------------------+
class CRiNormalDist:public CRiBuffDbl
  {
private:
   double            sum_x;
   double            sum_x2;
protected:
   virtual void      OnAddValue(double value);
   virtual void      OnRemoveValue(double value);
   virtual void      OnChangeValue(int index,double del_value,double new_value);
public:
                     CRiNormalDist(void);
   double            Mu(void);
   double            Sigma(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiNormalDist::CRiNormalDist(void)
  {
   sum_x=0.0;
   sum_x2=0.0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiNormalDist::OnAddValue(double value)
  {
   sum_x+=value;
   sum_x2+=value*value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiNormalDist::OnRemoveValue(double value)
  {
   sum_x-=value;
   sum_x2-=value*value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiNormalDist::OnChangeValue(int index,double del_value,double new_value)
  {
   sum_x-=del_value;
   sum_x2-=del_value*del_value;
   sum_x+=new_value;
   sum_x2+=new_value*new_value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRiNormalDist::Mu(void)
  {
   return sum_x/GetTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRiNormalDist::Sigma(void)
  {
   return MathPow(sum_x2/GetTotal()-MathPow((sum_x/GetTotal()),2),0.5);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PairSymbolsArbitrageStrategy:public CStrategy
  {
private:
   MqlTick latest_price_x;  
   MqlTick latest_price_y;
protected:
   string            symbol_x;
   string            symbol_y;
   ENUM_TIMEFRAMES   period;
   int               num;
   double prob_up;
   double prob_down;

   CRiBuffDbl        ts_x;
   CRiBuffDbl        ts_y;
   CRiNormalDist     ts_xy;
   double            point_x;
   double            point_y;
   double            lots_x;
   double            lots_y;
   double prob_cdf;
   bool position_close;
   double profits;

   void              RefreshPriceSeries(void);//获取价格对序列
   void              CalCointegrationSeries(void);//获取协整序列 

public:
                     PairSymbolsArbitrageStrategy(void);
                    ~PairSymbolsArbitrageStrategy(void){};
                     PairSymbolsArbitrageStrategy(int num_max,double p_down,double p_up);
   virtual void      InitBuy(const MarketEvent &event);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      SupportBuy(const MarketEvent &event,CPosition *pos);
   virtual void      SupportSell(const MarketEvent &event,CPosition *pos);
   virtual void      OnEvent(const MarketEvent &event);
   void              SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame);
   void  CalProfits(void);
   void  CloseAllPosition();
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PairSymbolsArbitrageStrategy::PairSymbolsArbitrageStrategy(void)
  {
   symbol_x="XAUUSD";
   symbol_y="USDJPY";
   period=PERIOD_M1;
   num=1500;
   lots_x=0.1;
   lots_y=0.1;
   ts_x.SetMaxTotal(num);
   ts_y.SetMaxTotal(num);
   ts_xy.SetMaxTotal(num);
   point_x=SymbolInfoDouble(symbol_x,SYMBOL_POINT);
   point_y=SymbolInfoDouble(symbol_y,SYMBOL_POINT);
  }
PairSymbolsArbitrageStrategy::PairSymbolsArbitrageStrategy(int num_max,double p_down,double p_up)
  {
   symbol_x="XAUUSD";
   symbol_y="USDJPY";
   period=PERIOD_M1;
   num=num_max;
   lots_x=0.1;
   lots_y=0.1;
   ts_x.SetMaxTotal(num);
   ts_y.SetMaxTotal(num);
   ts_xy.SetMaxTotal(num);
   point_x=SymbolInfoDouble(symbol_x,SYMBOL_POINT);
   point_y=SymbolInfoDouble(symbol_y,SYMBOL_POINT);
   prob_up=p_up;
   prob_down=p_down;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PairSymbolsArbitrageStrategy::RefreshPriceSeries(void)
  {
   double temp_x[];
   double temp_y[];
   //datetime dt_begin=TimeCurrent();
   //datetime dt_end=dt_begin-PeriodSeconds(period);
   //if(CopyClose(symbol_x,period,dt_begin,dt_end,temp_x)>0 && CopyClose(symbol_y,period,dt_begin,dt_end,temp_y)>0)
   //  {
   //   ts_x.AddValue(temp_x[0]/point_x);
   //   ts_y.AddValue(temp_y[0]/point_y);
   //   ts_xy.AddValue(temp_x[0]/point_x+temp_y[0]/point_y);  //价格的和稳定
   //  }
   if(CopyClose(symbol_x,period,0,1,temp_x)>0 && CopyClose(symbol_y,period,0,1,temp_y)>0)
     {
      ts_x.AddValue(temp_x[0]/point_x);
      ts_y.AddValue(temp_y[0]/point_y);
      //ts_xy.AddValue(temp_x[0]/point_x+temp_y[0]/point_y);  //价格的和稳定
      ts_xy.AddValue((temp_x[0]/point_x)*(temp_y[0]/point_y));  //价格的和稳定
     }
  }
void PairSymbolsArbitrageStrategy::InitBuy(const MarketEvent &event)
   {
    if(positions.open_total>0)  return;
    //prob_cdf=MathCumulativeDistributionNormal(ts_xy.GetValue(ts_xy.GetTotal()),ts_xy.Mu(),ts_xy.Sigma(),error_coder); 
    if(prob_cdf<0.2)
      {
       Trade.PositionOpen(symbol_x,ORDER_TYPE_BUY,lots_x,latest_price_x.ask,0,0);
       Trade.PositionOpen(symbol_y,ORDER_TYPE_BUY,lots_y, latest_price_y.ask,0,0);
      }
   }
void PairSymbolsArbitrageStrategy::InitSell(const MarketEvent &event)
   {
    if(positions.open_total>0)  return;
    //prob_cdf=MathCumulativeDistributionNormal(ts_xy.GetValue(ts_xy.GetTotal()),ts_xy.Mu(),ts_xy.Sigma(),error_coder); 
    if(prob_cdf>0.8)
      {
       Trade.PositionOpen(symbol_x,ORDER_TYPE_SELL,lots_x,latest_price_x.bid,0,0);
       Trade.PositionOpen(symbol_y,ORDER_TYPE_SELL,lots_y, latest_price_y.bid,0,0);
      }
   }   
void PairSymbolsArbitrageStrategy::OnEvent(const MarketEvent &event)
   {
    if(event.type==MARKET_EVENT_BAR_OPEN&&event.symbol==symbol_x) RefreshPriceSeries();
    if(ts_xy.GetTotal()<ts_xy.GetMaxTotal()) return;
    if(event.type==MARKET_EVENT_TICK&&(event.symbol==symbol_x||event.symbol==symbol_y))
      {
       
       SymbolInfoTick(symbol_x,latest_price_x);
       SymbolInfoTick(symbol_y,latest_price_y);
       //prob_cdf=MathCumulativeDistributionNormal(ts_xy.GetValue(ts_xy.GetTotal()),ts_xy.Mu(),ts_xy.Sigma(),error_coder);
       int error_coder;
       //prob_cdf=MathCumulativeDistributionNormal(latest_price_x.ask/point_x+latest_price_y.ask/point_y,ts_xy.Mu(),ts_xy.Sigma(),error_coder);
       prob_cdf=MathCumulativeDistributionNormal((latest_price_x.ask/point_x)*(latest_price_y.ask/point_y),ts_xy.Mu(),ts_xy.Sigma(),error_coder);
       CalProfits();
       if((positions.open_buy>0&&prob_cdf>0.8)||(positions.open_sell>0&&prob_cdf<0.2)||profits>40)
          CloseAllPosition();
      }
    
   }
void PairSymbolsArbitrageStrategy::SupportBuy(const MarketEvent &event,CPosition *pos)
   {
    //if(position_close)
    //  pos.CloseAtMarket();
   }
void PairSymbolsArbitrageStrategy::SupportSell(const MarketEvent &event,CPosition *pos)
   {
    //if(position_close)
    //  pos.CloseAtMarket();
   }
void PairSymbolsArbitrageStrategy::SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame)
   {
    AddBarOpenEvent(symbol,time_frame);
    AddTickEvent(symbol);
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PairSymbolsArbitrageStrategy::CalCointegrationSeries(void)
  {

  }
void PairSymbolsArbitrageStrategy::CloseAllPosition(void)
   {
    for(int i=PositionsTotal()-1;i>=0;i--)
      {
      ulong ticket = PositionGetTicket(i);
      bool bl=my_trade.PositionClose(ticket);
      Print("in close position:", i, " ticket", ticket, " bool:", bl);
      }
   }
void PairSymbolsArbitrageStrategy::CalProfits(void)
   {
    profits=0;
    for(int i=PositionsTotal()-1;i>=0;i--)
      {
       ulong ticket = PositionGetTicket(i);
       PositionSelectByTicket(ticket); 
       profits+=PositionGetDouble(POSITION_PROFIT);
      }
   }
//+------------------------------------------------------------------+

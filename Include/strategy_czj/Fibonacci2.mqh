//+------------------------------------------------------------------+
//|                                                   Fibonacci2.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <Strategy\Strategy.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum OpenSignal
  {
   OPEN_BUY_SIGNAL,
   OPEN_SELL_SIGNAL,
   OPEN_NULL_SIGNAL
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class FibonacciRatioStrategy2:public CStrategy
  {
private:
   double            extreme[1000];
   double            values[],index[];
   double            max_price,min_price;
   double            range_points[],range_bars[];
   bool              pattern_buy_exist,pattern_sell_exist;

protected:
   int               num_pattern_recognize; //模式识别需要的周期
   int               num_pattern_max;//模式允许的最大周期
   int               point_range;//模式允许的最小点差
   int               zigzag_handle;

   double            open_ratio;//入场的Fibonacci比例
   double            tp_ratio;//止盈的Fibonacci比例
   double            sl_ratio;//止损的Fibonacci比例
   double            lots;//下单手数

   MqlTick           latest_price;//当前的tick报价

   OpenSignal        open_signal;//模式是否存在
   double            open_price;//用于开仓的比较价格
   double            tp_price;//用于止盈的价格
   double            sl_price;//用于止损的价格

   bool              IsTrackEvents(const MarketEvent &event);

   PositionStates    p_states;
   virtual void      InitBuy(const MarketEvent &event);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      OnEvent(const MarketEvent &event);
   virtual void      IsTrackEvents();

public:
                     FibonacciRatioStrategy2(void){};
                    ~FibonacciRatioStrategy2(void){};
   void  SetOpenRatio(double o_ratio) {open_ratio=o_ratio;}
   void  SetCloseRatio(double take_profit_ratio,double stop_loss_ratio){tp_ratio=take_profit_ratio;sl_ratio=stop_loss_ratio;}
   void  SetLots(double l){lots=l;}
   void  SetHandle(){zigzag_handle=iCustom(ExpertSymbol(),Timeframe(),"Examples\\ZigZag");}
   void  SetPatternParameter(int num_for_recognize_pattern,int num_of_pattern,int point_range_of_pattern)
     {
      num_pattern_recognize=num_for_recognize_pattern;
      num_pattern_max=num_of_pattern;
      point_range=point_range_of_pattern;
     }
   void              SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame);
   void              GetPositionStates(PositionStates &states);   //获取当前仓位信息    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FibonacciRatioStrategy2::SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame)
  {
   AddBarOpenEvent(symbol,time_frame);
   AddTickEvent(symbol);
  }
//+------------------------------------------------------------------+
//|新BAR形成后要进行模式的识别，如果模式存在同时计算开仓的价格和止盈止损价格                                                       |
//+------------------------------------------------------------------+
void FibonacciRatioStrategy2::OnEvent(const MarketEvent &event)
  {
   if(event.type==MARKET_EVENT_TICK && event.symbol==ExpertSymbol())
     {
      SymbolInfoTick(ExpertSymbol(),latest_price);
      GetPositionStates(p_states);
     }
//新BAR形成需要进行模式识别
   if(event.symbol==ExpertSymbol() && event.type==MARKET_EVENT_BAR_OPEN)
     {
      int counter=0;
      bool tt=CopyBuffer(zigzag_handle,0,0,1000,extreme);
      for(int i=1000-1;i>=0;i--)
        {
         if(extreme[i]==0) continue;
         counter++;
         ArrayResize(values,counter);
         ArrayResize(index,counter);
         values[counter-1]=extreme[i];
         index[counter-1]=i;
        }
      ArrayResize(range_bars,ArraySize(values)-1);
      ArrayResize(range_points,ArraySize(values)-1);
      for(int i=0;i<ArraySize(values)-1;i++)
        {
         range_bars[i]=index[i]-index[i+1];
         range_points[i]=values[i]-values[i+1];
        }
      Print(counter);
      if((range_points[1]-range_points[2])/(range_bars[1]-range_bars[2])>50)
         {
          pattern_buy_exist=true;
          max_price=values[1];
          min_price=values[2];
         }
      else
        {
         pattern_buy_exist=false;
        }
      if((range_points[2]-range_points[1])/(range_bars[1]-range_bars[2])>50)
         {
          pattern_sell_exist=true;
          max_price=values[2];
          min_price=values[1];
         }
      else
         {
          pattern_sell_exist=false;
         }
         
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FibonacciRatioStrategy2::GetPositionStates(PositionStates &states)
  {
   states.open_buy=0;
   states.open_sell=0;
   for(int i=0;i<PositionsTotal();i++)
     {
      ulong ticket=PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=ExpertMagic()) continue;
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) states.open_buy++;
      else states.open_sell++;
      states.open_total++;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FibonacciRatioStrategy2::InitBuy(const MarketEvent &event)
  {
   if(!IsTrackEvents(event)) return;//不是指定的事件发生不开仓
   if(p_states.open_buy>0) return;//只能允许一个仓位
   if(pattern_buy_exist)
     {
      open_price=open_ratio*(max_price-min_price)+min_price;
      tp_price=NormalizeDouble(tp_ratio*(max_price-min_price)+min_price,SymbolInfoInteger(ExpertSymbol(),SYMBOL_DIGITS));
      sl_price=NormalizeDouble(sl_ratio*(max_price-min_price)+min_price,SymbolInfoInteger(ExpertSymbol(),SYMBOL_DIGITS));
      //Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_BUY_LIMIT,lots,open_price,sl_price,tp_price,"Buy");
      Trade.OrderOpen(ExpertSymbol(),ORDER_TYPE_BUY_LIMIT,lots,0,open_price,0,0,"limit-buy");
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FibonacciRatioStrategy2::InitSell(const MarketEvent &event)
  {
//if(true) return;
   if(!IsTrackEvents(event)) return;
   if(p_states.open_sell>0) return;
   if(true)
     {
      open_price=max_price-open_ratio*(max_price-min_price);
      Print(max_price, " ", min_price);
      tp_price=NormalizeDouble(max_price-tp_ratio*(max_price-min_price),SymbolInfoInteger(ExpertSymbol(),SYMBOL_DIGITS));
      sl_price=NormalizeDouble(max_price-sl_ratio*(max_price-min_price),SymbolInfoInteger(ExpertSymbol(),SYMBOL_DIGITS));
      //Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_SELL_LIMIT,lots,open_price,sl_price,tp_price,"Sell");
      Print("open_price:",open_price,"latest_price:", latest_price.bid);
      Trade.OrderOpen(ExpertSymbol(),ORDER_TYPE_SELL_LIMIT,lots,0,open_price,0,0,"limit-sell");
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FibonacciRatioStrategy2::IsTrackEvents(const MarketEvent &event)
  {
   if(event.type!=MARKET_EVENT_TICK) return false;
   if(event.symbol!=ExpertSymbol()) return false;
   return true;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                      Impulse.mqh |
//|           Copyright 2016, Vasiliy Sokolov, St-Petersburg, Russia |
//|                                https://www.mql5.com/en/users/c-4 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "https://www.mql5.com/en/users/c-4"
#include <Strategy\Strategy.mqh>
#include <Strategy\Indicators\MovingAverage.mqh>

input double StopPercent = 0.05;
//+------------------------------------------------------------------+
//| Defines the actions that need to be performed with a pending     |
//| order.                                                           |
//+------------------------------------------------------------------+
enum ENUM_ORDER_TASK
{
   ORDER_TASK_DELETE,   // Delete a pending order
   ORDER_TASK_MODIFY    // Modify a pending order
};
//+------------------------------------------------------------------+
//| The CImpulse Strategy                                            |
//+------------------------------------------------------------------+
class CImpulse : public CStrategy
{
private:
   double            m_percent;        // Percent value for the level of a pending order
   bool              IsTrackEvents(const MarketEvent &event);
protected:
   virtual void      InitBuy(const MarketEvent &event);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      SupportBuy(const MarketEvent &event,CPosition *pos);
   virtual void      SupportSell(const MarketEvent &event,CPosition *pos);
   virtual void      OnSymbolChanged(string new_symbol);
   virtual void      OnTimeframeChanged(ENUM_TIMEFRAMES new_tf);
public:
   double            GetPercent(void);
   void              SetPercent(double percent);
   CIndMovingAverage Moving;
};
//+------------------------------------------------------------------+
//| Working with the pending BuyStop orders for opening a long       |
//| position                                                         |
//+------------------------------------------------------------------+
void CImpulse::InitBuy(const MarketEvent &event)
{
   if(!IsTrackEvents(event))return;                      
   if(positions.open_buy > 0) return;                    
   int buy_stop_total = 0;
   ENUM_ORDER_TASK task;
   double target = Ask() + Ask()*(m_percent/100.0);
   if(target < Moving.OutValue(0))                    // The order trigger price must be above the Moving Average
      task = ORDER_TASK_DELETE;
   else
      task = ORDER_TASK_MODIFY;
   for(int i = PendingOrders.Total()-1; i >= 0; i--)
   {
      CPendingOrder* Order = PendingOrders.GetOrder(i);
      if(Order == NULL || !Order.IsMain(ExpertSymbol(), ExpertMagic()))
         continue;
      if(Order.Type() == ORDER_TYPE_BUY_STOP)
      {
         if(task == ORDER_TASK_MODIFY)
         {
            buy_stop_total++;
            Order.Modify(target);
         }
         else
            Order.Delete();
      }
   }
   if(buy_stop_total == 0 && task == ORDER_TASK_MODIFY)
      Trade.BuyStop(MM.GetLotFixed(), target, ExpertSymbol(), 0, 0, NULL);
}
//+------------------------------------------------------------------+
//| Working with the pending SellStop orders for opening a short     |
//| position                                                         |
//+------------------------------------------------------------------+
void CImpulse::InitSell(const MarketEvent &event)
{
   if(!IsTrackEvents(event))return;                      
   if(positions.open_sell > 0) return;                    
   int sell_stop_total = 0;
   ENUM_ORDER_TASK task;
   double target = Bid() - Bid()*(m_percent/100.0);
   if(target > Moving.OutValue(0))                    // The order trigger price must be above the Moving Average
      task = ORDER_TASK_DELETE;
   else
      task = ORDER_TASK_MODIFY;
   for(int i = PendingOrders.Total()-1; i >= 0; i--)
   {
      CPendingOrder* Order = PendingOrders.GetOrder(i);
      if(Order == NULL || !Order.IsMain(ExpertSymbol(), ExpertMagic()))
         continue;
      if(Order.Type() == ORDER_TYPE_SELL_STOP)
      {
         if(task == ORDER_TASK_MODIFY)
         {
            sell_stop_total++;
            Order.Modify(target);
         }
         else
            Order.Delete();
      }
   }
   if(sell_stop_total == 0 && task == ORDER_TASK_MODIFY)
      Trade.SellStop(MM.GetLotFixed(), target, ExpertSymbol(), 0, 0, NULL);
}
//+------------------------------------------------------------------+
//| Managing a long position in accordance with the Moving Average   |
//+------------------------------------------------------------------+
void CImpulse::SupportBuy(const MarketEvent &event,CPosition *pos)
{
   if(!IsTrackEvents(event))return;
   ENUM_ACCOUNT_MARGIN_MODE mode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   if(mode != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
   {
      double target = Bid() - Bid()*(m_percent/100.0);
      if(target < Moving.OutValue(0))
         pos.StopLossValue(target);
      else
         pos.StopLossValue(0.0);
   }
   if(Bid() < Moving.OutValue(0))
      pos.CloseAtMarket();
}
//+------------------------------------------------------------------+
//| Managing a short position in accordance with the Moving Average  |
//+------------------------------------------------------------------+
void CImpulse::SupportSell(const MarketEvent &event,CPosition *pos)
{
   if(!IsTrackEvents(event))return;
   ENUM_ACCOUNT_MARGIN_MODE mode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   if(mode != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
   {
      double target = Ask() + Ask()*(m_percent/100.0);
      if(target > Moving.OutValue(0))
         pos.StopLossValue(target);
      else
         pos.StopLossValue(0.0);
   }
   if(Ask() > Moving.OutValue(0))
      pos.CloseAtMarket();
}
//+------------------------------------------------------------------+
//| Filters incoming events. If the passed event is not              |
//| processed by the strategy, returns false; if it is processed     |
//| returns true.                                                    |
//+------------------------------------------------------------------+
bool CImpulse::IsTrackEvents(const MarketEvent &event)
  {
//We handle only opening of a new bar on the working symbol and timeframe
   if(event.type != MARKET_EVENT_BAR_OPEN)return false;
   if(event.period != Timeframe())return false;
   if(event.symbol != ExpertSymbol())return false;
   return true;
  }
//+------------------------------------------------------------------+
//| React to symbol change                                           |
//+------------------------------------------------------------------+
void CImpulse::OnSymbolChanged(string new_symbol)
  {
   Moving.Symbol(new_symbol);
  }
//+------------------------------------------------------------------+
//| React to timeframe change                                        |
//+------------------------------------------------------------------+
void CImpulse::OnTimeframeChanged(ENUM_TIMEFRAMES new_tf)
  {
   Moving.Timeframe(new_tf);
  }
//+------------------------------------------------------------------+
//| Returns the percent of the breakthrough level                    |
//+------------------------------------------------------------------+  
double CImpulse::GetPercent(void)
{
   return m_percent;
}
//+------------------------------------------------------------------+
//| Sets percent of the breakthrough level                           |
//+------------------------------------------------------------------+  
void CImpulse::SetPercent(double percent)
{
   m_percent = percent;
}
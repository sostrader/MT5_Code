//+------------------------------------------------------------------+
//|                                                   MaExtremum.mqh |
//|                                                      Daixiaorong |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Daixiaorong"
#property link      "https://www.mql5.com"

#include "..\Strategy.mqh"
#include <Indicators\Trend.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum MaExtremumSiganal
  {
   NOSIGANL=0,
   BUYSIGNAL=1,
   SELLSIGNAL=2
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMaExtremum:public CStrategy
  {
private:
   int               short_period;  //短周期数
   int               long_period;   //长周期数
   double            m_type;        //长短周期均线差的正负，若为负，则为-1.00，若为正则为1.00
   double            current_lots;  //当前的手数
   CiMA              m_short_ma;    //短周期均线对象
   CiMA              m_long_ma;     //长周期均线对象
   bool              m_every_tick;  //若为false,则采用上一个Bar进行判断，若为true,则为当前Bar进行判断
   double            m_extr_osc;    //存储指标极点值
   double            m_high[];      //存储一定区间范围内的最高价
   double            m_low[];       //存储一定区间范围内的最低价
   int               m_extr_pos;    // 极点偏离当前的Bar数
   MaExtremumSiganal m_signal;      //信号出现的标识符
   int               m_max_orders;  //最大的开单数
   int               extremum_pattern;//寻找极点的模式
protected:
   virtual void      InitBuy(const MarketEvent &event);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      SupportBuy(const MarketEvent &event,CPosition *pos);
   virtual void      SupportSell(const MarketEvent &event,CPosition *pos);
   virtual void      OnEvent(const MarketEvent &event);
   int               StartIndex(void) {return m_every_tick?0:1;}
   int               StateMain(int indx);
   bool              Pattern_1(int start_index);
   bool              Pattern_2(int start_index);
   bool              SearchExtremums();
public:
                     CMaExtremum(void);
                    ~CMaExtremum(void);
   void              SetParams(int short_ma,int long_ma,int max_orders=1,int ext_pattern=1);
   void              EveryTick(bool value) {m_every_tick=value;}
   void              Lots(double value) {current_lots=value;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMaExtremum::CMaExtremum(void)
  {
   short_period=24;
   long_period=24;
   m_every_tick=false;
   m_signal=false;  //判断是否存在极点信号
   m_max_orders=0;
   current_lots=0.1;
   extremum_pattern=1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMaExtremum::~CMaExtremum(void)
  {

  }
//+------------------------------------------------------------------+
//| 设置指标参数并创建相应的指标对象                                                                 |
//+------------------------------------------------------------------+
void CMaExtremum::SetParams(int short_ma,int long_ma,int max_orders=1,int ext_pattern=1)
  {
   short_period=short_ma;
   long_period=long_ma;
   m_max_orders=max_orders-1;
   extremum_pattern=ext_pattern;
   ArrayResize(m_high,short_ma);
   ArrayResize(m_low,short_ma);
   m_short_ma.Create(ExpertSymbol(),Timeframe(),short_period,0,MODE_SMA,PRICE_CLOSE);
   m_long_ma.Create(ExpertSymbol(),Timeframe(),long_period,0,MODE_SMA,PRICE_CLOSE);
  }
//+------------------------------------------------------------------+
//| 更新指标值                                                       |
//+------------------------------------------------------------------+
void CMaExtremum::OnEvent(const MarketEvent &event)
  {
   if(event.type!=MARKET_EVENT_BAR_OPEN)
      return;
   m_short_ma.Refresh();
   m_long_ma.Refresh();
   int idx=StartIndex();
   m_signal=NOSIGANL;
   if(m_short_ma.Main(idx)==EMPTY_VALUE || m_long_ma.Main(idx)==EMPTY_VALUE) m_type=0.0;
   if(m_short_ma.Main(idx)-m_long_ma.Main(idx)<0)
      m_type=-1.00;
   else
      m_type=1.00;
//---寻找对应的极值点
   if(!SearchExtremums()) return;
//---保存最近的价格
   for(int i=0;i<short_period;i++)
     {
      m_high[i]=High[i];
      m_low[i]=Low[i];
     }
  }
//+------------------------------------------------------------------+
//|计算指标从indx开始往前数最近的一个极点的位置，若返回正数，则是极小值，|
//|若是负数则为极大值                                                    |
//+------------------------------------------------------------------+
int CMaExtremum::StateMain(int ind)
  {
   int    res=0;
   double var;
//---
   for(int i=ind;;i++)
     {
      if(m_short_ma.Main(i+1)==EMPTY_VALUE)
         break;
      var=m_short_ma.Main(i)-m_short_ma.Main(i+1);
      if(res>0)
        {
         if(var<0)
            break;
         res++;
         continue;
        }
      if(res<0)
        {
         if(var>0)
            break;
         res--;
         continue;
        }
      if(var>0)
         res++;
      if(var<0)
         res--;
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
//|寻找极点的模式一                                                                  |
//+------------------------------------------------------------------+
bool CMaExtremum::Pattern_1(int start_index)
  {
   int count=0;
   for(int i=0;i<start_index-1;i++)
     {
      //---若m_type为负，计算极小值；若为正，计算极大值
      if(m_type*(m_short_ma.Main(i+1)-m_short_ma.Main(i+2))>0 && m_type*(m_short_ma.Main(i)-m_short_ma.Main(i+1))<0)
        {
         m_extr_osc=m_short_ma.Main(i+1);
         m_signal=m_type<0?BUYSIGNAL:SELLSIGNAL;
         count++;
         break;
        }
     }
   if(count>0) return true;
   else return true;
  }
//+------------------------------------------------------------------+
//|寻找极点的模式二                                                                    |
//+------------------------------------------------------------------+
bool CMaExtremum::Pattern_2(int start_index)
  {
   m_extr_pos=StateMain(0);
//---极点在m_type变化前的不考虑
   if(MathAbs(m_extr_pos)>start_index || m_extr_pos==0) return false;
   m_signal=m_extr_pos>0?BUYSIGNAL:SELLSIGNAL;
   return true;
  }
//+------------------------------------------------------------------+
//| 记录临近的极值点                                                                 |
//+------------------------------------------------------------------+
bool CMaExtremum::SearchExtremums()
  {
   if(m_type==0.0) return false;
   int idx=StartIndex();
//----寻找两条均线的交叉点
   while(m_type*(m_short_ma.Main(idx+1)-m_long_ma.Main(idx+1))>=0)
     {
      idx++;
     }
//---选择寻找极点的模式
   switch(extremum_pattern)
     {
      case 1:
         return Pattern_1(idx);
         break;
      case 2:
         return Pattern_2(idx);
         break;
      default:
         break;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|短期均线在长期均线下方，临近的均线拐点为极小值，                  |
//|当前K线往前短周期个K线内的最低价为止损位置，最高价为进场位置      |
//+------------------------------------------------------------------+
void CMaExtremum::InitBuy(const MarketEvent &event)
  {
   if(event.type!=MARKET_EVENT_BAR_OPEN)
      return;
   if(m_signal!=BUYSIGNAL) return;
   if(positions.open_buy>m_max_orders) return;
   int max_high_id=ArrayMaximum(m_high);
   int min_low_id=ArrayMinimum(m_low);
   int idx=StartIndex();
   if(High[idx]>=High[max_high_id])
     {
      Trade.Buy(current_lots,ExpertSymbol());
      Trade.PositionModify(Trade.ResultOrder(),Low[min_low_id],0.0);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMaExtremum::SupportBuy(const MarketEvent &event,CPosition *pos)
  {
   if(event.type!=MARKET_EVENT_BAR_OPEN)
      return;
   //---出现反向信号则平仓
   if(m_signal==SELLSIGNAL)
     {
      int max_high_id=ArrayMaximum(m_high);
      int min_low_id=ArrayMinimum(m_low);
      int idx=StartIndex();
      if(Low[idx]<=Low[min_low_id])
         pos.CloseAtMarket();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMaExtremum::InitSell(const MarketEvent &event)
  {
   if(event.type!=MARKET_EVENT_BAR_OPEN)
      return;
   if(m_signal!=SELLSIGNAL) return;
   if(positions.open_sell>m_max_orders) return;
   int max_high_id=ArrayMaximum(m_high);
   int min_low_id=ArrayMinimum(m_low);
   int idx=StartIndex();
   if(Low[idx]<=Low[min_low_id])
     {
      Trade.Sell(current_lots,ExpertSymbol());
      Trade.PositionModify(Trade.ResultOrder(),High[max_high_id],0.0);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMaExtremum::SupportSell(const MarketEvent &event,CPosition *pos)
  {
   if(event.type!=MARKET_EVENT_BAR_OPEN)
      return;
   if(m_signal==BUYSIGNAL)
     {
      int max_high_id=ArrayMaximum(m_high);
      int min_low_id=ArrayMinimum(m_low);
      int idx=StartIndex();
      if(High[idx]>=High[max_high_id])
         pos.CloseAtMarket();
     }
  }
//+------------------------------------------------------------------+

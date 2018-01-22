//+------------------------------------------------------------------+
//|                                                PositionInfor.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPositionInfor
  {
public:
                     CPositionInfor(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPositionInfor::CPositionInfor(void)
  {
   HistorySelect(0,D'2030.01.01');
   for(int i=0;i<HistoryDealsTotal();i++)
     {
      ulong pos_id=HistoryDealGetInteger(HistoryDealGetInteger(DEAL_POSITION_ID));
      Print("仓位:",pos_id);
      
     }

  }
//+------------------------------------------------------------------+

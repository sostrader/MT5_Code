//+------------------------------------------------------------------+
//|                                      ForexMatrketDataManager.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayDouble.mqh>
//+------------------------------------------------------------------+
//|      外汇全市场数据接口                                          |
//+------------------------------------------------------------------+
class CForexMarketDataManager
  {
private:
   string            symbols[];//品种数组
   ENUM_TIMEFRAMES   tf;//周期
   CArrayObj         symbol_price;//价格数据
   CArrayObj         symbol_time;//时间
public:
   void              SetParameter(const string &forex_symbol[],const ENUM_TIMEFRAMES time_frame);//设置参数
   string            GetSymbolAt(const int index);//获取指定索引的品种数组
   ENUM_TIMEFRAMES   GetTimeFrame(void){return tf;};//返回周期
   void              RefreshSymbolsPrice(datetime begin,datetime end);//刷新给定时间间隔的价格数据
   void              RefreshSymbolsPrice(datetime begin);//刷新给定时间起点和价格数据
   void              RefreshSymbolsPrice(int num);//刷新给定数量的价格数据
   CArrayDouble     *GetSymbolPriceAt(int index);//返回给定索引的数据
   CArrayDouble     *GetSymbolPriceAt(string symbol_name);//返回给定品种的数据
   CArrayDouble     *GetSymbolTimeAt(int index);//返回给定索引的数据
   CArrayDouble     *GetSymbolTimeAt(string symbol_name);//返回给定品种的数据
  };
//+------------------------------------------------------------------+
void CForexMarketDataManager::SetParameter(const string &forex_symbol[],const ENUM_TIMEFRAMES time_frame)
  {
   ArrayCopy(symbols,forex_symbol);
   tf=time_frame;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CForexMarketDataManager::GetSymbolAt(const int index)
  {
   return symbols[index];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CForexMarketDataManager::RefreshSymbolsPrice(datetime begin,datetime end)
  {
   symbol_time.Shutdown();
   symbol_price.Shutdown();
   for(int i=0;i<ArraySize(symbols);i++)
     {
      MqlRates rates[];
      CopyRates(symbols[i],tf,begin,end,rates);
      int size=ArraySize(rates);
      CArrayDouble *price=new CArrayDouble();
      CArrayDouble *time=new CArrayDouble();
      for(int j=0;j<size;j++)
        {
         price.Add(rates[j].close);
         time.Add((double)(rates[j].time));
        }
      symbol_time.Add(time);
      symbol_price.Add(price);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CForexMarketDataManager::RefreshSymbolsPrice(datetime begin)
  {
   RefreshSymbolsPrice(begin,TimeCurrent());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CForexMarketDataManager::RefreshSymbolsPrice(int num)
  {
   symbol_time.Shutdown();
   symbol_price.Shutdown();

   double data_temp[1];
   MqlRates rates[];

   for(int i=0;i<ArraySize(symbols);i++)
     {
      CArrayDouble *price=new CArrayDouble();
      CArrayDouble *time=new CArrayDouble();
      CopyRates(symbols[i],tf,0,num,rates);

      for(int j=num-1;j>=0;j--)
        {
         price.Add(rates[j].close);
         time.Add((double)(rates[j].time));
        }
      symbol_time.Add(time);
      symbol_price.Add(price);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CArrayDouble *CForexMarketDataManager::GetSymbolPriceAt(int index)
  {
   return symbol_price.At(index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CArrayDouble *CForexMarketDataManager::GetSymbolPriceAt(string symbol_name)
  {
   for(int i=0;i<ArraySize(symbols);i++)
     {
      if(symbol_name==symbols[i])
        {
         return symbol_price.At(i);
        }
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CArrayDouble *CForexMarketDataManager::GetSymbolTimeAt(int index)
  {
   return symbol_time.At(index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CArrayDouble *CForexMarketDataManager::GetSymbolTimeAt(string symbol_name)
  {
   for(int i=0;i<ArraySize(symbols);i++)
     {
      if(symbol_name==symbols[i])
        {
         return symbol_time.At(i);
        }
     }
   return NULL;
  }
//+------------------------------------------------------------------+

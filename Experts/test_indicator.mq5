//+------------------------------------------------------------------+
//|                                               test_indicator.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"

int ExtHandle=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ExtHandle=iCustom(_Symbol,_Period,"Examples\\ZigZag");
   if(ExtHandle==INVALID_HANDLE)
      {
       Print("获取zigzag句柄失败");
       return(INIT_FAILED);
      }
   Print("handle-zigzag::::", ExtHandle);
   
      double extreme[1000];
   double value[];
   datetime time[1000];
   datetime time_value[];
   int   index[];
   int counter=0;
   CopyBuffer(ExtHandle,0,0,1000,extreme);
   CopyTime(_Symbol,0,0,1000,time);
   for(int i=1000-1;i>=0;i--)
     {
      if(extreme[i]==0) continue;
      counter++;
      ArrayResize(value,counter);
      ArrayResize(index,counter);
      ArrayResize(time_value,counter);
      value[counter-1]=extreme[i];
      index[counter-1]=i;
      time_value[counter-1]=time[i];
     }
   //Print("size",counter,"index:",index[2],"value",value[2], "time", time_value[2]);
   double slope;
   for(int i=0;i<ArraySize(value)-1;i++)
     {
      slope=(value[i]-value[i+1])/(index[i]-index[i+1])/_Point;
      Print(slope);
     }
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
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                 scale_factor.mq5 |
//|                                                         Aternion |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Aternion"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_plots   0
//--- input parameters
input int      bars=500;            //  extreme points search range
input double   delta_points=160;    //  variation range defining the minimum distance between a peak and a bottom in points
input double   first_extrem=0.5;    //  additional ratio for searching for the first extreme value
input int      reload_time=1;       //  time interval, after which the indicator values are recalculated, in seconds
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   bool xxx=EventSetTimer(reload_time);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Function-event handler "timer"                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   double High[],Low[];
   datetime Time[];

   ArraySetAsSeries(Low,true);
   int copied1=CopyLow(Symbol(),0,0,bars+2,Low);
   ArraySetAsSeries(High,true);
   int copied2=CopyHigh(Symbol(),0,0,bars+2,High);
   ArraySetAsSeries(Time,true);
   int copied3=CopyTime(Symbol(),0,0,bars+2,Time);

   double delta=delta_points*Point();     //  variation range between extreme points in absolute terms
   int j,k,l;
   int j2,k2,l2;
   double  j1,k1,l1;
//--- array defining bottoms if the first detected extreme value is a bottom
   int min[10];         // the value corresponds to the bar index for a detected extreme point  
//--- array defining peaks if the first detected extreme value is a bottom
   int max[10];         // the value corresponds to the bar index for a detected extreme point
//--- array defining bottoms if the first detected extreme value is a peak
   int Min[10];         // the value corresponds to the bar index for a detected extreme point
//--- array defining peaks if the first detected extreme value is a peak
   int Max[10];         // the value corresponds to the bar index for a detected extreme point

   int mag1=bars;
   int mag2=bars;
   int mag3=bars;
   int mag4=bars;
//--- extreme points are defined first if the first of them is a bottom
   j1=SymbolInfoDouble(Symbol(),SYMBOL_BID)+(1-first_extrem)*delta_points*Point();
//--- when searching for the first extreme point, the additional ratio defines the minimum price, below which the first bottom is to be located
   j2=0;                      // at the first iteration, the search is performed beginning from the last history bar
//--- loop defining the first bottom - min[1]
   for(j=0;j<=15;j++)
     {
      min[1]=minimum(j2,bars,j1);  // define the nearest bottom within the specified interval
      j2=min[1]+1;                 // at the next iteration, the search is performed from the already detected bottom min[1]
      j1=Low[min[1]]+delta;        // Low price for the bottom detected on the subsequent iteration should be lower
                                   // than the Low price for the bottom found at the current iteration 
      k1=Low[min[1]];              // Low price for the bottom when searching for the next extreme point defines the High price,
                                   // above which the peak should be located
      k2=min[1];                   // search for the peak located after the bottom is performed from the detected bottom min[1]

      //--- loop defining the first peak - max[1]
      for(k=0;k<=12;k++)
        {
         max[1]=maximum(k2,bars,k1);    // define the nearest peak in a specified interval
         k1=High[max[1]]-delta;         // High price for the peak detected on the subsequent iteration should be higher
                                        // than the High price for the peak found at the current iteration 
         k2=max[1]+1;                   // at the next iteration, the search is performed from the already detected peak max[1]
         l1=High[max[1]];               // High price for the extreme point when searching for the next bottom defines the Low price,
                                        // below which the bottom should be located
         l2=max[1];                     // search for the bottom located after the peak is performed from the detected peak max[1]

         //--- loop defining the second bottom - min[2] and the second peak max[2]
         for(l=0;l<=10;l++)
           {
            min[2]=minimum(l2,bars,l1);                // define the nearest bottom within the specified interval
            l1=Low[min[2]]+delta;                      // Low price for the bottom detected on the subsequent iteration should be lower
                                                       // than the Low price for the bottom found at the current iteration 
            l2=min[2]+1;                               // at the next iteration, the search is performed from the already detected bottom min[2]
            max[2]=maximum(min[2],bars,Low[min[2]]);   // define the nearest peak in a specified interval

            //--- sort out coinciding extreme values and special cases
            if(max[1]>min[1] && min[1]>1 && min[2]>max[1] && min[2]<max[2] && max[2]<mag4)
              {
               mag1=min[1];   // at each iteration, locations of the detected extreme values are saved if the condition is met
               mag2=max[1];
               mag3=min[2];
               mag4=max[2];

              }
           }
        }
     }
   min[1]=mag1;   // extreme points are defined, otherwise the 'bars' value is assigned to all variables
   max[1]=mag2;
   min[2]=mag3;
   max[2]=mag4;

   min[1]=check_min(min[1],max[1]); // verify and correct the position of the first bottom within the specified interval  
   max[1]=check_max(max[1],min[2]); // verify and correct the position of the first peak within the specified interval
   min[2]=check_min(min[2],max[2]); // verify and correct the position of the second bottom within the specified interval 

   mag1=bars;
   mag2=bars;
   mag3=bars;
   mag4=bars;
// extreme points are defined similarly if the first of them is a peak
   j1=SymbolInfoDouble(Symbol(),SYMBOL_BID)-(1-first_extrem)*delta_points*Point();
   j2=0;

   for(j=0;j<=15;j++)
     {
      Max[1]=maximum(j2,bars,j1);
      j1=High[Max[1]]-delta;
      j2=Max[1]+1;
      k1=High[Max[1]];
      k2=Max[1];
      for(k=0;k<=12;k++)
        {
         Min[1]=minimum(k2,bars,k1);
         k1=Low[Min[1]]+delta;
         k2=Min[1]+1;
         l1=Low[Min[1]];
         l2=Min[1];
         for(l=0;l<=10;l++)
           {
            Max[2]=maximum(l2,bars,l1);
            l1=High[Max[2]]-delta;
            l2=Max[2]+1;
            Min[2]=minimum(Max[2],bars,High[Max[2]]);
            if(Max[2]>Min[1] && Min[1]>Max[1] && Max[1]>0 && Max[2]<Min[2] && Min[2]<mag4)
              {
               mag1=Max[1];
               mag2=Min[1];
               mag3=Max[2];
               mag4=Min[2];
              }
           }
        }
     }
   Max[1]=mag1;
   Min[1]=mag2;
   Max[2]=mag3;
   Min[2]=mag4;

   Max[1]=check_max(Max[1],Min[1]);
   Min[1]=check_min(Min[1],Max[2]);
   Max[2]=check_max(Max[2],Min[2]);
//--- if the bottom is located closer, its position as well as the positions of the related extreme values are displayed
   if(min[1]<Max[1])
     {
      //--- delete the labels made during the previous stage
      ObjectDelete(0,"id_1");
      ObjectDelete(0,"id_2");
      ObjectDelete(0,"id_3");
      ObjectDelete(0,"id_4");
      ObjectDelete(0,"id_5");
      ObjectDelete(0,"id_6");

      ObjectCreate(0,"id_1",OBJ_ARROW_UP,0,Time[min[1]],Low[min[1]]);      // highlight the first bottom
      ObjectSetInteger(0,"id_1",OBJPROP_ANCHOR,ANCHOR_TOP);                // for the first detected bottom, the binding is performed
                                                                           // by its position on the time series and the Low price

      ObjectCreate(0,"id_2",OBJ_ARROW_DOWN,0,Time[max[1]],High[max[1]]);   // highlight the first peak
      ObjectSetInteger(0,"id_2",OBJPROP_ANCHOR,ANCHOR_BOTTOM);             // for the first detected peak, the binding is performed by the position 
                                                                           // on the time series and the High price 

      ObjectCreate(0,"id_3",OBJ_ARROW_UP,0,Time[min[2]],Low[min[2]]);      // highlight the second bottom
      ObjectSetInteger(0,"id_3",OBJPROP_ANCHOR,ANCHOR_TOP);                // for the second detected bottom, the binding is performed by the position
                                                                           // on the time series and the Low price
     }
//--- if the peak is located closer, its position as well as the positions of the related extreme values are displayed
   if(min[1]>Max[1])
     {
      //--- delete the labels made during the previous stage
      ObjectDelete(0,"id_1");
      ObjectDelete(0,"id_2");
      ObjectDelete(0,"id_3");
      ObjectDelete(0,"id_4");
      ObjectDelete(0,"id_5");
      ObjectDelete(0,"id_6");

      ObjectCreate(0,"id_4",OBJ_ARROW_DOWN,0,Time[Max[1]],High[Max[1]]);   // highlight the first peak
      ObjectSetInteger(0,"id_4",OBJPROP_ANCHOR,ANCHOR_BOTTOM);             // for the first detected peak, the binding is performed by the position
                                                                           // on the time series and the High price

      ObjectCreate(0,"id_5",OBJ_ARROW_UP,0,Time[Min[1]],Low[Min[1]]);      // highlight the first bottom
      ObjectSetInteger(0,"id_5",OBJPROP_ANCHOR,ANCHOR_TOP);                // for the detected bottom, the binding is performed by the position
                                                                           // on the time series and the Low price 

      ObjectCreate(0,"id_6",OBJ_ARROW_DOWN,0,Time[Max[2]],High[Max[2]]);   // define the second peak
      ObjectSetInteger(0,"id_6",OBJPROP_ANCHOR,ANCHOR_BOTTOM);             // for the second detected peak, the binding is performed by the position
                                                                           // on the time series and the High price
     }
//--- if no extreme points are found, the appropriate message appears
   if(min[1]==Max[1])
     {
      Alert("Within the specified range, ",bars," no bars and extreme points found");
     }
//---
   return;
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- when unloading the indicator, all labels are removed  
   ObjectDelete(0,"id_1");
   ObjectDelete(0,"id_2");
   ObjectDelete(0,"id_3");
   ObjectDelete(0,"id_4");
   ObjectDelete(0,"id_5");
   ObjectDelete(0,"id_6");
//---
   return;
  }
//+------------------------------------------------------------------+
//| Define the nearest bottom within the specified interval          |
//| located below price0 at a distance > the variation range         |
//+------------------------------------------------------------------+
int minimum(int a,int b,double price0)
  {
   double High[],Low[];
   ArraySetAsSeries(Low,true);
   int copied4=CopyLow(Symbol(),0,0,bars+2,Low);
   int i,e;
   e=bars;
   double pr=price0-delta_points*Point(); // the price, below which the bottom with the added variation range should be located
//--- search for the bottom within the range specified by a and b parameters
   for(i=a;i<=b;i++)
     {
      //--- define the nearest bottom, after which the price growth starts 
      if(Low[i]<pr && Low[i]<Low[i+1])
        {
         e=i;
         break;
        }
     }
//---
   return(e);
  }
//+------------------------------------------------------------------+
//| Define the nearest peak within the specified interval            |
//| located above price1 at a distance > the variation range         |
//+------------------------------------------------------------------+
int maximum(int a,int b,double price1)
  {
   double High[],Low[];
   ArraySetAsSeries(High,true);
   int copied5=CopyHigh(Symbol(),0,0,bars+2,High);
   int i,e;
   e=bars;
   double pr1=price1+delta_points*Point();   // the price, above which the peak with the added variation range should be located
//--- search for the peak within the range specified by a and b parameters
   for(i=a;i<=b;i++)
     {
      //--- define the nearest peak, after which the price fall starts
      if(High[i]>pr1 && High[i]>High[i+1])
        {
         e=i;
         break;
        }
     }
//---
   return(e);
  }
//+-----------------------------------------------------------------------------+
//| Verifying and correcting the bottom position within the specified interval  |
//+-----------------------------------------------------------------------------+
int check_min(int a,int b)
  {
   double High[],Low[];
   ArraySetAsSeries(Low,true);
   int copied6=CopyLow(Symbol(),0,0,bars+1,Low);
   int i,c;
   c=a;
//--- when searching for the bottom, all bars specified by the range are verified
   for(i=a+1;i<b;i++)
     {
      //--- if the bottom located lower is found
      if(Low[i]<Low[a] && Low[i]<Low[c])
         c=i;                // the bottom location is redefined
     }
//---
   return(c);
  }
//+--------------------------------------------------------------------------+
//| Verifying and correcting the peak position within the specified interval |
//+--------------------------------------------------------------------------+
int check_max(int a,int b)
  {
   double High[],Low[];
   ArraySetAsSeries(High,true);
   int copied7=CopyHigh(Symbol(),0,0,bars+1,High);
   int i,d;
   d=a;
//--- when searching for the bottom, all bars specified by the range are verified
   for(i=(a+1);i<b;i++)
     {
      //--- if the peak located above is found
      if(High[i]>High[a] && High[i]>High[d])
         d=i;                // the peak location is redefined
     }
//---
   return(d);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+

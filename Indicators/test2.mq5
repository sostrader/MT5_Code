#property indicator_chart_window 
#property indicator_buffers 1 
#property indicator_plots   1 
//---- 图的线 
#property indicator_label1  "Line" 
#property indicator_type1   DRAW_LINE 
#property indicator_color1  clrDarkBlue 
#property indicator_style1  STYLE_SOLID 
#property indicator_width1  1 
//--- 指标缓冲区 
double         LineBuffer[]; 
//+------------------------------------------------------------------+ 
//| 自定义指标初始化函数                                                | 
//+------------------------------------------------------------------+ 
int OnInit() 
  { 
//--- 指标缓冲区绘图 
   SetIndexBuffer(0,LineBuffer,INDICATOR_DATA);
   //--- indicator digits
   IndicatorSetInteger(INDICATOR_DIGITS,0);
//--- indicator short name
   IndicatorSetString(INDICATOR_SHORTNAME,"test");
//--- set index draw begin
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,1); 
//--- 
   return(INIT_SUCCEEDED); 
  } 
//+------------------------------------------------------------------+ 
//| 自定义指标重复函数                                                  | 
//+------------------------------------------------------------------+ 
int OnCalculate(const int rates_total, 
                const int prev_calculated, 
                const datetime& time[], 
                const double& open[], 
                const double& high[], 
                const double& low[], 
                const double& close[], 
                const long& tick_volume[], 
                const long& volume[], 
                const int& spread[]
                ) 
  { 
   //--- check for bars count
      if(rates_total<2)
         return(0); //exit with zero result
   //--- get current position
      int pos=prev_calculated-1;
      if(pos<0) pos=0;
   //--- calculate with appropriate volumes
      if(InpVolumeType==VOLUME_TICK)
         Calculate(rates_total,pos,high,low,close,tick_volume);
      else
         Calculate(rates_total,pos,high,low,close,volume);
   //----
      return(rates_total);
  } 
//+------------------------------------------------------------------+
 


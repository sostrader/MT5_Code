//+------------------------------------------------------------------+
//|                                                         Tab1.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Program.mqh"
string forex_class_name[]={"USD","GBP","EUR","JPY","AUD","CHF","NZD","CAD","A-1","A-2","A-3","A-4","A-5","EURCHF"};
string period_string[]={"D1","M1","M5","M30","H1","H4"};
#define SYMBOL_CLASS_NUM ArraySize(forex_class_name)
#define PERIOD_NUM ArraySize(period_string)

ENUM_TIMEFRAMES period_tf[]={PERIOD_D1,PERIOD_M1,PERIOD_M5,PERIOD_M30,PERIOD_H1,PERIOD_H4};
color curve_color[]={clrRed,clrBlue,clrChartreuse,clrOrange,clrGreen,clrCyan,clrPurple,clrDeepPink,clrSienna};
//+------------------------------------------------------------------+
//| Create the "Point type" combo box                                |
//+------------------------------------------------------------------+
bool CProgram::CreateComboBoxSymbolType(const int x_gap,const int y_gap,const string text)
  {

//--- Store the pointer to the main control
   m_symbol_type.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_symbol_type);
//--- Properties
   m_symbol_type.XSize(100);
   m_symbol_type.ItemsTotal(SYMBOL_CLASS_NUM);
   m_symbol_type.GetButtonPointer().XSize(50);
   m_symbol_type.GetButtonPointer().AnchorRightWindowSide(true);
//--- Populate the combo box list
   for(int i=0; i<SYMBOL_CLASS_NUM; i++)
      m_symbol_type.SetValue(i,forex_class_name[i]);
//--- List properties
   CListView *lv=m_symbol_type.GetListViewPointer();
//lv.YSize(183);
   lv.LightsHover(true);
   lv.SelectItem(lv.SelectedItemIndex()==WRONG_VALUE ? 0 : lv.SelectedItemIndex());
//--- Create a control
   if(!m_symbol_type.CreateComboBox(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_symbol_type);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateComboBoxPeriodType(const int x_gap,const int y_gap,const string text)
  {

//--- Store the pointer to the main control
   m_period_type.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_period_type);
//--- Properties
   m_period_type.XSize(100);
   m_period_type.ItemsTotal(PERIOD_NUM);
   m_period_type.GetButtonPointer().XSize(50);
   m_period_type.GetButtonPointer().AnchorRightWindowSide(true);
//--- Populate the combo box list
   for(int i=0; i<PERIOD_NUM; i++)
      m_period_type.SetValue(i,period_string[i]);
//--- List properties
   CListView *lv=m_period_type.GetListViewPointer();
   lv.LightsHover(true);
   lv.SelectItem(lv.SelectedItemIndex()==WRONG_VALUE ? 1 : lv.SelectedItemIndex());
//--- Create a control
   if(!m_period_type.CreateComboBox(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_period_type);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateSepLine1(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_sep_line1.MainPointer(m_tabs1);
//--- Attach to tab
   m_tabs1.AddToElementsArray(0,m_sep_line1);
//--- Size
   int x_size=2;
   int y_size=60;
//--- Properties
   m_sep_line1.DarkColor(C'150,150,150');
   m_sep_line1.LightColor(clrWhite);
   m_sep_line1.TypeSepLine(V_SEP_LINE);
//--- Create control
   if(!m_sep_line1.CreateSeparateLine(x_gap,y_gap,x_size,y_size))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_sep_line1);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateSepLine2(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_sep_line2.MainPointer(m_tabs1);
//--- Attach to tab
   m_tabs1.AddToElementsArray(0,m_sep_line2);
//--- Size
   int x_size=2;
   int y_size=100;
//--- Properties
   m_sep_line2.DarkColor(C'150,150,150');
   m_sep_line2.LightColor(clrWhite);
   m_sep_line2.TypeSepLine(V_SEP_LINE);
//--- Create control
   if(!m_sep_line2.CreateSeparateLine(x_gap,y_gap,x_size,y_size))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_sep_line2);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateButtonsGroupDataType(const int x_gap,const int y_gap,const string text)
  {
   m_select_data_type.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_select_data_type);
   int buttons_y_offset[]={5,45};
   string buttons_text[]={"Ratio","Range"};
   m_select_data_type.ButtonYSize(14);
   m_select_data_type.IsCenterText(true);
   m_select_data_type.RadioButtonsMode(true);
   m_select_data_type.RadioButtonsStyle(true);
//--- Add buttons to the group
   for(int i=0; i<2; i++)
      m_select_data_type.AddButton(0,buttons_y_offset[i],buttons_text[i],70);
//--- Create a group of buttons
   if(!m_select_data_type.CreateButtonsGroup(x_gap,y_gap))
      return(false);
//--- Highlight the second button in the group
   m_select_data_type.SelectButton(0);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_select_data_type);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateButtonsGroupDataRange(const int x_gap,const int y_gap,const string text)
  {
   m_select_data_range.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_select_data_range);
   int buttons_y_offset[]={5,48,88};
   string buttons_text[]={"Fix Time","Dynamic","Fix Num."};
   m_select_data_range.ButtonYSize(14);
   m_select_data_range.IsCenterText(true);
   m_select_data_range.RadioButtonsMode(true);
   m_select_data_range.RadioButtonsStyle(true);
//--- Add buttons to the group
   for(int i=0; i<3; i++)
      m_select_data_range.AddButton(0,buttons_y_offset[i],buttons_text[i],70);
//--- Create a group of buttons
   if(!m_select_data_range.CreateButtonsGroup(x_gap,y_gap))
      return(false);
//--- Highlight the second button in the group
   m_select_data_range.SelectButton(2);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_select_data_range);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateCalendarFrom(const int x_gap,const int y_gap,const string text)
  {
   m_drop_calendar_from.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_drop_calendar_from);
   if(!m_drop_calendar_from.CreateDropCalendar(text,x_gap,y_gap))
      return false;
   m_drop_calendar_from.SelectedDate(D'2017.01.01');  
   CWndContainer::AddToElementsArray(0,m_drop_calendar_from);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateCalendarTo(const int x_gap,const int y_gap,const string text)
  {
   m_drop_calendar_to.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_drop_calendar_to);
   if(!m_drop_calendar_to.CreateDropCalendar(text,x_gap,y_gap))
      return false;
   m_drop_calendar_to.SelectedDate(TimeCurrent()-(int)MathMod(TimeCurrent(),24*60*60));   
   CWndContainer::AddToElementsArray(0,m_drop_calendar_to);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateCalendarBegin(const int x_gap,const int y_gap,const string text)
  {
   m_drop_calendar_begin.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_drop_calendar_begin);
   if(!m_drop_calendar_begin.CreateDropCalendar(text,x_gap,y_gap))
      return false;
   m_drop_calendar_begin.SelectedDate(D'2017.01.01');   
   CWndContainer::AddToElementsArray(0,m_drop_calendar_begin);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateTimeEditFrom(const int x_gap,const int y_gap,const string text)
  {
   m_time_edit_from.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_time_edit_from);
   if(!m_time_edit_from.CreateTimeEdit(text,x_gap,y_gap))
      return false;
   m_time_edit_from.XGap(x_gap+7);
   m_time_edit_from.SetHours(0);
   m_time_edit_from.SetMinutes(0);
   CWndContainer::AddToElementsArray(0,m_time_edit_from);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateTimeEditTo(const int x_gap,const int y_gap,const string text)
  {
   m_time_edit_to.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_time_edit_to);
   if(!m_time_edit_to.CreateTimeEdit(text,x_gap,y_gap))
      return false;
   m_time_edit_to.XGap(x_gap+7);
   m_time_edit_to.SetHours(0);
   m_time_edit_to.SetMinutes(0);
   CWndContainer::AddToElementsArray(0,m_time_edit_to);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateTimeEditBegin(const int x_gap,const int y_gap,const string text)
  {
   m_time_edit_begin.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_time_edit_begin);
   if(!m_time_edit_begin.CreateTimeEdit(text,x_gap,y_gap))
      return false;
   m_time_edit_begin.XGap(x_gap+7);
   m_time_edit_begin.SetHours(0);
   m_time_edit_begin.SetMinutes(0);
   CWndContainer::AddToElementsArray(0,m_time_edit_begin);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateTextEditFixNum(const int x_gap,const int y_gap,const string text)
  {
   m_fix_num.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_fix_num);

//--- Properties
   m_fix_num.XSize(100);
   m_fix_num.MaxValue(1000);
   m_fix_num.MinValue(60);
   m_fix_num.StepValue(10);
   m_fix_num.SetDigits(0);
   m_fix_num.SpinEditMode(true);
   m_fix_num.SetValue((string)500);
   m_fix_num.GetTextBoxPointer().XSize(50);
   m_fix_num.GetTextBoxPointer().AutoSelectionMode(true);
   m_fix_num.GetTextBoxPointer().AnchorRightWindowSide(true);

   if(!m_fix_num.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_fix_num);
   return(true);

  }
//+------------------------------------------------------------------+
//|                创建图表                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateGraph1(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_graph1.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_graph1);
//--- Properties
   m_graph1.AutoXResizeMode(true);
   m_graph1.AutoYResizeMode(true);
   m_graph1.AutoXResizeRightOffset(10);
   m_graph1.AutoYResizeBottomOffset(10);
////--- Create control
   if(!m_graph1.CreateGraph(x_gap,y_gap))
      return(false);
////--- Chart properties
   CGraphic *graph=m_graph1.GetGraphicPointer();
//graph.BackgroundColor(::ColorToARGB(clrWhiteSmoke));
//
   InitGraphArrays();
////--- Create the curves 

   CCurve *data_curve[];
   ArrayResize(data_curve,fcmp.ff.GetSymbolNum());
   
   string price_type=m_select_data_type.SelectedButtonIndex()==0?"ratio":"range";
   for(int i=0;i<fcmp.ff.GetSymbolNum();i++)
     {
      double price[],time[];
      fcmp.GetMarketPriceAt(i,price_type,price,time);
      data_curve[i]=graph.CurveAdd(time,price,::ColorToARGB(curve_color[i]),CURVE_LINES,fcmp.ff.GetSymbolNameAt(i));
      data_curve[i].LinesWidth(2);
     }

   graph.GridBackgroundColor(clrWhiteSmoke);
   graph.GridLineColor(clrLightGray);
//--- Plot the data on the chart
   graph.CurvePlotAll();
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_graph1);
   return true;
  }
//+------------------------------------------------------------------+
//|             初始化图表数据                            |
//+------------------------------------------------------------------+
void CProgram::InitGraphArrays(void)
  {
   int period_choose=m_period_type.GetListViewPointer().SelectedItemIndex();
   int symbol_choose=m_symbol_type.GetListViewPointer().SelectedItemIndex();
   
   int p_num_choose=(int)m_fix_num.GetValue();
   datetime from=m_drop_calendar_from.SelectedDate()+m_time_edit_from.GetHours()*60*60+m_time_edit_from.GetMinutes()*60;
   datetime to=m_drop_calendar_to.SelectedDate()+m_time_edit_to.GetHours()*60*60+m_time_edit_to.GetMinutes()*60;
   datetime begin=m_drop_calendar_begin.SelectedDate()+m_time_edit_begin.GetHours()*60*60+m_time_edit_begin.GetMinutes()*60;
   if(m_select_data_range.SelectedButtonIndex()==0)
     {
      fcmp.Init1(forex_class_name[symbol_choose],period_tf[period_choose],from,to);
     }
   else if(m_select_data_range.SelectedButtonIndex()==1)
      {
       fcmp.Init2(forex_class_name[symbol_choose],period_tf[period_choose],begin);
      }
   else
      {
       fcmp.Init3(forex_class_name[symbol_choose],period_tf[period_choose],p_num_choose);
      }
   //fcmp.RefreshMarketPrice();
  }
//+------------------------------------------------------------------+
//|           更新图表                          |
//+------------------------------------------------------------------+
void CProgram::UpdateGraph(void)
  {
   InitGraphArrays();
   CGraphic *graph=m_graph1.GetGraphicPointer();

//--- Create the curves
   string price_type=m_select_data_type.SelectedButtonIndex()==0?"ratio":"range"; 
   for(int i=0;i<graph.CurvesTotal();i++)
     {
      double price[],time[];
      fcmp.GetMarketPriceAt(i,price_type,price,time);
      CCurve *curve=graph.CurveGetByIndex(i);
      curve.Update(time,price);
      curve.Name(fcmp.ff.GetSymbolNameAt(i));
     }
   graph.Redraw(true);
   graph.Update();
  }
//+------------------------------------------------------------------+
//|            图形重置                                 |
//+------------------------------------------------------------------+
void CProgram::ResetGraph(void)
  {
   InitGraphArrays();
   CGraphic *graph=m_graph1.GetGraphicPointer();
   while(graph.CurvesTotal()>0)
      graph.CurveRemoveByIndex(graph.CurvesTotal()-1);

   CCurve *data_curve[];
   //Print("symbol num: ",fcmp.ff.GetSymbolNum());
   //for(int i=0;i<fcmp.ff.GetSymbolNum();i++)
   //  {
   //   Print("symbol:", fcmp.ff.GetSymbolNameAt(i));
   //  }
   ArrayResize(data_curve,fcmp.ff.GetSymbolNum());
   string price_type=m_select_data_type.SelectedButtonIndex()==0?"ratio":"range";
   for(int i=0;i<fcmp.ff.GetSymbolNum();i++)
     {
      double price[],time[];
      fcmp.GetMarketPriceAt(i,price_type,price,time);
      data_curve[i]=graph.CurveAdd(time,price,::ColorToARGB(curve_color[i]),CURVE_LINES,fcmp.ff.GetSymbolNameAt(i));
      data_curve[i].LinesWidth(2);
     }
   graph.CurvePlotAll();
   graph.Redraw(true);
   graph.Update();
  }
//+------------------------------------------------------------------+

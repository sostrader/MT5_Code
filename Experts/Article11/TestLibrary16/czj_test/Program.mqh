//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <EasyAndFastGUI\WndEvents.mqh>
#include <EasyAndFastGUI\TimeCounter.mqh>
#include <czj_tools\MarketPrice.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CProgram:public CWndEvents
  {
protected:
   CTimeCounter      m_counter1; // for updating the execution process
   CTimeCounter      m_counter2; // for updating the items in the status bar
   CWindow           m_window;
   CStatusBar        m_status_bar;
   CPicture          m_picture1;
   CComboBox         m_period_type;
   CComboBox         m_symbol_type;
   CTextEdit         m_price_size;
   CGraph            m_graph1;
   //MultiSymbolPrice  msp;
   ForexClassMarketPrice fcmp;


public:
                     CProgram(void);
   bool              CreateGUI(void);
   void              OnTimerEvent(void);
   void              OnDeinitEvent(const int reason);

protected:
   bool              CreateWindow(const string text);
   bool              CreateStatusBar(const int x_gap,const int y_gap);
   bool              CreatePicture1(const int x_gap,const int y_gap);
   bool              CreateComboBoxPeriodType(const int x_gap,const int y_gap,const string text);
   bool              CreateComboBoxSymbolType(const int x_gap,const int y_gap,const string text);
   bool              CreateTextEditPriceSize(const int x_gap,const int y_gap,const string text);
   bool              CreateGraph1(const int x_gap,const int y_gap);
   void              UpdateGraph(void);
   void              ResetGraph(void);
   void              InitGraphArrays();
   void              ResizeGraphArrays(const int new_size);
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CProgram::CProgram(void)
  {
   m_counter1.SetParameters(10,10000);
   m_counter2.SetParameters(30,35);
  }

#include "MainWindow.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
  {
   if(!CreateWindow("czjtest"))
      return false;
   if(!CreateStatusBar(1,25))
      return false;
   if(!CreatePicture1(10,10))
      return false;
   if(!CreateComboBoxPeriodType(10,30,"Period"))
      return false;
   if(!CreateComboBoxSymbolType(150,30,"Symbol"))
      return false;
   if(!CreateTextEditPriceSize(300,30,"Number"))
      return false;
   if(!CreateGraph1(10,50))
      return false;
   CWndEvents::CompletedGUI();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
    if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)
     {
      if(lparam==m_symbol_type.Id())
        {
         ResetGraph();
         return;
        }
      if(lparam==m_period_type.Id())//更新曲线数据
         {
          UpdateGraph();
          return;
         }  
     }
    if(id==CHARTEVENT_CUSTOM+ON_END_EDIT||id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(lparam==m_price_size.Id())//更新曲线数据
         {
          UpdateGraph();
          return;
         }  
     }
  }
//+------------------------------------------------------------------+
void CProgram::OnTimerEvent(void)
  {
   CWndEvents::OnTimerEvent();
//--- Update the chart by timer
   if(m_counter1.CheckTimeCounter())
     {
      UpdateGraph();
     }
//---
   if(m_counter2.CheckTimeCounter())
     {
      if(m_status_bar.IsVisible())
        {
         static int index=0;
         index=(index+1>3)? 0 : index+1;
         m_status_bar.GetItemPointer(1).ChangeImage(0,index);
         m_status_bar.GetItemPointer(1).Update(true);
        }
     }
    
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason)
  {
//--- Removing the interface
   CWndEvents::Destroy();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <Math\Stat\Stat.mqh>
#include <EasyAndFastGUI\WndEvents.mqh>
#include <EasyAndFastGUI\TimeCounter.mqh>
//+------------------------------------------------------------------+
//| Class for creating an application                                |
//+------------------------------------------------------------------+
class CProgram : public CWndEvents
  {
protected:
   //--- Time counters
   CTimeCounter      m_counter1; // for updating the execution process
   CTimeCounter      m_counter2; // for updating the items in the status bar
   //--- Main window
   CWindow           m_window;
   //--- Status bar
   CStatusBar        m_status_bar;
   //--- Icon
   CPicture          m_picture1;
   //--- Controls for managing the chart
   CTextEdit         m_a_inc;
   CTextEdit         m_b_inc;
   CTextEdit         m_t_inc;
   //---
   CSeparateLine     m_sep_line1;
   //---
   CTextEdit         m_animate;
   CTextEdit         m_array_size;
   CButton           m_random;
   //---
   CSeparateLine     m_sep_line2;
   //---
   CCheckBox         m_line_smooth;
   CComboBox         m_curve_type;
   CComboBox         m_point_type;
   //--- Chart
   CGraph            m_graph1;

   //--- Arrays of data for calculations
   double            a_inc[];
   double            b_inc[];
   double            t_inc[];
   double            x_source[];
   double            y_source[];
   //--- Arrays of data for output to the chart
   double            x_norm[];
   double            y_norm[];
   //--- To calculate the mean and standard deviation
   double            x_mean;
   double            y_mean;
   double            x_sdev;
   double            y_sdev;
   //---
public:
                     CProgram(void);
                    ~CProgram(void);
   //--- Initialization/deinitialization
   void              OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   //--- Timer
   void              OnTimerEvent(void);
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

   //--- Create the graphical interface of the program
   bool              CreateGUI(void);
   //---
protected:
   //--- Main window
   bool              CreateWindow(const string text);
   //--- Status bar
   bool              CreateStatusBar(const int x_gap,const int y_gap);
   //--- Pictures
   bool              CreatePicture1(const int x_gap,const int y_gap);
   //--- Controls for managing the chart
   bool              CreateSpinEditAInc(const int x_gap,const int y_gap,const string text);
   bool              CreateSpinEditBInc(const int x_gap,const int y_gap,const string text);
   bool              CreateSpinEditTInc(const int x_gap,const int y_gap,const string text);
   //---
   bool              CreateSepLine1(const int x_gap,const int y_gap);
   //---
   bool              CreateCheckBoxEditAnimate(const int x_gap,const int y_gap,const string text);
   bool              CreateSpinEditArraySize(const int x_gap,const int y_gap,const string text);
   bool              CreateButtonRandom(const int x_gap,const int y_gap,const string text);
   //---
   bool              CreateSepLine2(const int x_gap,const int y_gap);
   //---
   bool              CreateCheckBoxLineSmooth(const int x_gap,const int y_gap,const string text);
   bool              CreateComboBoxCurveType(const int x_gap,const int y_gap,const string text);
   bool              CreateComboBoxPointType(const int x_gap,const int y_gap,const string text);
   //--- Chart
   bool              CreateGraph1(const int x_gap,const int y_gap);
   //---
private:
   //--- Resize the arrays
   void              ResizeArrays(void);
   //--- Initialization of the auxiliary arrays for calculations
   void              InitArrays(void);
   //--- Set and update series on the chart
   void              UpdateSeries(void);
   //--- Recalculate the series on the chart
   void              RecalculatingSeries(void);
   //--- Add text to the chart
   void              TextAdd(void);

   //--- Update the chart by timer
   void              UpdateGraphByTimer(void);
   //--- Animate the chart series
   void              AnimateGraphSeries(void);
  };
//+------------------------------------------------------------------+
//| Creating controls                                                |
//+------------------------------------------------------------------+
#include "MainWindow.mqh"
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgram::CProgram(void) : x_mean(0),
                           y_mean(0),
                           x_sdev(0),
                           y_sdev(0)
  {
//--- Setting parameters for the time counters
   m_counter1.SetParameters(16,16);
   m_counter2.SetParameters(16,35);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CProgram::~CProgram(void)
  {
  }
//+------------------------------------------------------------------+
//| Initialization                                                    |
//+------------------------------------------------------------------+
void CProgram::OnInitEvent(void)
  {
  }
//+------------------------------------------------------------------+
//| Uninitialization                                                 |
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason)
  {
//--- Removing the interface
   CWndEvents::Destroy();
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CProgram::OnTimerEvent(void)
  {
   CWndEvents::OnTimerEvent();
//--- Update the chart by timer
   if(m_counter1.CheckTimeCounter())
     {
      UpdateGraphByTimer();
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
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Event of changing the checkbox state
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_CHECKBOX)
     {
      if(lparam==m_line_smooth.Id())
        {
         //--- Recalculate the series on the chart
         RecalculatingSeries();
         return;
        }
      return;
     }
//--- Selection of item in combobox event
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)
     {
      if(lparam==m_curve_type.Id() || lparam==m_point_type.Id())
        {
         //--- Recalculate the series on the chart
         RecalculatingSeries();
         return;
        }
      return;
     }
//--- Event of entering new value in the edit box
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      if(lparam==m_a_inc.Id() || lparam==m_b_inc.Id() ||
         lparam==m_t_inc.Id() || lparam==m_animate.Id() ||
         lparam==m_array_size.Id())
        {
         //--- Recalculate the series on the chart
         RecalculatingSeries();
         return;
        }
      return;
     }
//--- Event of clicking the edit box spin buttons
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(lparam==m_random.Id())
        {
         //--- Set random values
         m_a_inc.SetValue(string(::rand()%1000)+"."+string(::rand()%100),false);
         m_b_inc.SetValue(string(::rand()%1000)+"."+string(::rand()%100),false);
         m_t_inc.SetValue(string(::rand()%1000)+"."+string(::rand()%100),false);
         //--- Update the spin edit boxes
         m_a_inc.GetTextBoxPointer().Update(true);
         m_b_inc.GetTextBoxPointer().Update(true);
         m_t_inc.GetTextBoxPointer().Update(true);
         //--- Recalculate the series on the chart
         RecalculatingSeries();
         return;
        }
      //---
      if(lparam==m_a_inc.Id() || lparam==m_b_inc.Id() ||
         lparam==m_t_inc.Id() || lparam==m_animate.Id() ||
         lparam==m_array_size.Id())
        {
         //--- Recalculate the series on the chart
         RecalculatingSeries();
         return;
        }
      return;
     }
  }
//+------------------------------------------------------------------+
//| Create the graphical interface of the program                    |
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
  {
//--- Creating a panel
   if(!CreateWindow("EXPERT PANEL"))
      return(false);
//--- Status bar
   if(!CreateStatusBar(1,23))
      return(false);
//--- Pictures
   if(!CreatePicture1(10,10))
      return(false);
//--- Controls for managing the chart
   if(!CreateSpinEditAInc(7,25,"a:"))
      return(false);
   if(!CreateSpinEditBInc(7,50,"b:"))
      return(false);
   if(!CreateSpinEditTInc(7,75,"t:"))
      return(false);
//---
   if(!CreateSepLine1(110,25))
      return(false);
//---
   if(!CreateCheckBoxEditAnimate(125,25,"Animate:"))
      return(false);
   if(!CreateSpinEditArraySize(125,50,"Array size:"))
      return(false);
   if(!CreateButtonRandom(125,75,"Random"))
      return(false);
//---
   if(!CreateSepLine2(280,25))
      return(false);
//---
   if(!CreateCheckBoxLineSmooth(295,29,"Line smooth"))
      return(false);
   if(!CreateComboBoxCurveType(295,50,"Curve type:"))
      return(false);
   if(!CreateComboBoxPointType(295,75,"Point type:"))
      return(false);
//--- Chart
   if(!CreateGraph1(2,100))
      return(false);
//--- Finishing the creation of GUI
   CWndEvents::CompletedGUI();
   return(true);
  }
//+------------------------------------------------------------------+

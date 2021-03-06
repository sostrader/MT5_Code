//+------------------------------------------------------------------+
//|                                                      Tooltip.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Class for creating the tooltip                                   |
//+------------------------------------------------------------------+
class CTooltip : public CElement
  {
private:
   //--- Pointer to the control to which the tooltip is attached
   CElement         *m_element;
   //--- Text and color of the header
   string            m_header_text;
   color             m_header_color;
   //--- Array of lines of the tooltip text
   string            m_tooltip_lines[];
   //---
public:
                     CTooltip(void);
                    ~CTooltip(void);
   //--- Method for creating the tooltip
   bool              CreateTooltip(void);
   //---
private:
   void              InitializeProperties(void);
   bool              CreateCanvas(void);
   //---
public:
   //--- (1) Stores the control pointer, (2) the tooltip header
   void              ElementPointer(CElement &object) { m_element=::GetPointer(object); }
   void              HeaderText(const string text)    { m_header_text=text;             }
   void              HeaderColor(const color clr)     { m_header_color=clr;             }
   //--- Adds the line for the tooltip
   void              AddString(const string text);

   //--- (1) Shows and (2) hides the toopltip
   void              ShowTooltip(void);
   void              FadeOutTooltip(void);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Management
   virtual void      Reset(void);
   virtual void      Delete(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTooltip::CTooltip(void) : m_header_text(""),
                           m_header_color(C'50,50,50')
  {
//--- Store the name of the control class in the base class  
   CElement::ClassName(CLASS_NAME);
//--- Initially completely transparent
   CElement::Alpha(0);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTooltip::~CTooltip(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CTooltip::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the control is hidden
      if(!CElement::IsVisible())
         return;
      //--- Leave, if the tooltip button on the form is disabled
      if(!m_wnd.IsTooltip())
         return;
      //--- If the form is locked, hide the tooltip
      if(m_main.IsLocked())
        {
         FadeOutTooltip();
         return;
        }
      //--- If the focus is on the control, show the tooltip
      if(m_element.MouseFocus())
         ShowTooltip();
      //--- If there is no focus, hide the tooltip
      else
         FadeOutTooltip();
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Creates the Tooltip object                                       |
//+------------------------------------------------------------------+
bool CTooltip::CreateTooltip(void)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Leave, if there is no pointer to control
   if(::CheckPointer(m_element)==POINTER_INVALID)
     {
      ::Print(__FUNCTION__," > Before creating the tooltip, the class must be passed "
              "the control pointer: CTooltip::ElementPointer(CElement &object).");
      return(false);
     }
//--- Initialization of the properties
   InitializeProperties();
//--- Creates the tooltip
   if(!CreateCanvas())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTooltip::InitializeProperties(void)
  {
   m_x        =CElement::CalculateX(m_element.XGap());
   m_y        =CElement::CalculateY(m_element.YGap()+m_element.YSize()+1);
   m_x_size   =(m_x_size<1)? 100 : m_x_size;
   m_y_size   =(m_y_size<1)? 50 : m_y_size;
//--- Default colors
   m_border_color =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
   m_label_color  =(m_label_color!=clrNONE)? m_label_color : clrDimGray;
//--- Offsets from the extreme point
   CElement::XGap(CElement::CalculateXGap(m_x));
   CElement::YGap(CElement::CalculateYGap(m_y));
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CTooltip::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("tooltip");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Clearing the canvas
   m_canvas.Erase(::ColorToARGB(clrNONE,0));
   m_canvas.Update();
//--- Reset the priority for clicking
   Z_Order(WRONG_VALUE);
   return(true);
  }
//+------------------------------------------------------------------+
//| Adds a line                                                      |
//+------------------------------------------------------------------+
void CTooltip::AddString(const string text)
  {
//--- Increase the array size by one element
   int array_size=::ArraySize(m_tooltip_lines);
   ::ArrayResize(m_tooltip_lines,array_size+1);
//--- Store the value of passed parameters
   m_tooltip_lines[array_size]=text;
  }
//+------------------------------------------------------------------+
//| Shows the tooltip                                                |
//+------------------------------------------------------------------+
void CTooltip::ShowTooltip(void)
  {
//--- Leave, if the tooltip is 100% visible
   if(m_alpha>=255)
      return;
//--- Coordinates and margins for the header
   int x=5,y=5;
   int y_offset=15;
//--- Indication of a completely visible tooltip
   m_alpha=255;
//--- Draw the background and border
   DrawBackground();
   DrawBorder();
//--- Draw the header (if specified)
   if(m_header_text!="")
     {
      //--- Set font parameters
      m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_BLACK);
      //--- Draw the header text
      m_canvas.TextOut(x,y,m_header_text,::ColorToARGB(m_header_color),TA_LEFT|TA_TOP);
     }
//--- Coordinates for the main text of the tooltip (considering the presence of the header)
   x =(m_header_text!="")? 15 : 5;
   y =(m_header_text!="")? 25 : 5;
//--- Set font parameters
   m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_THIN);
//--- Draw the main text of the tooltip
   int lines_total=::ArraySize(m_tooltip_lines);
   for(int i=0; i<lines_total; i++)
     {
      m_canvas.TextOut(x,y,m_tooltip_lines[i],::ColorToARGB(m_label_color),TA_LEFT|TA_TOP);
      y=y+y_offset;
     }
//--- Update the canvas
   m_canvas.Update();
  }
//+------------------------------------------------------------------+
//| Gradual fading of the tooltip                                    |
//+------------------------------------------------------------------+
void CTooltip::FadeOutTooltip(void)
  {
//--- Leave, if the tooltip is 100% hidden
   if(m_alpha<1)
      return;
//--- Margin for the header
   int y_offset=15;
//--- Transparency step
   uchar fadeout_step=7;
//--- Initial value
   uchar alpha=m_alpha;
//--- Gradual fading of the tooltip
   for(uchar a=alpha; a>=0; a-=fadeout_step)
     {
      m_alpha=a;
      //--- If the next step makes it negative, stop the loop
      if(a-fadeout_step<0)
        {
         m_alpha=0;
         m_canvas.Erase(::ColorToARGB(clrNONE,m_alpha));
         m_canvas.Update();
         break;
        }
      //--- Coordinates for the header
      int x=5,y=5;
      //--- Draw the background and border
      DrawBackground();
      DrawBorder();
      //--- Draw the header (if specified)
      if(m_header_text!="")
        {
         //--- Set font parameters
         m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_BLACK);
         //--- Draw the header text
         m_canvas.TextOut(x,y,m_header_text,::ColorToARGB(m_header_color,m_alpha),TA_LEFT|TA_TOP);
        }
      //--- Coordinates for the main text of the tooltip (considering the presence of the header)
      x =(m_header_text!="")? 15 : 5;
      y =(m_header_text!="")? 25 : 5;
      //--- Set font parameters
      m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_THIN);
      //--- Draw the main text of the tooltip
      int lines_total=::ArraySize(m_tooltip_lines);
      for(int i=0; i<lines_total; i++)
        {
         m_canvas.TextOut(x,y,m_tooltip_lines[i],::ColorToARGB(m_label_color,m_alpha),TA_LEFT|TA_TOP);
         y=y+y_offset;
        }
      //--- Update the canvas
      m_canvas.Update();
     }
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CTooltip::Reset(void)
  {
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CTooltip::Delete(void)
  {
//--- Removing objects
   CElement::Delete();
//--- Emptying the control arrays
   ::ArrayFree(m_tooltip_lines);
  }
//+------------------------------------------------------------------+

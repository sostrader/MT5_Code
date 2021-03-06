//+------------------------------------------------------------------+
//|                                                    TextLabel.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Class for creating a text label                                  |
//+------------------------------------------------------------------+
class CTextLabel : public CElement
  {
public:
                     CTextLabel(void);
                    ~CTextLabel(void);
   //--- Methods for creating a text label
   bool              CreateTextLabel(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   //---
public:
   //--- Draws the control
   virtual void      Draw(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTextLabel::CTextLabel(void)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTextLabel::~CTextLabel(void)
  {
  }
//+------------------------------------------------------------------+
//| Creates a group of text edit box objects                         |
//+------------------------------------------------------------------+
bool CTextLabel::CreateTextLabel(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTextLabel::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1)? 100 : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Default background color
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Margins and color of the text label
   m_label_color =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CTextLabel::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("text_label");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CTextLabel::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw icon
   CElement::DrawImage();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+

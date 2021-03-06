//+------------------------------------------------------------------+
//|                                               PicturesSlider.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Picture.mqh"
#include "Button.mqh"
#include "ButtonsGroup.mqh"
//--- Default picture
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp64\\no_image.bmp"
//+------------------------------------------------------------------+
//| Class for creating the Picture Slider                            |
//+------------------------------------------------------------------+
class CPicturesSlider : public CElement
  {
private:
   //--- Objects for creating the control
   CPicture          m_pictures[];
   CButtonsGroup     m_radio_buttons;
   CButton           m_left_arrow;
   CButton           m_right_arrow;
   //--- Array of pictures (path to pictures)
   string            m_file_path[];
   //--- Default path to the picture
   string            m_default_path;
   //--- Margin for the pictures along the Y axis
   int               m_pictures_y_gap;
   //--- Margins for buttons
   int               m_arrows_x_gap;
   int               m_arrows_y_gap;
   //--- Width of the radio button
   int               m_radio_button_width;
   //--- Margins for radio buttons
   int               m_radio_buttons_x_gap;
   int               m_radio_buttons_y_gap;
   int               m_radio_buttons_x_offset;
   //---
public:
                     CPicturesSlider(void);
                    ~CPicturesSlider(void);
   //--- Methods for creating the Picture Slider
   bool              CreatePicturesSlider(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreatePictures(void);
   bool              CreateRadioButtons(void);
   bool              CreateArrow(CButton &button_obj,const int index);
   //---
public:
   //--- Returns pointers to components
   CButtonsGroup    *GetRadioButtonsPointer(void)            { return(::GetPointer(m_radio_buttons)); }
   CButton          *GetLeftArrowPointer(void)               { return(::GetPointer(m_left_arrow));    }
   CButton          *GetRightArrowPointer(void)              { return(::GetPointer(m_right_arrow));   }
   CPicture         *GetPicturePointer(const uint index);
   //--- Margins for arrow buttons
   void              ArrowsXGap(const int x_gap)             { m_arrows_x_gap=x_gap;                  }
   void              ArrowsYGap(const int y_gap)             { m_arrows_y_gap=y_gap;                  }
   //--- (1) Returns the number of pictures, (2) margin for the pictures along the Y axis
   int               PicturesTotal(void)               const { return(::ArraySize(m_pictures));       }
   void              PictureYGap(const int y_gap)            { m_pictures_y_gap=y_gap;                }
   //--- (1) Margins of the radio buttons, (2) distance between the radio buttons
   void              RadioButtonsXGap(const int x_gap)       { m_radio_buttons_x_gap=x_gap;           }
   void              RadioButtonsYGap(const int y_gap)       { m_radio_buttons_y_gap=y_gap;           }
   void              RadioButtonsXOffset(const int x_offset) { m_radio_buttons_x_offset=x_offset;     }
   //--- Add picture
   void              AddPicture(const string file_path="");
   //--- Switches the picture at the specified index
   void              SelectPicture(const int index);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Show, delete
   virtual void      Show(void);
   virtual void      Delete(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handling the pressing on the radio button
   bool              OnClickRadioButton(const string clicked_object,const int id,const int index);
   //--- Handling the clicking of left button
   bool              OnClickLeftArrow(const string clicked_object,const int id,const int index);
   //--- Handling the clicking of right button
   bool              OnClickRightArrow(const string clicked_object,const int id,const int index);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPicturesSlider::CPicturesSlider(void) : m_default_path("Images\\EasyAndFastGUI\\Icons\\bmp64\\no_image.bmp"),
                                         m_arrows_x_gap(2),
                                         m_arrows_y_gap(2),
                                         m_radio_button_width(18),
                                         m_radio_buttons_x_gap(25),
                                         m_radio_buttons_y_gap(1),
                                         m_radio_buttons_x_offset(20),
                                         m_pictures_y_gap(25)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPicturesSlider::~CPicturesSlider(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CPicturesSlider::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Pressing the radio button
      if(OnClickRadioButton(sparam,(int)lparam,(int)dparam))
         return;
      //--- If an arrow button of the slider was clicked, switch the picture
      if(OnClickLeftArrow(sparam,(int)lparam,(int)dparam))
         return;
      if(OnClickRightArrow(sparam,(int)lparam,(int)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Creates the control                                              |
//+------------------------------------------------------------------+
bool CPicturesSlider::CreatePicturesSlider(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreatePictures())
      return(false);
   if(!CreateRadioButtons())
      return(false);
   if(!CreateArrow(m_left_arrow,0))
      return(false);
   if(!CreateArrow(m_right_arrow,1))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CPicturesSlider::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
   m_x_size =(m_x_size<1)? 300 : m_x_size;
   m_y_size =(m_y_size<1)? 300 : m_y_size;
//--- Default properties
   m_back_color   =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_border_color =(m_border_color!=clrNONE)? m_border_color : m_main.BackColor();
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CPicturesSlider::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("pictures_slider");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create group of pictures                                         |
//+------------------------------------------------------------------+
bool CPicturesSlider::CreatePictures(void)
  {
//--- Get the number of pictures
   int pictures_total=PicturesTotal();
//--- If there is no picture in the group, report
   if(pictures_total<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "if a group contains at least one picture! Use the CPicturesSlider::AddPicture() method");
      return(false);
     }
//--- Coordinates
   int x=0,y=m_pictures_y_gap;
//--- Size
   int x_size=0,y_size=0;
//--- Array for the image
   uint image_data[];
//---
   for(int i=0; i<pictures_total; i++)
     {
      //--- Store the window pointer
      m_pictures[i].MainPointer(this);
      //--- Read the image data
      if(!::ResourceReadImage("::"+m_file_path[i],image_data,x_size,y_size))
        {
         ::Print(__FUNCTION__," > Error when reading the image ("+m_file_path[i]+"): ",::GetLastError());
         return(false);
        }
      //--- Calculate the offset
      x=(m_x_size>>1)-(x_size>>1);
      //--- Properties
      m_pictures[i].Index(i);
      m_pictures[i].XSize(x_size);
      m_pictures[i].YSize(y_size);
      m_pictures[i].NamePart("picture_slider");
      m_pictures[i].IconFile(m_file_path[i]);
      m_pictures[i].IconFileLocked(m_file_path[i]);
      //--- Creating the button
      if(!m_pictures[i].CreatePicture(x,y))
         return(false);
      //--- Add the control to the array
      CElement::AddToArray(m_pictures[i]);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates group of radio buttons                                   |
//+------------------------------------------------------------------+
bool CPicturesSlider::CreateRadioButtons(void)
  {
//--- Store the pointer to the parent control
   m_radio_buttons.MainPointer(this);
//--- Coordinates
   int x=m_radio_buttons_x_gap,y=m_radio_buttons_y_gap;
//--- The number of pictures
   int pictures_total=PicturesTotal();
//--- Properties
   int buttons_x_offset[];
//--- Set the array sizes
   ::ArrayResize(buttons_x_offset,pictures_total);
//--- Margins between the radio buttons
   for(int i=0; i<pictures_total; i++)
      buttons_x_offset[i]=(i>0)? buttons_x_offset[i-1]+m_radio_buttons_x_offset : 0;
//---
   m_radio_buttons.NamePart("radio_button");
   m_radio_buttons.RadioButtonsMode(true);
   m_radio_buttons.RadioButtonsStyle(true);
//--- Add buttons to the group
   for(int i=0; i<pictures_total; i++)
      m_radio_buttons.AddButton(buttons_x_offset[i],0,"",m_radio_button_width);
//--- Create a group of buttons
   if(!m_radio_buttons.CreateButtonsGroup(x,y))
      return(false);
//--- Show picture at the selected radio button
   SelectPicture(1);
//--- Add the control to the array
   CElement::AddToArray(m_radio_buttons);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a button with an arrow                                   |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\left_thin_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\right_thin_black.bmp"
//---
bool CPicturesSlider::CreateArrow(CButton &button_obj,const int index)
  {
//--- Store the pointer to the main control
   button_obj.MainPointer(this);
//--- Coordinates
   int x =(index<1)? m_arrows_x_gap : m_arrows_x_gap+16;
   int y =m_arrows_y_gap;
//--- Set properties before creation
   button_obj.Index(index);
   button_obj.XSize(16);
   button_obj.YSize(16);
//--- Button icons
   if(index<1)
     {
      button_obj.IconFile("Images\\EasyAndFastGUI\\Controls\\left_thin_black.bmp");
      button_obj.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\left_thin_black.bmp");
     }
   else
     {
      button_obj.IconFile("Images\\EasyAndFastGUI\\Controls\\right_thin_black.bmp");
      button_obj.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\right_thin_black.bmp");
      button_obj.AnchorRightWindowSide(true);
     }
//--- Create a control
   if(!button_obj.CreateButton("",x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(button_obj);
   return(true);
  }
//+------------------------------------------------------------------+
//| Add picture                                                      |
//+------------------------------------------------------------------+
CPicture *CPicturesSlider::GetPicturePointer(const uint index)
  {
   uint array_size=PicturesTotal();
//--- Verifying the size of the object array
   if(array_size<1)
     {
      Print(__FUNCTION__," > The group has no controls!");
      return(NULL);
     }
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the object pointer
   return(::GetPointer(m_pictures[i]));
  }
//+------------------------------------------------------------------+
//| Add picture                                                      |
//+------------------------------------------------------------------+
void CPicturesSlider::AddPicture(const string file_path="")
  {
//--- Increase the array size by one element
   int array_size=::ArraySize(m_pictures);
   int new_size=array_size+1;
   ::ArrayResize(m_pictures,new_size);
   ::ArrayResize(m_file_path,new_size);
//--- Store the value of passed parameters
   m_file_path[array_size]=(file_path=="")? m_default_path : file_path;
  }
//+------------------------------------------------------------------+
//| Specifies the picture to be displayed                            |
//+------------------------------------------------------------------+
void CPicturesSlider::SelectPicture(const int index)
  {
//--- Get the number of pictures
   int pictures_total=PicturesTotal();
//--- If there is no picture in the group, report
   if(pictures_total<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "if a group contains at least one picture! Use the CPicturesSlider::AddPicture() method");
      return;
     }
//--- Adjust the index value if the array range is exceeded
   uint correct_index=(index>=pictures_total)? pictures_total-1 :(index<0)? 0 : index;
//--- Select the radio button at this index
   m_radio_buttons.SelectButton(correct_index);
//--- Switch to picture
   for(int i=0; i<pictures_total; i++)
     {
      if(i==correct_index)
         m_pictures[i].Show();
      else
         m_pictures[i].Hide();
     }
  }
//+------------------------------------------------------------------+
//| Showing                                                          |
//+------------------------------------------------------------------+
void CPicturesSlider::Show(void)
  {
   CElement::Show();
   SelectPicture(m_radio_buttons.SelectedButtonIndex());
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CPicturesSlider::Delete(void)
  {
   CElement::Delete();
//--- Emptying the control arrays
   ::ArrayFree(m_pictures);
  }
//+------------------------------------------------------------------+
//| Pressing of a radio button                                       |
//+------------------------------------------------------------------+
bool CPicturesSlider::OnClickRadioButton(const string clicked_object,const int id,const int index)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(clicked_object,m_radio_buttons.NamePart(),0)<0)
      return(false);
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Leave, if the index matches
   if(index==m_radio_buttons.SelectedButtonIndex())
      return(true);
//--- Select the picture
   SelectPicture(index);
//--- Redraw the control
   m_radio_buttons.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Clicking the left mouse button                                   |
//+------------------------------------------------------------------+
bool CPicturesSlider::OnClickLeftArrow(const string clicked_object,const int id,const int index)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(clicked_object,m_left_arrow.NamePart(),0)<0)
      return(false);
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || index!=m_left_arrow.Index() || CElementBase::IsLocked())
      return(false);
//--- Get the current index of the selected radio button
   int selected_radio_button=m_radio_buttons.SelectedButtonIndex();
//--- Switch the picture
   SelectPicture(--selected_radio_button);
//--- Redraw the radio buttons
   m_radio_buttons.Update(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElementBase::Id(),CElementBase::Index(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Clicking the right button                                        |
//+------------------------------------------------------------------+
bool CPicturesSlider::OnClickRightArrow(const string clicked_object,const int id,const int index)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(clicked_object,m_right_arrow.NamePart(),0)<0)
      return(false);
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || index!=m_right_arrow.Index() || CElementBase::IsLocked())
      return(false);
//--- Get the current index of the selected radio button
   int selected_radio_button=m_radio_buttons.SelectedButtonIndex();
//--- Switch the picture
   SelectPicture(++selected_radio_button);
//--- Redraw the radio buttons
   m_radio_buttons.Update(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElementBase::Id(),CElementBase::Index(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CPicturesSlider::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw frame
   CElement::DrawBorder();
  }
//+------------------------------------------------------------------+

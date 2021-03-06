//+------------------------------------------------------------------+
//|                                                         Tab2.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Program.mqh"
//+------------------------------------------------------------------+
//| Create the "Indent left" edit box                                |
//+------------------------------------------------------------------+
bool CProgram::CreateIndentLeft(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_indent_left.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_indent_left);
//--- Properties
   m_indent_left.XSize(120);
   m_indent_left.MaxValue(100);
   m_indent_left.MinValue(0);
   m_indent_left.StepValue(1);
   m_indent_left.SetDigits(0);
   m_indent_left.SpinEditMode(true);
   m_indent_left.SetValue((string)m_graph1.GetGraphicPointer().IndentLeft());
   m_indent_left.GetTextBoxPointer().XSize(50);
   m_indent_left.GetTextBoxPointer().AutoSelectionMode(true);
   m_indent_left.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_indent_left.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_indent_left);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Indent right" edit box                               |
//+------------------------------------------------------------------+
bool CProgram::CreateIndentRight(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_indent_right.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_indent_right);
//--- Properties
   m_indent_right.XSize(120);
   m_indent_right.MaxValue(100);
   m_indent_right.MinValue(0);
   m_indent_right.StepValue(1);
   m_indent_right.SetDigits(0);
   m_indent_right.SpinEditMode(true);
   m_indent_right.SetValue((string)m_graph1.GetGraphicPointer().IndentRight());
   m_indent_right.GetTextBoxPointer().XSize(50);
   m_indent_right.GetTextBoxPointer().AutoSelectionMode(true);
   m_indent_right.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_indent_right.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_indent_right);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Indent up" edit box                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateIndentUp(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_indent_up.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_indent_up);
//--- Properties
   m_indent_up.XSize(120);
   m_indent_up.MaxValue(100);
   m_indent_up.MinValue(0);
   m_indent_up.StepValue(1);
   m_indent_up.SetDigits(0);
   m_indent_up.SpinEditMode(true);
   m_indent_up.SetValue((string)m_graph1.GetGraphicPointer().IndentUp());
   m_indent_up.GetTextBoxPointer().XSize(50);
   m_indent_up.GetTextBoxPointer().AutoSelectionMode(true);
   m_indent_up.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_indent_up.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_indent_up);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Indent down" edit box                                |
//+------------------------------------------------------------------+
bool CProgram::CreateIndentDown(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_indent_down.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_indent_down);
//--- Properties
   m_indent_down.XSize(120);
   m_indent_down.MaxValue(100);
   m_indent_down.MinValue(0);
   m_indent_down.StepValue(1);
   m_indent_down.SetDigits(0);
   m_indent_down.SpinEditMode(true);
   m_indent_down.SetValue((string)m_graph1.GetGraphicPointer().IndentDown());
   m_indent_down.GetTextBoxPointer().XSize(50);
   m_indent_down.GetTextBoxPointer().AutoSelectionMode(true);
   m_indent_down.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_indent_down.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_indent_down);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "History name width" edit box                         |
//+------------------------------------------------------------------+
bool CProgram::CreateHistoryNameWidth(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_history_name_width.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_history_name_width);
//--- Properties
   m_history_name_width.XSize(160);
   m_history_name_width.MaxValue(100);
   m_history_name_width.MinValue(0);
   m_history_name_width.StepValue(1);
   m_history_name_width.SetDigits(0);
   m_history_name_width.SpinEditMode(true);
   m_history_name_width.SetValue((string)m_graph1.GetGraphicPointer().HistoryNameWidth());
   m_history_name_width.GetTextBoxPointer().XSize(50);
   m_history_name_width.GetTextBoxPointer().AutoSelectionMode(true);
   m_history_name_width.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_history_name_width.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_history_name_width);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "History name size" edit box                          |
//+------------------------------------------------------------------+
bool CProgram::CreateHistoryNameSize(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_history_name_size.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_history_name_size);
//--- Properties
   m_history_name_size.XSize(160);
   m_history_name_size.MaxValue(100);
   m_history_name_size.MinValue(0);
   m_history_name_size.StepValue(1);
   m_history_name_size.SetDigits(0);
   m_history_name_size.SpinEditMode(true);
   m_history_name_size.SetValue((string)m_graph1.GetGraphicPointer().HistoryNameSize());
   m_history_name_size.GetTextBoxPointer().XSize(50);
   m_history_name_size.GetTextBoxPointer().AutoSelectionMode(true);
   m_history_name_size.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_history_name_size.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_history_name_size);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "History symbol size" edit box                        |
//+------------------------------------------------------------------+
bool CProgram::CreateHistorySymbolSize(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_history_symbol_size.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_history_symbol_size);
//--- Properties
   m_history_symbol_size.XSize(160);
   m_history_symbol_size.MaxValue(100);
   m_history_symbol_size.MinValue(0);
   m_history_symbol_size.StepValue(1);
   m_history_symbol_size.SetDigits(0);
   m_history_symbol_size.SpinEditMode(true);
   m_history_symbol_size.SetValue((string)m_graph1.GetGraphicPointer().HistorySymbolSize());
   m_history_symbol_size.GetTextBoxPointer().XSize(50);
   m_history_symbol_size.GetTextBoxPointer().AutoSelectionMode(true);
   m_history_symbol_size.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_history_symbol_size.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_history_symbol_size);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Gap size" edit box                                   |
//+------------------------------------------------------------------+
bool CProgram::CreateGapSize(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_gap_size.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_gap_size);
//--- Properties
   m_gap_size.XSize(150);
   m_gap_size.MaxValue(100);
   m_gap_size.MinValue(0);
   m_gap_size.StepValue(1);
   m_gap_size.SetDigits(0);
   m_gap_size.SpinEditMode(true);
   m_gap_size.SetValue((string)m_graph1.GetGraphicPointer().GapSize());
   m_gap_size.GetTextBoxPointer().XSize(50);
   m_gap_size.GetTextBoxPointer().AutoSelectionMode(true);
   m_gap_size.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_gap_size.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_gap_size);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Major mark size" edit box                            |
//+------------------------------------------------------------------+
bool CProgram::CreateMajorMarkSize(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_major_mark_size.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(1,m_major_mark_size);
//--- Properties
   m_major_mark_size.XSize(150);
   m_major_mark_size.MaxValue(100);
   m_major_mark_size.MinValue(0);
   m_major_mark_size.StepValue(1);
   m_major_mark_size.SetDigits(0);
   m_major_mark_size.SpinEditMode(true);
   m_major_mark_size.SetValue((string)m_graph1.GetGraphicPointer().MajorMarkSize());
   m_major_mark_size.GetTextBoxPointer().XSize(50);
   m_major_mark_size.GetTextBoxPointer().AutoSelectionMode(true);
   m_major_mark_size.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_major_mark_size.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_major_mark_size);
   return(true);
  }
//+------------------------------------------------------------------+

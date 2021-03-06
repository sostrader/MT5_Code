//+------------------------------------------------------------------+
//|                                                  TimeCounter.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Time counter                                                     |
//+------------------------------------------------------------------+
class CTimeCounter
  {
private:
   //--- Step of the counter
   uint              m_step;
   //--- Time interval
   uint              m_pause;
   //--- Time counter
   uint              m_time_counter;
   //---
public:
                     CTimeCounter(void);
                    ~CTimeCounter(void);
   //--- Setting the step and time interval
   void              SetParameters(const uint step,const uint pause);
   //--- Check if the specified time interval had elapsed 
   bool              CheckTimeCounter(void);
   //--- Reset the counter
   void              ZeroTimeCounter(void) { m_time_counter=0; }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTimeCounter::CTimeCounter(void) : m_step(16),
                                   m_pause(1000),
                                   m_time_counter(0)
                                   
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTimeCounter::~CTimeCounter(void)
  {
  }
//+------------------------------------------------------------------+
//| Setting the step and time interval                               |
//+------------------------------------------------------------------+
void CTimeCounter::SetParameters(const uint step,const uint pause)
  {
   m_step  =step;
   m_pause =pause;
  }
//+------------------------------------------------------------------+
//| Check if the specified time interval had elapsed                 |
//+------------------------------------------------------------------+
bool CTimeCounter::CheckTimeCounter(void)
  {
//--- Increase the counter, if the specified time interval has not elapsed
   if(m_time_counter<m_pause)
     {
      m_time_counter+=m_step;
      return(false);
     }
//--- Zero the counter
   m_time_counter=0;
   return(true);
  }
//+------------------------------------------------------------------+

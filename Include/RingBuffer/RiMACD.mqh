//+------------------------------------------------------------------+
//|                                                   RingBuffer.mqh |
//|                                 Copyright 2016, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include "RiBuffDbl.mqh"
#include "RiSMA.mqh"
#include "RiEMA.mqh"
//+------------------------------------------------------------------+
//| Calculate moving average in the ring buffer                      |
//+------------------------------------------------------------------+
class CRiMACD
{
private:
   CRiEMA        m_slow_macd;    // Fast exponential moving average
   CRiEMA        m_fast_macd;    // Slow exponential moving average
   CRiSMA        m_signal_macd;  // Signal line
   double        m_delta;        // Difference between fast and slow EMAs
public:
   double        Macd(void);
   double        Signal(void);
   void          ChangeLast(double new_value);
   void          SetFastPeriod(int period);
   void          SetSlowPeriod(int period);
   void          SetSignalPeriod(int period);
   void          AddValue(double value);
};
//+------------------------------------------------------------------+
//| Re-calculate MACD                                                |
//+------------------------------------------------------------------+
void CRiMACD::AddValue(double value)
{
   m_slow_macd.AddValue(value);
   m_fast_macd.AddValue(value);
   m_delta = m_slow_macd.EMA() - m_fast_macd.EMA();
   m_signal_macd.AddValue(m_delta);
}

//+------------------------------------------------------------------+
//| Change MACD                                                      |
//+------------------------------------------------------------------+
void CRiMACD::ChangeLast(double new_value)
{
   m_slow_macd.ChangeValue(m_slow_macd.GetTotal()-1, new_value);
   m_fast_macd.ChangeValue(m_fast_macd.GetMaxTotal()-1, new_value);
   m_delta = m_slow_macd.EMA() - m_fast_macd.EMA();
   m_signal_macd.ChangeValue(m_slow_macd.GetTotal()-1, m_delta);
}
//+------------------------------------------------------------------+
//| Get MACD histogram                                               |
//+------------------------------------------------------------------+
double CRiMACD::Macd(void)
{
   return m_delta;
}
//+------------------------------------------------------------------+
//| Get the signal line                                              |
//+------------------------------------------------------------------+
double CRiMACD::Signal(void)
{
   return m_signal_macd.SMA();
}
//+------------------------------------------------------------------+
//| Get the fast period                                              |
//+------------------------------------------------------------------+
void CRiMACD::SetFastPeriod(int period)
{
   m_slow_macd.SetMaxTotal(period);
}
//+------------------------------------------------------------------+
//| Set the slow period                                              |
//+------------------------------------------------------------------+
void CRiMACD::SetSlowPeriod(int period)
{
   m_fast_macd.SetMaxTotal(period);
}
//+------------------------------------------------------------------+
//| Set the signal line period                                       |
//+------------------------------------------------------------------+
void CRiMACD::SetSignalPeriod(int period)
{
   m_signal_macd.SetMaxTotal(period);
}
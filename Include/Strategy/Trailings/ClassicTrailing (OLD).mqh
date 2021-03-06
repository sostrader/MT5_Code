//+------------------------------------------------------------------+
//|                                                    Trailings.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Object.mqh>
#define TRAILING_CLASSIC
#include "..\PositionMT5.mqh"

#ifdef SHOW_TRAILING_PARAMS
input string ClassicTrailingParams = "Values";  // Classic Trailing parameters:
input int StepModify = 20;
input int DeltaTrailing = 200;
#endif
//+------------------------------------------------------------------+
//| Параметры и переменные классического трейлинг-стопа, с которыми  |
//| работает функция ClassicTrailing.                                |
//+------------------------------------------------------------------+
class CTrailingClassicParams : public CObject
{
public:
   double   StepModify;        // Шаг в пунктах, пройдя который требуется изменить уровень стоп-лосса позиции
   double   DeltaTrailing;     // Дельта между текущим экстремумом и уровнем трейлинга, которую нужно соблюдать
   double   PrevExtremum;      // Служебная переменная. Последний экстремум, который был достигнут
   CTrailingClassicParams(void);
};
//+------------------------------------------------------------------+
//| Конструктор по умолчанию, заносящий внешние настроки в объект    |
//+------------------------------------------------------------------+
CTrailingClassicParams::CTrailingClassicParams(void)
{
   #ifdef SHOW_TRAILING_PARAMS
   this.StepModify = StepModify;
   this.DeltaTrailing = DeltaTrailing;
   #else
   StepModify = 20;
   DeltaTrailing = 200;
   #endif
}
//+------------------------------------------------------------------+
//| Функция классического трейлинг-стопа                             |
//+------------------------------------------------------------------+
bool TrailingClassic(CPosition* pos, CObject* object)
{
   return false;
}
#property copyright "Орешкин А.В."
#property link      "https://vk.com/tradingisfun"
#property version   "1.10"
#property description "Three Point Arbitrage. Low risk trading system."
#property description "1: EA use magic numer from input menu to +200"
#property description "2: If Trade volume=0 to use the minimal possible trade volume"
#property description "3: The whole log is written to the file: Three Point Arbitrage Control YYYY.MM.DD.csv"
#property description "4: Before testing, you must сreate file with symbols"
#property description "5: If file with symbols is not created then you use triangle by default: EURUSD+GBPUSD+EURGBP"
#property icon "\\Experts\\Arbitrage\\ThreePoint\\ThreePoint.ico"

#include "head.mqh"
#property tester_file FILENAME

int OnInit()
   {
      Print("===============================================\nStart EA: "+MQLInfoString(MQL_PROGRAM_NAME));
      
      fnWarning(glAccountsType,inLot,glFileLog);         //различные проверки во время запуска робота
      fnSetThree(MxThree,inMode);                        //составили треугольники
      fnChangeThree(MxThree);                            //правильно их расставили
      fnSmbLoad(inLot,MxThree);                          //загрузили остальные данные по каждому символу
      
      if(inMode==CREATE_FILE)                            //если нужно только создать файл символов для работы или тестера
      {
         // удаляем файл если он есть.
         FileDelete(FILENAME);  
         int fh=FILEOPENWRITE(FILENAME);
         if (fh==INVALID_HANDLE) 
         {
            Alert("File with symbols not created");
            ExpertRemove();
         }
         // пишем треугольники и некоторую доп информацию в файл
         fnCreateFileSymbols(MxThree,fh);
         Print("File with symbols created");
         
         // закрываем файл и завершаем работу эксперта
         FileClose(fh);
         ExpertRemove();
      }
      
      if (glFileLog!=INVALID_HANDLE)                  //в лог файл пишем используемые символы
         fnCreateFileSymbols(MxThree,glFileLog); 

      fnRestart(MxThree,inMagic,glAccountsType);      //восстанавливаем треугольники после повторного запуска робота
    
      ctrade.SetDeviationInPoints(DEVIATION);
      ctrade.SetTypeFilling(ORDER_FILLING_FOK);
      ctrade.SetAsyncMode(true);
      ctrade.LogLevel(LOG_LEVEL_NO);
      
      EventSetTimer(1);
      return(INIT_SUCCEEDED);
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
      FileClose(glFileLog);
      Print("Stop EA: "+MQLInfoString(MQL_PROGRAM_NAME)+"\n===============================================");
      Comment("");
      EventKillTimer();
   }
void OnTick()
   {
      // сначала посчитаем кол-во открытых треугольников. Это позволит значительно экономить ресурсы компа
      // т.к. если стоит ограничение и мы его достигли то дальше не считаем раздвижки и т.д.      
      
      ushort OpenThree=0;  // количество открытых треугольников
      for(int j=ArraySize(MxThree)-1;j>=0;j--)
      if (MxThree[j].status!=0) OpenThree++; //считаем незакрытые тоже т.к. они могут висеть долго, но они же тем не менее считаются
                             
      if (inMaxThree==0 || (inMaxThree>0 && inMaxThree>OpenThree))
         fnCalcDelta(MxThree,inProfit,inCmnt,inMagic,inLot,inMaxThree,OpenThree); // считаем расхождение и сразу открываемся
      fnOpenCheck(MxThree,glAccountsType,glFileLog);     // проверим успешно ли открылись
      fnCalcPL(MxThree,glAccountsType,inProfit);         // считаем профит открытых треугольников
      fnCloseCheck(MxThree,glAccountsType,glFileLog);    // проверим успешно ли закрылись
      fnCmnt(MxThree,OpenThree);                         // выводим комментарии на экран
   }
void OnTimer()
   {
      OnTick();
   }   
   

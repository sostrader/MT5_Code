//смотрим свободный магик

#include "head.mqh"

ulong fnMagicGet(stThree &MxSmb[],ulong magic)
   {
      int mxsize=ArraySize(MxSmb);
      bool find;
      
      // можно перебрать все открытые треугольники в машем массиве
      // я выбрал другой вариант - пройтись по диапазону магиков, мне кажется это быстрее
      // и уже выбранный магик прогнать по массиву
      for(ulong i=magic;i<magic+MAGIC;i++)
      {
         find=false;
         
         // магик в i. проверим присвоен ли он какому нибудь треугольнику из открытых
         for(int j=0;j<mxsize;j++)
         if (MxSmb[j].status>0 && MxSmb[j].magic==i)
         {
            find=true;
            break;   
         }   
         
         // если магик не используется то выходим из цикла, не дожидаясь его окончания   
         if (!find) return(i);            
      }  
      return(0);  
   }
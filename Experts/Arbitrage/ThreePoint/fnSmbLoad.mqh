//загружаем различные данные по символы такие как количество знаков в котировке, лоте и т.д.

#include "head.mqh"

void fnSmbLoad(double lot,stThree &MxSmb[])
   {
      
      // простенький макрос для принта   
      #define prnt(nm) {nm="";Print("NOT CORRECT LOAD: "+nm);continue;}
      
      // перебираем в цикле все собранные треугольники. Здесь у нас будет перерасход времени на повторные запросы данных по одним и 
      // тем же символам, но так как эту операцию мы делаем только один раз, при зарузке робота, то ради сокращения кода можно поступить и так.
      // для получения данных используем стандартную библиотеку. Острой необходимости в её использовании нет, но пусть это будет силой привычки
      for(int i=ArraySize(MxSmb)-1;i>=0;i--)
      {
         // загружая в класс CSymbolInfo символ, мы инициализируем сбор всех необходимых нам данных
         // и заодно проверяем их доступность, если что то не так то треуголник помечаем нерабочим                  
         if (!csmb.Name(MxSmb[i].smb1.name))    prnt(MxSmb[i].smb1.name); 
         
         // получили _Digits покаждому символу
         MxSmb[i].smb1.digits=csmb.Digits();
         
         //Переводим проскальзывание из целых пунтков в десятичные. Такой формат нам нужен будет дальше для расчётов
         MxSmb[i].smb1.dev=csmb.TickSize()*DEVIATION;         
         
         // чтобы переводить котировки в количество пунктов, нам часто придётся цену делить на значение _Point
         // лучше это значение представить в виде 1/Point и тогда мы деление заменим умножением
         // тут нет проверки csmb.Point() на 0, т.к. во-первых она не может быть равной 0, а если вдруг случится чудо
         // и параметр не будет получен, то этот треугольник будет отсеян строкой if (!csmb.Name(MxSmb[i].smb1.name))	         
         MxSmb[i].smb1.Rpoint=int(NormalizeDouble(1/csmb.Point(),0));
         
         // до стольки знаков мы округляем лот. Считается просто = количество знаком после запятой в переменной LotStep
         MxSmb[i].smb1.digits_lot=csup.NumberCount(csmb.LotsStep());
         
         // ограничения по объёмам, сразу нормализованные
         MxSmb[i].smb1.lot_min=NormalizeDouble(csmb.LotsMin(),MxSmb[i].smb1.digits_lot);
         MxSmb[i].smb1.lot_max=NormalizeDouble(csmb.LotsMax(),MxSmb[i].smb1.digits_lot);
         MxSmb[i].smb1.lot_step=NormalizeDouble(csmb.LotsStep(),MxSmb[i].smb1.digits_lot); 
         
         //размер контракта 
         MxSmb[i].smb1.contract=csmb.ContractSize();
         
         // тоже что и выше но взято для символа 2
         if (!csmb.Name(MxSmb[i].smb2.name))    prnt(MxSmb[i].smb2.name);
         MxSmb[i].smb2.digits=csmb.Digits();
         MxSmb[i].smb2.dev=csmb.TickSize()*DEVIATION;
         MxSmb[i].smb2.Rpoint=int(NormalizeDouble(1/csmb.Point(),0));
         MxSmb[i].smb2.digits_lot=csup.NumberCount(csmb.LotsStep());
         MxSmb[i].smb2.lot_min=NormalizeDouble(csmb.LotsMin(),MxSmb[i].smb2.digits_lot);
         MxSmb[i].smb2.lot_max=NormalizeDouble(csmb.LotsMax(),MxSmb[i].smb2.digits_lot);
         MxSmb[i].smb2.lot_step=NormalizeDouble(csmb.LotsStep(),MxSmb[i].smb2.digits_lot);         
         MxSmb[i].smb2.contract=csmb.ContractSize();
         
         // тоже что и выше но взято для символа 3
         if (!csmb.Name(MxSmb[i].smb3.name))    prnt(MxSmb[i].smb3.name);
         MxSmb[i].smb3.digits=csmb.Digits();
         MxSmb[i].smb3.dev=csmb.TickSize()*DEVIATION;
         MxSmb[i].smb3.Rpoint=int(NormalizeDouble(1/csmb.Point(),0));
         MxSmb[i].smb3.digits_lot=csup.NumberCount(csmb.LotsStep());
         MxSmb[i].smb3.lot_min=NormalizeDouble(csmb.LotsMin(),MxSmb[i].smb3.digits_lot);
         MxSmb[i].smb3.lot_max=NormalizeDouble(csmb.LotsMax(),MxSmb[i].smb3.digits_lot);
         MxSmb[i].smb3.lot_step=NormalizeDouble(csmb.LotsStep(),MxSmb[i].smb3.digits_lot);           
         MxSmb[i].smb3.contract=csmb.ContractSize();   
         
         // выравниваем объём торговли
         // есть ограничения как для каждой валютной пары, так и для всего треугольника в целом
         // для пары ограничения записаны здесь: MxSmb[i].smbN.lotN
         // для треугольника ограничения записаны здесь: MxSmb[i].lotN
         
         // выбираем из всех минимальных значений максимальное. Тут же округляем, по самому крупному значению
         // вся эта грядка кода сделана только для случая когда попадается примерно такая ситуация по объёмам: 0.01+0.01+0.1
         // в этом случае минимально возможный торговый объём будет установлен 0.1 и округлён до 1 знака после запятой
         double lt=MathMax(MxSmb[i].smb1.lot_min,MathMax(MxSmb[i].smb2.lot_min,MxSmb[i].smb3.lot_min));
         MxSmb[i].lot_min=NormalizeDouble(lt,(int)MathMax(MxSmb[i].smb1.digits_lot,MathMax(MxSmb[i].smb2.digits_lot,MxSmb[i].smb3.digits_lot)));
         
         //из максимальных значений объёма берём самое миниальное и тоже сразу округляем
         lt=MathMin(MxSmb[i].smb1.lot_max,MathMin(MxSmb[i].smb2.lot_max,MxSmb[i].smb3.lot_max));
         MxSmb[i].lot_max=NormalizeDouble(lt,(int)MathMax(MxSmb[i].smb1.digits_lot,MathMax(MxSmb[i].smb2.digits_lot,MxSmb[i].smb3.digits_lot)));
         
         // если во входных параметрах торгового объёма стоит 0, значит используем минимально возможный объём, но берём не у каждой пары свой минимальный
         // а минимальный для всех, чтобы раз уж выравнивания нет, то пусть он будет хотя бы одинаково минимальный.
         if (lot==0)
         {
            MxSmb[i].smb1.lot=MxSmb[i].lot_min;
            MxSmb[i].smb2.lot=MxSmb[i].lot_min;
            MxSmb[i].smb3.lot=MxSmb[i].lot_min;
         } else
         {
            // если объём необходимо выравнивать, то у 1 и 2 пары он известен, а обём третей пары будет вычисляться непосредственно перед входом
            MxSmb[i].smb1.lot=lot;  
            MxSmb[i].smb2.lot=lot;
            
            // если входной торговый объём не попадает в текущие ограничения то треугольник не используем в работе
            // сообщаем об этом алертом
            if (lot<MxSmb[i].smb1.lot_min || lot>MxSmb[i].smb1.lot_max || lot<MxSmb[i].smb2.lot_min || lot>MxSmb[i].smb2.lot_max) 
            {
               MxSmb[i].smb1.name="";
               Alert("Triangle: "+MxSmb[i].smb1.name+" "+MxSmb[i].smb2.name+" "+MxSmb[i].smb3.name+" - not correct the trading volume");
               continue;
            }            
         }
      }
   }



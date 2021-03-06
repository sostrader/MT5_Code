//+------------------------------------------------------------------+
//|                                           AccountInformation.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include <Arrays\ArrayObj.mqh>

string title2[]=
     {
      "OrderID",
      "PositionID",
      "SendTime",
      "DealTime",
      "Symbol",
      "Type",
      "InitVolume",
      "CurrentVolume",
      "OpenPrice",
      "CurrentPrice",
      "Tp",
      "Sl",
      "Comment"
     };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderInformation:public CObject
  {
private:
   string title[];
   string value[];
   ulong             order_id;
   ulong             position_id;
   ulong             send_time;
   ulong             deal_time;
   string            symbol;
   ulong             type;
   double            init_volume;
   double            current_volume;
   double            open_price;
   double            current_price;
   double            tp;
   double            sl;
   string            comment;
public:
   OrderInformation(void);
   void Init(ulong id_order,ulong id_position,ulong time_send,ulong time_deal,string order_symbol,ulong order_type,double volume_init,double volume_current,double price_open,double price_current,double order_tp=0.000000,double order_sl=0.000000,string order_comment=NULL);
   string            ToString(string sep=" ");
   void              GetTitle(string &titles[]){ArrayCopy(titles,title);};
   void              GetValue(string &values[]){ArrayCopy(values,value);};
  };
OrderInformation::OrderInformation(void)
   {
   }
void OrderInformation::Init(ulong id_order,ulong id_position,ulong time_send,ulong time_deal,string order_symbol,ulong order_type,double volume_init,double volume_current,double price_open,double price_current,double order_tp=0.000000,double order_sl=0.000000,string order_comment=NULL)
   {
    order_id=id_order;
    position_id=id_position;
    send_time=time_send;
    deal_time=time_deal;
    symbol=order_symbol;
    type=order_type;
    init_volume=volume_init;
    current_volume=volume_current;
    open_price=price_open;
    current_price=price_current;
    tp=order_tp;
    sl=order_sl;
    comment=order_comment;
    
    string titles_str[]=
     {
      "OrderID",
      "PositionID",
      "SendTime",
      "DealTime",
      "Symbol",
      "Type",
      "InitVolume",
      "CurrentVolume",
      "OpenPrice",
      "CurrentPrice",
      "Tp",
      "Sl",
      "Comment"
     };
    ArrayCopy(title,titles_str);
    string type_str;
      switch(type)
        {
         case ORDER_TYPE_BUY :
            type_str="BUY";
            break;
         case ORDER_TYPE_SELL:
            type_str="SELL";
            break;
         case ORDER_TYPE_BUY_LIMIT:
            type_str="BUY LIMIT";
            break;
         case ORDER_TYPE_SELL_LIMIT:
            type_str="BUY LIMIT";
            break;
         case ORDER_TYPE_BUY_STOP:
            type_str="BUY STOP";
            break;
         case ORDER_TYPE_SELL_STOP:
            type_str="SELL STOP";
            break;
         case ORDER_TYPE_BUY_STOP_LIMIT:
            type_str="BUY STOP LIMIT";
            break;
         case ORDER_TYPE_SELL_STOP_LIMIT:
            type_str="SELL STOP LIMIT";
            break;
         default:
            break;
        };
    ArrayResize(value,13);
   value[0]=IntegerToString(order_id);
   value[1]=IntegerToString(position_id);
   value[2]=TimeToString(send_time);
   value[3]=TimeToString(deal_time);
   value[4]=symbol;
   value[5]=type_str;
   value[6]=DoubleToString(init_volume,2);
   value[7]=DoubleToString(current_volume,2);
   value[8]=DoubleToString(open_price,SymbolInfoInteger(symbol,SYMBOL_DIGITS));
   value[9]=DoubleToString(current_price,SymbolInfoInteger(symbol,SYMBOL_DIGITS));
   value[10]=DoubleToString(tp,SymbolInfoInteger(symbol,SYMBOL_DIGITS));
   value[11]=DoubleToString(sl,SymbolInfoInteger(symbol,SYMBOL_DIGITS));
   value[12]=comment;
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string OrderInformation::ToString(string sep=" ")
  {
   string order_infor_str="";
   for(int i=0;i<ArraySize(title);i++)
     {
      order_infor_str+=title[i]+":"+value[i]+sep;
     }
   return order_infor_str;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderFlow
  {
private:
   CArrayObj         order_arr;
public:
                     COrderFlow(void);
                    ~COrderFlow(void){};
   void              ToPrint(void);
   void              ToCSV(string path);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderFlow::COrderFlow(void)
  {
   HistorySelect(0,D'2030.01.01');
  for(int i=0;i<HistoryOrdersTotal();i++)
  {
   ulong order_ticket=HistoryOrderGetTicket(i);
   ulong order_id=HistoryOrderGetInteger(order_ticket,ORDER_TICKET);
   ulong position_id=HistoryOrderGetInteger(order_ticket,ORDER_POSITION_ID);
   ulong send_time=HistoryOrderGetInteger(order_ticket,ORDER_TIME_SETUP);
   ulong deal_time=HistoryOrderGetInteger(order_ticket,ORDER_TIME_DONE);
   string symbol=HistoryOrderGetString(order_ticket,ORDER_SYMBOL);
   ulong type=HistoryOrderGetInteger(order_ticket,ORDER_TYPE);
   double init_volume=HistoryOrderGetDouble(order_ticket,ORDER_VOLUME_INITIAL);
   double current_volume=HistoryOrderGetDouble(order_ticket,ORDER_VOLUME_CURRENT);
   double open_price=HistoryOrderGetDouble(order_ticket,ORDER_PRICE_OPEN);
   double current_price=HistoryOrderGetDouble(order_ticket,ORDER_PRICE_CURRENT);
   double tp=HistoryOrderGetDouble(order_ticket,ORDER_TP);
   double sl=HistoryOrderGetDouble(order_ticket,ORDER_SL);
   string comment=HistoryOrderGetString(order_ticket,ORDER_COMMENT);
   OrderInformation *order_infor=new OrderInformation();
   order_infor.Init(order_id,position_id,send_time,deal_time,symbol,type,init_volume,current_volume,open_price,current_price,tp,sl,comment);
   order_arr.Add(order_infor);
  }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderFlow::ToPrint()
  {
   for(int i=0;i<order_arr.Total();i++)
     {
      string order_infor_str="";
      OrderInformation *order=order_arr.At(i);
      Print(order.ToString());
     }
  }
void COrderFlow::ToCSV(string path)
   {
    int file_handle=FileOpen(path,FILE_WRITE|FILE_CSV);
    if(file_handle!=INVALID_HANDLE)
      {
       string title[];
       string value[];
       
       FileWrite(file_handle, title2[0],title2[1],title2[2],title2[3],title2[4],title2[5],title2[6],title2[7],title2[8],title2[9],title2[10],title2[11],title2[12]);
       for(int i=0;i<order_arr.Total();i++)
         {
          OrderInformation *order=order_arr.At(i);
          order.GetValue(value);
          FileWrite(file_handle,value[0],value[1],value[2],value[3],value[4],value[5],value[6],value[7],value[8],value[9],value[10],value[11],value[12]);
         }
        FileClose(file_handle);
        Print("Write data OK!");
      }
    else 
       Print("打开文件错误",GetLastError());
   }

//+------------------------------------------------------------------+

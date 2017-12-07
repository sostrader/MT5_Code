//=====================================================================
//	用于图表上市场观察的函数库
//=====================================================================

//---------------------------------------------------------------------
#property copyright 	"Dima S., 2010 �"
#property link      	"dimascub@mail.com"

//---------------------------------------------------------------------
//	包含库
//---------------------------------------------------------------------
#include	<TextDisplay.mqh>
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//	SymbolWatchDisplay 类
//---------------------------------------------------------------------
class SymbolWatchDisplay : public TableDisplay
  {
private:
   string            symbol;                 // 交易品种
   double            point;
   int               digits;
   double            point_multiplier;       // 针对 3/5 小数位数的系数

private:
   MqlTick           curr_tick;              // 当前订单信息
   datetime          times;
   double            prev_bid;
   MqlRates D1_rates[ ];                     // 日价格信息
   MqlRates TF_rates[ ];                     // 当前时段的柱

private:
   ENUM_TIMEFRAMES   time_frames[];

private:
   double            curr_HiLo;              // 当前的每日价格范围
   double            curr_AvD;               // 平均每日价格范围

private:
   int               up_down_shift;          // Y 纵坐标
   int               left_right_shift;       // X 横坐标

public:
   void              RefreshSymbolInfo();    // 刷新交易品种信息
   void              SymbolWatchDisplay();
   void             ~SymbolWatchDisplay();
   bool              Create(string _symbol,long _chart_id,int _window,int _cols,int _lines,int _ud_shift,int _lr_shift,color _ttl,ENUM_TIMEFRAMES &_tfs[]);
   void              RedrawSymbolInfo();     // 重绘信息
  };
//---------------------------------------------------------------------
//	构造函数
//---------------------------------------------------------------------
void SymbolWatchDisplay::SymbolWatchDisplay()
  {
   this.symbol=NULL;
   this.up_down_shift=0;
   this.left_right_shift=0;
   this.curr_HiLo= 0.0;
   this.curr_AvD = 0.0;
   this.times=0;
   this.prev_bid=0.0;
  }
//---------------------------------------------------------------------
//	析构函数
//---------------------------------------------------------------------
void SymbolWatchDisplay::~SymbolWatchDisplay()
  {
////	this.Clear( );
  }
//---------------------------------------------------------------------
//	刷新信息
//---------------------------------------------------------------------
void SymbolWatchDisplay::RedrawSymbolInfo()
  {
//	获取订单数据
   ResetLastError();
   if(SymbolInfoTick(this.symbol,this.curr_tick)!=true)
     {
      this.SetText( 0, "Err " + DoubleToString( GetLastError( ), 0 ));
      this.SetColor( 0, Yellow );
      this.SetText( 1, "" );
      this.SetText( 2, "" );
      this.SetText( 3, "" );
      this.SetText( 4, "" );
      this.SetText( 5, "" );
      for(int k=0; k<ArraySize(this.time_frames); k++)
        {
         this.SetText(k+6,"");
        }
      return;
     }

//	如果数据已经改变 (或者这是第一次调用), 显示它们:
   if(this.curr_tick.time>this.times || this.times==0)
     {
      this.SetText(0,DoubleToString(this.curr_tick.bid,digits));
      if(this.curr_tick.bid>this.prev_bid && this.prev_bid>0.1)
        {
         this.SetColor(0,Lime);
        }
      else if(this.curr_tick.bid<this.prev_bid && this.prev_bid>0.1)
        {
         this.SetColor(0,Red);
        }
      else
        {
         this.SetColor(0,Yellow);
        }

      this.prev_bid=this.curr_tick.bid;
      this.times=this.curr_tick.time;
     }
   this.SetText( 1, DoubleToString( this.point_multiplier * ( this.curr_tick.ask - this.curr_tick.bid ) / this.point, 1 ));
   this.SetText( 2, DoubleToString( this.point_multiplier * SymbolInfoInteger( this.symbol, SYMBOL_TRADE_STOPS_LEVEL ), 1 ));

//	取得每日柱
   if(CopyRates(this.symbol,PERIOD_D1,0,21,this.D1_rates)!=21)
     {
      this.SetText( 3, "loading.." );
      this.SetColor( 3, Yellow );
      this.SetText( 4, "loading.." );
      this.SetColor( 4, Yellow );
      this.SetText( 5, "loading.." );
      this.SetColor( 5, Yellow );
      return;
     }

//	根据开盘价计算点数
   if(this.D1_rates[20].close>this.D1_rates[20].open)
     {
      this.SetColor( 3, Lime );
      this.SetText( 3, DoubleToString( this.point_multiplier * ( this.D1_rates[ 20 ].close - this.D1_rates[ 20 ].open ) / this.point, 1 ));
     }
   else if(D1_rates[20].close<D1_rates[20].open)
     {
      this.SetColor( 3, Red );
      this.SetText( 3, DoubleToString( this.point_multiplier * ( this.D1_rates[ 20 ].open - this.D1_rates[ 20 ].close ) / this.point, 1 ));
     }
   else
     {
      this.SetText( 3, "0.0" );
      this.SetColor( 3, Yellow );
     }

//	当前日价格范围
   this.SetText( 4, DoubleToString( this.point_multiplier * ( this.D1_rates[ 20 ].high - this.D1_rates[ 20 ].low ) / this.point, 1 ));
   this.SetColor( 4, PowderBlue );

//	平均日价格范围
   double   av,av_20=0.0,av_10=0.0,av_5=0.0,av_1;
   for(int i=0; i<20; i++)
     {
      av_20+=this.D1_rates[i].high-this.D1_rates[i].low;
     }
   for(int i=10; i<20; i++)
     {
      av_10+=this.D1_rates[i].high-this.D1_rates[i].low;
     }
   for(int i=15; i<20; i++)
     {
      av_5+=this.D1_rates[i].high-this.D1_rates[i].low;
     }
   av_1=this.D1_rates[19].high-this.D1_rates[19].low;
   av =(av_1+av_5/ 5.0+av_10/ 10.0+av_20/ 20.0)/ 4.0;
   av/=(this.point);
   this.SetText( 5, DoubleToString( this.point_multiplier * av, 1 ));
   this.SetColor( 5, LightGoldenrod );

//	取得当前时段的柱数据
   for(int k=0; k<ArraySize(this.time_frames); k++)
     {
      if(CopyRates(this.symbol,this.time_frames[k],0,1,this.TF_rates)!=1)
        {
         this.SetText( k + 6, "loading.." );
         this.SetColor( k + 6, Yellow );
         continue;
        }
      double   dev=100.0 *(this.TF_rates[0].close-this.TF_rates[0].open)/this.TF_rates[0].open;
      if(dev>0.0005)
        {
         this.SetText( k + 6, "+" + DoubleToString( dev, 3 ));
         this.SetColor( k + 6, PaleGreen );
        }
      else if(dev<-0.0005)
        {
         this.SetText( k + 6, " " + DoubleToString( dev, 3 ));
         this.SetColor( k + 6, Pink );
        }
      else
        {
         this.SetText( k + 6, "  " + DoubleToString( 0.0, 3 ));
         this.SetColor( k + 6, Silver );
        }
     }
  }
//---------------------------------------------------------------------
//	创建图形对象
//---------------------------------------------------------------------
bool SymbolWatchDisplay::Create(string _symbol,long _chart_id,int _window,int _cols,int _lines,int _ud_shift,int _lr_shift,color _ttl,ENUM_TIMEFRAMES &_tfs[])
  {
   this.symbol=_symbol;
   this.up_down_shift=_ud_shift;
   this.left_right_shift=_lr_shift;

   this.RefreshSymbolInfo( );
   this.SetParams( _chart_id, _window, CORNER_LEFT_UPPER );

   ArrayResize(this.time_frames,ArraySize(_tfs));
   for(int i=0; i<ArraySize(_tfs); i++)
     {
      this.time_frames[i]=_tfs[i];
     }

//	价格
   this.AddFieldObject( _cols, _lines, this.left_right_shift, this.up_down_shift + 5, Gold, "Arial", 10 );
   this.SetAnchor( 0, ANCHOR_LEFT );

//	点差
   this.AddFieldObject( _cols, _lines, this.left_right_shift, this.up_down_shift + 7, Gold, "Arial", 10 );
   this.SetAnchor( 1, ANCHOR_LEFT );

//	止损水平
   this.AddFieldObject( _cols, _lines, this.left_right_shift, this.up_down_shift + 9, Gold, "Arial", 10 );
   this.SetAnchor( 2, ANCHOR_LEFT );

//	距离开盘价的点数
   this.AddFieldObject( _cols, _lines, this.left_right_shift, this.up_down_shift + 12, PowderBlue, "Arial", 10 );
   this.SetAnchor( 3, ANCHOR_LEFT );

//	每日范围
   this.AddFieldObject( _cols, _lines, this.left_right_shift, this.up_down_shift + 15, PowderBlue, "Arial", 10 );
   this.SetAnchor( 4, ANCHOR_LEFT );

//	平均日价格范围
   this.AddFieldObject( _cols, _lines, this.left_right_shift, this.up_down_shift + 17, LightGoldenrod, "Arial", 10 );
   this.SetAnchor( 5, ANCHOR_LEFT );

//	变化百分比
   for(int k=0; k<ArraySize(this.time_frames); k++)
     {
      this.AddFieldObject( _cols, _lines, this.left_right_shift, this.up_down_shift + 20 + 2 * k, PowderBlue, "Arial", 10 );
      this.SetAnchor( k + 6, ANCHOR_LEFT );
     }

//	标题 (交易品种)
   this.AddTitleObject( _cols, _lines, this.left_right_shift, this.up_down_shift + 2, this.symbol, _ttl, "Arial", 10 );
   this.SetAnchor( ArraySize( this.time_frames ) + 6, ANCHOR_LEFT );

   return(true);
  }
//---------------------------------------------------------------------
//	刷新交易品种信息
//---------------------------------------------------------------------
void SymbolWatchDisplay::RefreshSymbolInfo()
  {
   this.point=SymbolInfoDouble(this.symbol,SYMBOL_POINT);
   this.digits=(int)SymbolInfoInteger(this.symbol,SYMBOL_DIGITS);

//	5/3 位小数位数系数
   if(this.digits==5 || this.digits==3)
     {
      this.point_multiplier=0.1;
     }
   else
     {
      this.point_multiplier=1.0;
     }
  }
//---------------------------------------------------------------------
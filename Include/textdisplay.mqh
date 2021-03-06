//=====================================================================
//	用于在图表上输出文本信息的函数库
//=====================================================================

//---------------------------------------------------------------------
#property copyright 	"Dima S., 2010 �"
#property link      	"dimascub@mail.com"
//---------------------------------------------------------------------

//---------------------------------------------------------------------
#import		"user32.dll"
int      GetSystemMetrics(int _index);
#import
//---------------------------------------------------------------------
#define		SM_CXSCREEN				0
#define		SM_CYSCREEN				1
#define		SM_CXFULLSCREEN		16
#define		SM_CYFULLSCREEN		17
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//	包含库
//---------------------------------------------------------------------
#include	<ChartObjects\ChartObjectsTxtControls.mqh>
#include	<Arrays\List.mqh>
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//	TTitleDisplay 类
//---------------------------------------------------------------------
class TTitleDisplay : public CChartObjectLabel
  {
protected:
   long              chart_id;
   int               sub_window;
   long              chart_width;                        // 图表宽度像素数
   long              chart_height;                       // 图表高度像素数
   long              chart_width_step;                   // 图表宽度步长
   long              chart_height_step;                  // 图表高度步长
   int               columns_number;                     // 列数
   int               lines_number;                       // 行数
   int               curr_column;
   int               curr_row;

private:
   void              SetParams(long _chart_id,int _window,int _cols,int _lines);// 设置对象参数

public:
   string            GetUniqName();                      // 取得唯一名称
   bool              Create(long _chart_id,int _window,int _cols,int _lines,int _col,int _row);
   void              RecalcAndRedraw();                  // 重新计算坐标并重绘

public:
   void              TTitleDisplay();                    // 构造函数
   void             ~TTitleDisplay();                    // 析构函数

  };
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//	构造函数
//---------------------------------------------------------------------
void TTitleDisplay::TTitleDisplay()
  {
  }
//---------------------------------------------------------------------
//	析构函数
//---------------------------------------------------------------------
void TTitleDisplay::~TTitleDisplay()
  {
  }
//---------------------------------------------------------------------
//	创建对象
//---------------------------------------------------------------------
bool TTitleDisplay::Create(long _chart_id,int _window,int _cols,int _lines,int _col,int _row)
  {
   this.curr_column=_col;
   this.curr_row=_row;
   SetParams(_chart_id,_window,_cols,_lines);

   return(this.Create(this.chart_id,this.GetUniqName(),this.sub_window,(int)(_col*this.chart_width_step),(int)(_row*this.chart_height_step)));
  }
//---------------------------------------------------------------------
//	设置对象参数
//---------------------------------------------------------------------
void TTitleDisplay::SetParams(long _chart_id,int _window,int _cols,int _lines)
  {
   this.chart_id=_chart_id;
   this.sub_window=_window;
   this.columns_number=_cols;
   this.lines_number=_lines;

//	取得图表宽度像素数
   this.chart_width=GetSystemMetrics(SM_CXFULLSCREEN);
   this.chart_height=GetSystemMetrics(SM_CYFULLSCREEN);

//	计算步长
   this.chart_width_step=this.chart_width/_cols;
   this.chart_height_step=this.chart_height/_lines;
  }
//---------------------------------------------------------------------
//	重新计算对象参数并重绘
//---------------------------------------------------------------------
void TTitleDisplay::RecalcAndRedraw()
  {
//	取得图表尺寸 (像素单位)
   long   width=GetSystemMetrics(SM_CXFULLSCREEN);
   long   height=GetSystemMetrics(SM_CYFULLSCREEN);
   if(width==this.chart_width && height==this.chart_height)
     {
      return;
     }

   this.chart_width=width;
   this.chart_height=height;

//	重新计算步长
   this.chart_width_step=this.chart_width/this.columns_number;
   this.chart_height_step=this.chart_height/this.lines_number;

//	把对象移动到新坐标
   this.X_Distance(( int )( this.curr_column * this.chart_width_step ));
   this.Y_Distance(( int )( this.curr_row * this.chart_height_step ));
  }
//---------------------------------------------------------------------
//	取得唯一名称
//---------------------------------------------------------------------
string TTitleDisplay::GetUniqName()
  {
   static uint   prev_count=0;

   uint         count=GetTickCount();
   while(1)
     {
      if(prev_count==UINT_MAX)
        {
         prev_count=0;
        }
      if(count<=prev_count)
        {
         prev_count++;
         count=prev_count;
        }
      else
        {
         prev_count=count;
        }

      //	检查同名对象是否存在
      string      name=TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS)+" "+DoubleToString(count,0);
      if(ObjectFind(0,name)<0)
        {
         return(name);
        }
     }

   return(NULL);
  }
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//	TFieldDisplay 类
//---------------------------------------------------------------------
class TFieldDisplay : public CChartObjectEdit
  {
protected:
   long              chart_id;
   int               sub_window;
   long              chart_width;                    // 图表宽度像素数
   long              chart_height;                   // 图表高度像素数
   long              chart_width_step;               // 水平步长
   long              chart_height_step;              // 垂直步长
   int               columns_number;                 // 列数
   int               limes_number;                   // 行数
   int               curr_column;
   int               curr_row;

private:
   int               type;                           // 编辑栏位类型 ( 字符串, 数字 )

private:
   void              SetParams(long _chart_id,int _window,int _cols,int _lines);// 设置对象参数

public:
   string            GetUniqName();                  // 取得唯一名称
   bool              Create(long _chart_id,int _window,int _cols,int _lines,int _col,int _row);
   void              RecalcAndRedraw();              // 重新计算坐标并重绘

public:
   void              TFieldDisplay();                // 构造函数
   void             ~TFieldDisplay();                // 析构函数
  };
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//	构造函数
//---------------------------------------------------------------------
void TFieldDisplay::TFieldDisplay()
  {
  }
//---------------------------------------------------------------------
//	析构函数
//---------------------------------------------------------------------
void TFieldDisplay::~TFieldDisplay()
  {
  }
//---------------------------------------------------------------------
//	创建对象
//---------------------------------------------------------------------
bool TFieldDisplay::Create(long _chart_id,int _window,int _cols,int _lines,int _col,int _row)
  {
   this.curr_column=_col;
   this.curr_row=_row;
   SetParams(_chart_id,_window,_cols,_lines);

   return(this.Create(this.chart_id,this.GetUniqName(),this.sub_window,(int)(_col*this.chart_width_step),(int)(_row*this.chart_height_step)));
  }
//---------------------------------------------------------------------
//	设置对象参数
//---------------------------------------------------------------------
void TFieldDisplay::SetParams(long _chart_id,int _window,int _cols,int _lines)
  {
   this.chart_id=_chart_id;
   this.sub_window=_window;
   this.columns_number=_cols;
   this.limes_number=_lines;

//	取得窗口宽度的像素数
   this.chart_width=GetSystemMetrics(SM_CXFULLSCREEN);
   this.chart_height=GetSystemMetrics(SM_CYFULLSCREEN);

//	计算步长
   this.chart_width_step=this.chart_width/_cols;
   this.chart_height_step=this.chart_height/_lines;
  }
//---------------------------------------------------------------------
//	重新计算并重绘
//---------------------------------------------------------------------
void TFieldDisplay::RecalcAndRedraw()
  {
//	取得窗口尺寸 (像素数)
   long   width=GetSystemMetrics(SM_CXFULLSCREEN);
   long   height=GetSystemMetrics(SM_CYFULLSCREEN);
   if(width==this.chart_width && height==this.chart_height)
     {
      return;
     }

   this.chart_width=width;
   this.chart_height=height;

//	计算步长
   this.chart_width_step=this.chart_width/this.columns_number;
   this.chart_height_step=this.chart_height/this.limes_number;

//	把对象移动到新坐标
   this.X_Distance(( int )( this.curr_column * this.chart_width_step ));
   this.Y_Distance(( int )( this.curr_row * this.chart_height_step ));
  }
//---------------------------------------------------------------------
//	取得唯一名称
//---------------------------------------------------------------------
string TFieldDisplay::GetUniqName()
  {
   static uint   prev_count=0;

   uint         count=GetTickCount();
   while(1)
     {
      if(prev_count==UINT_MAX)
        {
         prev_count=0;
        }
      if(count<=prev_count)
        {
         prev_count++;
         count=prev_count;
        }
      else
        {
         prev_count=count;
        }

      //	计算唯一名称
      string      name=TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS)+" "+DoubleToString(count,0);
      if(ObjectFind(0,name)<0)
        {
         return(name);
        }
     }

   return(NULL);
  }
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//	TableDisplay 类 (对象列表)
//---------------------------------------------------------------------
class TableDisplay : public CList
  {
protected:
   long              chart_id;
   int               sub_window;
   ENUM_BASE_CORNER  corner;

public:
   void              SetParams(long _chart_id,int _window,ENUM_BASE_CORNER _corner=CORNER_LEFT_UPPER);
   int               AddTitleObject(int _cols,int _lines,int _col,int _row,string _title,color _color,string _fontname="Arial",int _fontsize=10);
   int               AddFieldObject(int _cols,int _lines,int _col,int _row,color _color,string _fontname="Arial",int _fontsize=10);
   bool              SetColor(int _index,color _color);
   bool              SetFont(int _index,string _fontname,int _fontsize);
   bool              SetText(int _index,string _text);
   bool              SetAnchor(int _index,ENUM_ANCHOR_POINT _anchor);

public:
   void              TableDisplay();
   void             ~TableDisplay();
  };
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//	构造函数
//---------------------------------------------------------------------
void TableDisplay::TableDisplay()
  {
   this.chart_id=0;
   this.sub_window=0;
   this.corner=CORNER_LEFT_UPPER;
  }
//---------------------------------------------------------------------
//	析构函数
//---------------------------------------------------------------------
void TableDisplay::~TableDisplay()
  {
//	Delete all objects
   this.Clear();
  }
//---------------------------------------------------------------------
//	设置所有列表对象的通用参数
//---------------------------------------------------------------------
void TableDisplay::SetParams(long _chart_id,int _window,ENUM_BASE_CORNER _corner)
  {
   this.chart_id=_chart_id;
   this.sub_window=_window;
   this.corner=_corner;
  }
//---------------------------------------------------------------------
//	增加一个抬头 (标题) 对象
//---------------------------------------------------------------------
int TableDisplay::AddTitleObject(int _cols,int _lines,int _col,int _row,string _title,color _color,string _fontname,int _fontsize)
  {
   TTitleDisplay      *title=new TTitleDisplay();
   title.Create( this.chart_id, this.sub_window, _cols, _lines, _col, _row );
   title.Description( _title );
   title.Color( _color );
   title.Font( _fontname );
   title.FontSize( _fontsize );
   title.Corner( this.corner );
   return(this.Add(title));
  }
//---------------------------------------------------------------------
//	增加编辑框栏位对象 
//---------------------------------------------------------------------
int TableDisplay::AddFieldObject(int _cols,int _lines,int _col,int _row,color _color,string _fontname,int _fontsize)
  {
   TFieldDisplay      *field=new TFieldDisplay();
   field.Create( this.chart_id, this.sub_window, _cols, _lines, _col, _row );
   field.Description( "" );
   field.Color( _color );
   field.Font( _fontname );
   field.FontSize( _fontsize );
   field.Corner( this.corner );
   return(this.Add(field));
  }
//---------------------------------------------------------------------
//	设置固定点
//---------------------------------------------------------------------
bool TableDisplay::SetAnchor(int _index,ENUM_ANCHOR_POINT _anchor)
  {
   CChartObjectText   *object=GetNodeAtIndex(_index);
   if(object==NULL)
     {
      return(false);
     }
   return(object.Anchor(_anchor));
  }
//---------------------------------------------------------------------
//	设置图形对象的颜色
//---------------------------------------------------------------------
bool TableDisplay::SetColor(int _index,color _color)
  {
   CChartObjectText   *object=GetNodeAtIndex(_index);
   if(object==NULL)
     {
      return(false);
     }
   return(object.Color(_color));
  }
//---------------------------------------------------------------------
//	设置字体
//---------------------------------------------------------------------
bool TableDisplay::SetFont(int _index,string _fontname,int _fontsize)
  {
   CChartObjectText   *object=GetNodeAtIndex(_index);
   if(object==NULL)
     {
      return(false);
     }

   if(object.Font(_fontname)==false)
     {
      return(false);
     }
   return(object.FontSize(_fontsize));
  }
//---------------------------------------------------------------------
//	设置文字
//---------------------------------------------------------------------
bool TableDisplay::SetText(int _index,string _text)
  {
   CChartObjectText   *object=GetNodeAtIndex(_index);
   if(object==NULL)
     {
      return(false);
     }
   return(object.Description(_text));
  }
//---------------------------------------------------------------------

//+------------------------------------------------------------------+
//| Algo:      SmartAlpha - Datafeed fetch
//| CodeName:  SmartAlpha Datafeed      
//| Team:      Taatu Ltd. (info@taatu.co)
//| Motto:     We are bad ass !!!!
//|
//| Date:      February 9, 2018
//|
//| Desc:      This script is intended to fetch data from MT5 and write
//|            records into csv, with price info date, open, close, high, low.
//|
//| Experim:  
//|
//|           ************************************************************
//|           Algo can be attached to any chart: settings are dynamic.
//|           ************************************************************
//|                                                                  
//+------------------------------------------------------------------+
#property copyright "Copyright © 2018"
string version  =   "0.0.0.4";
string AlgoName =   "SA - Datafeed fetch (MT5)";

//input int execution_hour = 2; //Datafeed Script Execution Time
input bool manual_run = false; //Run Script Manually
input string specific_symbol = ""; //Enter specific symbol to export (Leave blank = export all)
int current_manual_run = 0;
int execution_minute_batch_1 = 10;

//+------------------------------------------------------------------+
//| LIBRARIES
//+------------------------------------------------------------------+
#include <tframework.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   tfk_run_taatu_framework(AlgoName, version);
   
   if (current_manual_run == 0 && manual_run) current_manual_run = 1;

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if ( (tfk_Minute() == execution_minute_batch_1) || (current_manual_run == 1) ) {
         build_and_extract_Data();
         tfk_export_deals_trades_to_csv(HistoryDealsTotal() );
   }
      
  }
    
//+------------------------------------------------------------------+
//| Create a list of instrument to export, fetch & build
//+------------------------------------------------------------------+
void build_and_extract_Data()
{   
   int TotalNumberSymbols=SymbolsTotal(false);
   int CurrentNumberSymbols=SymbolsTotal(true);
   string symbol_exportname ="";
      for(int i=0;i<TotalNumberSymbols;i++)
        {
         symbol_exportname = SymbolName(i,false);
         //Search for substring
         if (StringFind( SymbolName(i,false),"COCOA",0)!=-1) symbol_exportname = "COCOA";
         if (StringFind( SymbolName(i,false),"COFFE",0)!=-1) symbol_exportname = "COFFE";
         if (StringFind( SymbolName(i,false),"CORN",0)!=-1) symbol_exportname = "CORN";
         if (StringFind( SymbolName(i,false),"COTTO",0)!=-1) symbol_exportname = "COTTO";
         if (StringFind( SymbolName(i,false),"HGCOP",0)!=-1) symbol_exportname = "HGCOP";
         if (StringFind( SymbolName(i,false),"SBEAN",0)!=-1) symbol_exportname = "SBEAN";
         if (StringFind( SymbolName(i,false),"SUGAR",0)!=-1) symbol_exportname = "SUGAR";
         if (StringFind( SymbolName(i,false),"WHEAT",0)!=-1) symbol_exportname = "WHEAT";
         if (StringFind( SymbolName(i,false),"BRENT",0)!=-1) symbol_exportname = "BRENT";
         if (StringFind( SymbolName(i,false),"GSOIL",0)!=-1) symbol_exportname = "GSOIL";
         if (StringFind( SymbolName(i,false),"NGAS",0)!=-1) symbol_exportname = "NGAS";
         if (StringFind( SymbolName(i,false),"OIL",0)!=-1) symbol_exportname = "OIL";         
         
         if ( (specific_symbol=="") || ( specific_symbol!="" && StringFind( SymbolName(i,false),specific_symbol,0)!=-1) ) {
            tfk_export_hist_Data_csv(symbol_exportname,SymbolName(i,false),PERIOD_D1,800);  
         }
         Print(symbol_exportname); 
         
        }
   Comment("Data Feed Export completed.");
   current_manual_run = 2;
}  
//+------------------------------------------------------------------+

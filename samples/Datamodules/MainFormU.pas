unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  ColumbusModule.CustomersU, Vcl.StdCtrls,
  ColumbusCommons, MainDataModuleU, FireDAC.Stan.StorageXML, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.Buttons;

type
  TMainForm = class(TForm, IColumbusObserver)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Panel1: TPanel;
    Label1: TLabel;
    DataSource2: TDataSource;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    Panel3: TPanel;
    btnExport: TSpeedButton;
    Button1: TSpeedButton;
    ActionList1: TActionList;
    actExportCustomers: TAction;
    actGeocoding: TAction;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure actExportCustomersExecute(Sender: TObject);
    procedure actGeocodingExecute(Sender: TObject);
  public
    procedure UpdateObserver(const Sender: TObject; const ModuleName: String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


uses ColumbusModule.SalesU, FireDAC.Stan.Intf;

procedure TMainForm.actExportCustomersExecute(Sender: TObject);
begin
  if SaveDialog1.Execute(self.Handle) then
  begin
    // you can also call a specialized method on the datamodule which call the ExportToFile
    DataModuleMain.ExportToFile(SaveDialog1.FileName);
  end;

end;

procedure TMainForm.actGeocodingExecute(Sender: TObject);
begin
  DataModuleMain.CustomerGeocoding;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DataModuleMain.CustomerModule.RegisterObserver(self);
  DataModuleMain.SalesModule.RegisterObserver(self);
  DataModuleMain.dsCustomers.Open;
  DataModuleMain.dsSales.Open;
end;

procedure TMainForm.UpdateObserver(const Sender: TObject; const ModuleName: String);
var
  lCustomerModule: TCustomerModule;
begin
  if SameText(ModuleName, 'TCustomerModule') then
  begin
    lCustomerModule := Sender as TCustomerModule;
    Label1.Caption := Format('%d persons lives in California',
      [lCustomerModule.PeopleInCalifornia]) + sLineBreak +
      'Sales count: ' + lCustomerModule.SalesCount.ToString;
    Label3.Visible := lCustomerModule.GeocodeIsValid;
    if Label3.Visible then
    begin
      Label3.Caption := Format('Lat: %.6f' + sLineBreak + 'Lon: %.6f',
        [lCustomerModule.CustomertLat, lCustomerModule.CustomerLon]);
    end;
  end;
  if SameText(ModuleName, 'TSalesModule') then
  begin
    Label2.Caption := 'TOTAL SALES VALUE: € ' +
      FormatCurr('0.00', (Sender as TSalesModule).TotalValue).PadLeft(8);
  end;
end;

end.

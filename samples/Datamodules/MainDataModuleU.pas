unit MainDataModuleU;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.IBBase, ColumbusCommons,
  ColumbusModule.CustomersU, ColumbusModule.SalesU;

type
  TDataModuleMain = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    dsCustomers: TFDQuery;
    dsrcCustomers: TDataSource;
    dsSales: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    FCustomerModule: TCustomerModule;
    FSalesModule: TSalesModule;
    { Private declarations }
  public
    procedure ExportToFile(const Filename: String);
    procedure CustomerGeocoding;
    function CustomerModule: TColumbusSubject;
    function SalesModule: TColumbusSubject;
  end;

var
  DataModuleMain: TDataModuleMain;

implementation

uses
  ExportServiceU, GeocodingServiceU;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}


procedure TDataModuleMain.CustomerGeocoding;
begin
  FCustomerModule.CustomerGeocode;
end;

function TDataModuleMain.CustomerModule: TColumbusSubject;
begin
  Result := FCustomerModule;
end;

procedure TDataModuleMain.DataModuleCreate(Sender: TObject);
begin
  FCustomerModule := TCustomerModule.Create(dsCustomers, TExportService.Create, TGeocodingService.Create);
  FSalesModule := TSalesModule.Create(dsSales);
end;

procedure TDataModuleMain.ExportToFile(const Filename: String);
begin
  FCustomerModule.ExportToFile(Filename);
end;

function TDataModuleMain.SalesModule: TColumbusSubject;
begin
  Result := FSalesModule;
end;

end.

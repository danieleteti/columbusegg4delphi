unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, Vcl.ExtCtrls, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.IBBase, FireDAC.Comp.UI, ColumbusModule.CustomersU, Vcl.StdCtrls,
  ColumbusCommons;

type
  TMainForm = class(TForm, IColumbusObserver)
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Panel1: TPanel;
    lblItalianCustomer: TLabel;
    lblCaliforniaPeopleCount: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCustomerModule: TCustomerModule;
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure UpdateObserver(const Sender: TObject; const ModuleName: String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


procedure TMainForm.FormCreate(Sender: TObject);
begin
  FCustomerModule := TCustomerModule.Create(FDQuery1);
  FCustomerModule.RegisterObserver(Self);
  FDQuery1.Open;
end;

procedure TMainForm.UpdateObserver(const Sender: TObject; const ModuleName: String);
begin
  lblCaliforniaPeopleCount.Caption := Format('%d persons lives in California', [(Sender as TCustomerModule).PeopleInCalifornia]);
  lblItalianCustomer.Visible := (Sender as TCustomerModule).IsItalianCustomer;
end;

end.

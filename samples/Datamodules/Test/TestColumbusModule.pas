unit TestColumbusModule;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, DB, ColumbusModule.CustomersU,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageXML,
  ColumbusCommons;

type
  // Test methods for class TCustomerModule

  TestTCustomerModule = class(TTestCase)
  strict private
    FCustomerModule: TCustomerModule;
  private
    FDataSet: TFDMemTable;
    FListener: IColumbusObserver;
    procedure LoadCustomersXML;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCalcCaliforniaPersons;
    procedure TestExportToFile;
  end;

  TColumbusObserver = class(TInterfacedObject, IColumbusObserver)
  protected
    procedure UpdateObserver(const Sender: TObject; const ModuleName: string);
  end;

implementation

uses
  ExportServiceU, FireDAC.Stan.Intf,
  GeocodingServiceU, System.SysUtils;


procedure TestTCustomerModule.LoadCustomersXML;
begin
  if FileExists('customers.xml') then
    FDataSet.LoadFromFile('customers.xml', sfXML)
  else if FileExists('../../customers.xml') then
    FDataSet.LoadFromFile('../../customers.xml', sfXML)
  else
    raise EInOutError.Create('File with XML Dataset not found!');
end;

procedure TestTCustomerModule.SetUp;
begin
  FListener := TColumbusObserver.Create;
  FDataSet := TFDMemTable.Create(nil);
  FCustomerModule := TCustomerModule.Create(FDataSet, TExportService.Create, TGeocodingService.Create);
  FCustomerModule.RegisterObserver(FListener);
  LoadCustomersXML;
end;

procedure TestTCustomerModule.TearDown;
begin
  FCustomerModule.Free;
  FDataSet.Free;
end;

procedure TestTCustomerModule.TestCalcCaliforniaPersons;
begin
  FDataSet.Open;
  CheckEquals(3, FCustomerModule.PeopleInCalifornia);
end;

procedure TestTCustomerModule.TestExportToFile;
var
  FileName: string;
begin
  // FCustomerModule.ExportToFile(FileName);
end;

{ TColumbusObserver }

procedure TColumbusObserver.UpdateObserver(const Sender: TObject;
  const ModuleName: string);
begin

end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTCustomerModule.Suite);

end.

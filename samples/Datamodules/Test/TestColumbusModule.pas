unit TestColumbusModule;

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
    procedure TestExportToCSV;
    procedure TestGeocodeOfCustomer1003;
  end;

  TColumbusObserver = class(TInterfacedObject, IColumbusObserver)
  protected
    procedure UpdateObserver(const Sender: TObject; const ModuleName: string);
  end;

implementation

uses
  ExportServiceU, FireDAC.Stan.Intf,
  GeocodingServiceU, System.SysUtils, System.Classes, System.Hash, GlobalConsts;


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
  FCustomerModule := TCustomerModule.Create(FDataSet, TExportService.Create,
    TGeocodingService.Create(GoogleAPIKey));
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

function GetStrHashSHA1(Str: String): String;
var
  HashSHA: System.Hash.THashSHA1;
begin
  HashSHA := THashSHA1.Create;
  HashSHA.GetHashString(Str);
  result := HashSHA.GetHashString(Str);
end;

procedure TestTCustomerModule.TestExportToCSV;
var
  Stream: TStringStream;
  Hash: string;
begin
  Stream := TStringStream.Create;
  FCustomerModule.ExportToStream(Stream);
  Hash := GetStrHashSHA1(Stream.DataString);
  CheckEquals('df8199e4b6b9009b8e8070c0acccb6c1b1c290b4', Hash);
  Stream.Free;
end;

procedure TestTCustomerModule.TestGeocodeOfCustomer1003;
var
  CustomerID: Integer;
begin
  CustomerID := 1003;
  if not FCustomerModule.DataSet.Locate('CUST_NO', CustomerID, []) then
    Fail(Format('Cant locate CUST_NO=%d in the database', [CustomerID]));
  FCustomerModule.CustomerGeocode;
  CheckEquals(42.3600825, FCustomerModule.CustomertLat, 0.00000001,
    'Incorect Latitude');
  CheckEquals(-71.0588801, FCustomerModule.CustomerLon, 0.00000001,
    'Incorect Longitude');
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

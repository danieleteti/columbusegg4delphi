unit ColumbusModule.CustomersU;

interface

uses
  DB, ColumbusCommons, ExportServiceU, GeocodingServiceU,
  ColumbusUIListenerInterface;

type
  TCustomerModule = class(TCustomColumbusModule)
  private
    FPeopleInCalifornia: Integer;
    FExportService: IExportService;
    FGeocodingService: IGeocodingService;
    FCustomertLat: Extended;
    FCustomerLon: Extended;
    FGeocodeIsValid: Boolean;
    procedure CalcCaliforniaPersons;
    function GetSalesCount: Integer;
    procedure SetExportService(const Value: IExportService);
    procedure SetGeocodingService(const Value: IGeocodingService);
    procedure SetCustomerLon(const Value: Extended);
    procedure SetCustomertLat(const Value: Extended);
  protected
    procedure AfterOpen(aDataSet: TDataSet); override;
    procedure BeforeDelete(aDataSet: TDataSet); override;
    procedure BeforePost(aDataSet: TDataSet); override;
    procedure AfterDelete(aDataSet: TDataSet); override;
    procedure AfterPost(aDataSet: TDataSet); override;
    procedure AfterScroll(aDataSet: TDataSet); override;
  public
    constructor Create(aDataSet: TDataSet; aExportService: IExportService; aGeocodingService: IGeocodingService; aListener: IColumbusUIListener = nil);
    procedure ExportToFile(FileName: String);
    procedure CustomerGeocode;
    property PeopleInCalifornia: Integer read FPeopleInCalifornia;
    property SalesCount: Integer read GetSalesCount;
    property CustomertLat: Extended read FCustomertLat write SetCustomertLat;
    property CustomerLon: Extended read FCustomerLon write SetCustomerLon;
    property GeocodeIsValid: Boolean read FGeocodeIsValid;
  end;

implementation

uses
  SysUtils, Dialogs, Controls;

{ TCustomerTableModule }

procedure TCustomerModule.AfterDelete(aDataSet: TDataSet);
begin
  inherited;
  CalcCaliforniaPersons;
end;

procedure TCustomerModule.AfterOpen(aDataSet: TDataSet);
begin
  inherited;
  CalcCaliforniaPersons;
end;

procedure TCustomerModule.AfterPost(aDataSet: TDataSet);
begin
  CalcCaliforniaPersons;
end;

procedure TCustomerModule.AfterScroll(aDataSet: TDataSet);
begin
  inherited;
  FGeocodeIsValid := False;
  NotifyObservers;
end;

procedure TCustomerModule.BeforeDelete(aDataSet: TDataSet);
begin
  inherited;
  if SameText(aDataSet.FieldByName('COUNTRY').AsString, 'ITALY') then
    raise Exception.Create('You cannot delete italian people!');
  if SameText(aDataSet.FieldByName('STATE_PROVINCE').AsString, 'CA') then
  begin
    if UIListener.UIMessageDialog('Do you really want to delete this customer from California?', mtConfirmation,
      mbyesno) <> mrYes then
      Abort;
  end;
end;

procedure TCustomerModule.BeforePost(aDataSet: TDataSet);
begin
  inherited;
  if aDataSet.FieldByName('CONTACT_FIRST').AsString.IsEmpty or
    aDataSet.FieldByName('CONTACT_LAST').AsString.IsEmpty then
    raise Exception.Create('First name and last name are mandatory');
end;

procedure TCustomerModule.CalcCaliforniaPersons;
begin
  FPeopleInCalifornia := 0;
  FreezeDataset;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      if DataSet.FieldByName('STATE_PROVINCE').AsString = 'CA' then
        Inc(FPeopleInCalifornia);
      DataSet.Next;
    end;
  finally
    UnFreezeDataset;
  end;
  NotifyObservers;
end;

constructor TCustomerModule.Create(aDataSet: TDataSet;
  aExportService: IExportService; aGeocodingService: IGeocodingService;
  aListener: IColumbusUIListener);
begin
  inherited Create(aDataSet, aListener);
  FExportService := aExportService;
  FGeocodingService := aGeocodingService;
end;

procedure TCustomerModule.ExportToFile(FileName: String);
begin
  FExportService.SaveToCSV(DataSet, FileName);
  UIListener.UIMessageDialog('Customers exported in ' + FileName, mtInformation, [mbOK]);
end;

procedure TCustomerModule.CustomerGeocode;
begin
  FGeocodingService.GetCoords(DataSet.FieldByName('CITY').AsString,
    DataSet.FieldByName('STATE_PROVINCE').AsString, FCustomertLat, FCustomerLon);
  FGeocodeIsValid := True;
  NotifyObservers;
end;

function TCustomerModule.GetSalesCount: Integer;
begin
  Result := Modules['TSalesModule'].DataSet.RecordCount;
end;

procedure TCustomerModule.SetCustomerLon(const Value: Extended);
begin
  FCustomerLon := Value;
end;

procedure TCustomerModule.SetCustomertLat(const Value: Extended);
begin
  FCustomertLat := Value;
end;

procedure TCustomerModule.SetExportService(const Value: IExportService);
begin
  FExportService := Value;
end;

procedure TCustomerModule.SetGeocodingService(const Value: IGeocodingService);
begin
  FGeocodingService := Value;
end;

end.

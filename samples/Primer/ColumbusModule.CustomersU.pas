unit ColumbusModule.CustomersU;

interface

uses
  FireDAC.Comp.DataSet, Data.DB, ColumbusCommons;

type
  TCustomerModule = class(TCustomColumbusModule)
  private
    FPeopleInCalifornia: Integer;
    procedure CalcCaliforniaPersons;
  protected
    procedure AfterOpen(aDataSet: TDataSet); override;
    procedure BeforeDelete(aDataSet: TDataSet); override;
    procedure BeforePost(aDataSet: TDataSet); override;
    procedure AfterDelete(aDataSet: TDataSet); override;
    procedure AfterPost(aDataSet: TDataSet); override;
    procedure AfterScroll(aDataSet: TDataSet); override;
    procedure OnNewRecord(aDataSet: TDataSet); override;
  public
    property PeopleInCalifornia: Integer read FPeopleInCalifornia;
    function IsItalianCustomer: Boolean;
  end;

implementation

uses
  System.SysUtils;

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
  NotifyObservers;
end;

procedure TCustomerModule.BeforeDelete(aDataSet: TDataSet);
begin
  inherited;
  if IsItalianCustomer then
    raise Exception.Create('You cannot delete italian customers!');
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

function TCustomerModule.IsItalianCustomer: Boolean;
begin
  Result := SameText(DataSet.FieldByName('COUNTRY').AsString, 'ITALY');
end;

procedure TCustomerModule.OnNewRecord(aDataSet: TDataSet);
begin
  inherited;
  aDataSet.FieldByName('COUNTRY').AsString := 'Italy';
  aDataSet.FieldByName('STATE_PROVINCE').AsString := 'IT';
end;

end.

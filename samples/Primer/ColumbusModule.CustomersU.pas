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
    procedure AfterOpen; override;
    procedure BeforeDelete; override;
    procedure BeforePost; override;
    procedure AfterDelete; override;
    procedure AfterPost; override;
    procedure AfterScroll; override;
    procedure OnNewRecord; override;
  public
    property PeopleInCalifornia: Integer read FPeopleInCalifornia;
    function IsItalianCustomer: Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TCustomerTableModule }

procedure TCustomerModule.AfterDelete;
begin
  inherited;
  CalcCaliforniaPersons;
end;

procedure TCustomerModule.AfterOpen;
begin
  inherited;
  CalcCaliforniaPersons;
end;

procedure TCustomerModule.AfterPost;
begin
  CalcCaliforniaPersons;
end;

procedure TCustomerModule.AfterScroll;
begin
  inherited;
  NotifyObservers;
end;

procedure TCustomerModule.BeforeDelete;
begin
  inherited;
  if IsItalianCustomer then
    raise Exception.Create('You cannot delete italian customers!');
end;

procedure TCustomerModule.BeforePost;
begin
  inherited;
  if DataSet.FieldByName('CONTACT_FIRST').AsString.IsEmpty or
    DataSet.FieldByName('CONTACT_LAST').AsString.IsEmpty then
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

procedure TCustomerModule.OnNewRecord;
begin
  inherited;
  DataSet.FieldByName('COUNTRY').AsString := 'Italy';
  DataSet.FieldByName('STATE_PROVINCE').AsString := 'IT';
end;

end.

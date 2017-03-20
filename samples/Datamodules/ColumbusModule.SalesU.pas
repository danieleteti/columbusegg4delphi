unit ColumbusModule.SalesU;

interface

uses
  DB, ColumbusCommons;

type
  TSalesModule = class(TCustomColumbusModule)
  private
    FTotalValue: Currency;
    procedure CalcTotalValue;
  protected
    procedure AfterOpen; override;
    procedure AfterDelete; override;
    procedure AfterPost; override;
    procedure AfterScroll; override;
  public
    property TotalValue: Currency read FTotalValue;
  end;

implementation

{ TSalesModule }

procedure TSalesModule.AfterDelete;
begin
  inherited;
  CalcTotalValue;
end;

procedure TSalesModule.AfterOpen;
begin
  inherited;
  CalcTotalValue;
end;

procedure TSalesModule.AfterPost;
begin
  inherited;
  CalcTotalValue;
end;

procedure TSalesModule.AfterScroll;
begin
  inherited;
  CalcTotalValue;
end;

procedure TSalesModule.CalcTotalValue;
begin
  FreezeDataset(true);
  try
    FTotalValue := 0;
    DataSet.First;
    while not DataSet.Eof do
    begin
      FTotalValue := FTotalValue + DataSet.FieldByName('TOTAL_VALUE').AsCurrency;
      DataSet.Next;
    end;
  finally
    UnFreezeDataset;
  end;
  NotifyObservers;
end;

end.

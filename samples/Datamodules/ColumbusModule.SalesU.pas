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
    procedure AfterOpen(aDataSet: TDataSet); override;
    procedure AfterDelete(aDataSet: TDataSet); override;
    procedure AfterPost(aDataSet: TDataSet); override;
    procedure AfterScroll(aDataSet: TDataSet); override;
  public
    property TotalValue: Currency read FTotalValue;
  end;

implementation

{ TSalesModule }

procedure TSalesModule.AfterDelete(aDataSet: TDataSet);
begin
  inherited;
  CalcTotalValue;
end;

procedure TSalesModule.AfterOpen(aDataSet: TDataSet);
begin
  inherited;
  CalcTotalValue;
end;

procedure TSalesModule.AfterPost(aDataSet: TDataSet);
begin
  inherited;
  CalcTotalValue;
end;

procedure TSalesModule.AfterScroll(aDataSet: TDataSet);
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

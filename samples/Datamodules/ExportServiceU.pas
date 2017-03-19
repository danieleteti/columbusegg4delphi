unit ExportServiceU;

interface

uses
  DB;

type
  IExportService = interface
    ['{2E6069B5-D2CC-476D-9CAA-8357846F1E80}']
    procedure SaveToCSV(DataSet: TDataSet; FileName: String);
  end;

  TExportService = class(TInterfacedObject, IExportService)
  public
    procedure SaveToCSV(DataSet: TDataSet; FileName: string);
  end;

implementation

uses
  Classes, SysUtils;

{ TExportService }

// http: // stackoverflow.com/questions/5680017/delphi-tquery-save-to-csv-file

procedure TExportService.SaveToCSV(DataSet: TDataSet; FileName: string);
const
  Delimiter: Char = ';'; // In order to be automatically recognized in Microsoft Excel use ";", not ","
  Enclosure: Char = '"';
var
  List: TStringList;
  S: String;
  function EscapeString(S: string): string;
  begin
    Result := StringReplace(S, Enclosure, Enclosure + Enclosure, [rfReplaceAll]);
    if (Pos(Delimiter, S) > 0) or (Pos(Enclosure, S) > 0) then // Comment this line for enclosure in every fields
      Result := Enclosure + Result + Enclosure;
  end;
  procedure AddHeader;
  var
    I: Integer;
  begin
    S := '';
    for I := 0 to DataSet.FieldCount - 1 do
    begin
      if S > '' then
        S := S + Delimiter;
      S := S + EscapeString(DataSet.Fields[I].FieldName);
    end;
    List.Add(S);
  end;
  procedure AddRecord;
  var
    I: Integer;
  begin
    S := '';
    for I := 0 to DataSet.FieldCount - 1 do
    begin
      if S > '' then
        S := S + Delimiter;
      S := S + EscapeString(DataSet.Fields[I].AsString);
    end;
    List.Add(S);
  end;

begin
  List := TStringList.Create;
  try
    DataSet.DisableControls;
    DataSet.First;
    AddHeader; // Comment if header not required
    while not DataSet.Eof do
    begin
      AddRecord;
      DataSet.Next;
    end;
  finally
    List.SaveToFile(FileName);
    DataSet.First;
    DataSet.EnableControls;
    List.Free;
  end;
end;

end.

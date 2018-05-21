unit ExportServiceU;

interface

uses
  DB, System.Classes;

type
  IExportService = interface
    ['{2E6069B5-D2CC-476D-9CAA-8357846F1E80}']
    procedure SaveToCSV(DataSet: TDataSet; FileName: String); overload;
    procedure SaveToCSV(DataSet: TDataSet; Stream: TStream); overload;
  end;

  TExportService = class(TInterfacedObject, IExportService)
  private
    procedure WriteDataSetToTStringsAsCSV(DataSet: TDataSet; sl: TStrings);
  public
    procedure SaveToCSV(DataSet: TDataSet; FileName: string); overload;
    procedure SaveToCSV(DataSet: TDataSet; Stream: TStream); overload;
  end;


implementation

uses
  SysUtils;

{ TExportService }

procedure TExportService.SaveToCSV(DataSet: TDataSet; FileName: string);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    WriteDataSetToTStringsAsCSV(DataSet,List);
    List.SaveToFile(FileName);
  finally
    List.Free;
  end;
end;

procedure TExportService.SaveToCSV(DataSet: TDataSet; Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    WriteDataSetToTStringsAsCSV(DataSet,List);
    List.SaveToStream(Stream);
  finally
    List.Free;
  end;
end;

// http: // stackoverflow.com/questions/5680017/delphi-tquery-save-to-csv-file

procedure TExportService.WriteDataSetToTStringsAsCSV(DataSet: TDataSet;
  sl: TStrings);
const
  // In order to be automatically recognized in Microsoft Excel use
  // Delimiter equal ";", not ","
  Delimiter: Char = ';';
  Enclosure: Char = '"';
  function EscapeString(S: string): string;
  begin
    Result := StringReplace(S, Enclosure, Enclosure + Enclosure,
      [rfReplaceAll]);
    if (Pos(Delimiter, S) > 0) or (Pos(Enclosure, S) > 0) then
      // Comment this line for enclosure in every fields
      Result := Enclosure + Result + Enclosure;
  end;
  procedure AddHeader(List: TStrings);
  var
    I: Integer;
    S: String;
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
  procedure AddRecord(List: TStrings);
  var
    I: Integer;
    S: String;
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
var
  bmk: TBookmark;
begin
  try
    DataSet.DisableControls;
    bmk := DataSet.GetBookmark;
    DataSet.First;
    AddHeader(sl);
    while not DataSet.Eof do
    begin
      AddRecord(sl);
      DataSet.Next;
    end;
  finally
    if DataSet.BookmarkValid(bmk) then
      DataSet.GotoBookmark(bmk);
    DataSet.EnableControls;
  end;
end;

end.

unit ColumbusModulesLocator;

interface

uses
  ColumbusCommons, Classes;

procedure RegisterColumbusModule(aOwner: TComponent; aModule: TCustomColumbusModule);
procedure UnRegisterColumbusModule(aOwner: TComponent; aModule: TCustomColumbusModule);
function GetColumbusModule(aOwner: TComponent; aModuleName: String): TCustomColumbusModule;

implementation

type
  PColumbusModulePair = ^TColumbusModulePair;

  TColumbusModulePair = record
    Owner: TComponent;
    ColumbusModule: TCustomColumbusModule;
  end;

  TColumbusModulesDict = class
  private
    FModulesList: TList;
    procedure DisposeListItems;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterModule(aOwner: TComponent; aModule: TCustomColumbusModule);
    procedure UnRegisterModule(aOwner: TComponent; aModule: TCustomColumbusModule);
    function IndexOf(aOwner: TComponent; aModule: TCustomColumbusModule): Integer;
    function GetModule(aOwner: TComponent; aModuleName: String): TCustomColumbusModule;
    function Count: Integer;
    function GetPair(const aIndex: Integer): PColumbusModulePair;
  end;

var
  GColumbusModuleLocator: TColumbusModulesDict = nil;
  GPointer: PColumbusModulePair = nil;

procedure RegisterColumbusModule(aOwner: TComponent; aModule: TCustomColumbusModule);
begin
  GColumbusModuleLocator.RegisterModule(aOwner, aModule);
end;

procedure UnRegisterColumbusModule(aOwner: TComponent; aModule: TCustomColumbusModule);
begin
  GColumbusModuleLocator.UnRegisterModule(aOwner, aModule);
end;

function GetColumbusModule(aOwner: TComponent; aModuleName: String): TCustomColumbusModule;
begin
  Result := GColumbusModuleLocator.GetModule(aOwner, aModuleName);
  if not Assigned(Result) then
    raise EColumbusException.CreateFmt('Unknown Module %s', [aModuleName]);
end;

function TColumbusModulesDict.Count: Integer;
begin
  Result := FModulesList.Count;
end;

constructor TColumbusModulesDict.Create;
begin
  inherited;
  FModulesList := TList.Create;
end;

procedure TColumbusModulesDict.DisposeListItems;
var
  I: Integer;
begin
  for I := 0 to FModulesList.Count - 1 do
  begin
    GPointer := FModulesList[I];
    Dispose(GPointer);
  end;
end;

destructor TColumbusModulesDict.Destroy;
begin
  DisposeListItems;
  FModulesList.Free;
  inherited;
end;

function TColumbusModulesDict.GetModule(aOwner: TComponent;
  aModuleName: String): TCustomColumbusModule;
var
  I: Integer;
  lColumbusModulePair: TColumbusModulePair;
begin
  Result := nil;
  for I := 0 to FModulesList.Count - 1 do
  begin
    lColumbusModulePair := PColumbusModulePair(FModulesList[I])^;
    if (lColumbusModulePair.Owner = aOwner) and
      (lColumbusModulePair.ColumbusModule.GetModuleName = aModuleName) then
    begin
      Result := lColumbusModulePair.ColumbusModule;
      Break;
    end;
  end;
end;

function TColumbusModulesDict.GetPair(
  const aIndex: Integer): PColumbusModulePair;
begin
  Result := FModulesList[aIndex];
end;

function TColumbusModulesDict.IndexOf(aOwner: TComponent;
  aModule: TCustomColumbusModule): Integer;
var
  I: Integer;
  lColumbusModulePair: TColumbusModulePair;
begin
  Result := -1;
  for I := 0 to FModulesList.Count - 1 do
  begin
    lColumbusModulePair := PColumbusModulePair(FModulesList[I])^;
    if (lColumbusModulePair.Owner = aOwner) and
      (lColumbusModulePair.ColumbusModule = aModule) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

procedure TColumbusModulesDict.RegisterModule(aOwner: TComponent;
  aModule: TCustomColumbusModule);
var
  lColumbusModulePair: PColumbusModulePair;
begin
  if IndexOf(aOwner, aModule) = -1 then
  begin
    lColumbusModulePair := New(PColumbusModulePair);
    lColumbusModulePair.Owner := aOwner;
    lColumbusModulePair.ColumbusModule := aModule;
    FModulesList.Add(lColumbusModulePair);
  end;
end;

procedure TColumbusModulesDict.UnRegisterModule(aOwner: TComponent;
  aModule: TCustomColumbusModule);
var
  lIndex: Integer;
  lP: PColumbusModulePair;
begin
  lIndex := IndexOf(aOwner, aModule);
  if lIndex > -1 then
  begin
    lP := FModulesList[lIndex];
    Dispose(lP);
    FModulesList.Delete(lIndex);
  end;
end;

initialization

GColumbusModuleLocator := TColumbusModulesDict.Create;

finalization

GColumbusModuleLocator.Free;

end.

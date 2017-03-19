unit ColumbusCommons;

interface

uses
  DB, Classes, Dialogs, SysUtils, ColumbusUIListenerInterface;

type
  IColumbusObserver = interface
    ['{1DC9E7EF-4538-464A-A23E-112F54DAF88E}']
    procedure UpdateObserver(const Sender: TObject; const ModuleName: String);
  end;

  IColumbusService = interface
    ['{9B2456CB-63FD-468A-99B3-55B8C2EFBDBB}']
    procedure ExecService(var aHandled: Boolean; const aServiceCode: Integer; aParams: array of const; var aResult: Variant);
  end;

  EColumbusException = class(Exception)

  end;

  TColumbusSubject = class(TComponent)
  private
    FObservers: TInterfaceList;
    FServices: TInterfaceList;
    FUIListener: IColumbusUIListener;
    function GetUIListener: IColumbusUIListener;
    procedure SetUIListener(const Value: IColumbusUIListener);
  protected
    procedure NotifyObservers;
    procedure ExecService(const aServiceCode: Integer; aParams: array of const; var aResult: Variant);
  public
    constructor Create(AOwner: TComponent); reintroduce; virtual;
    destructor Destroy; override;
    function GetModuleName: String; virtual;
    procedure RegisterObserver(aObserver: IColumbusObserver);
    procedure UnRegisterObserver(aObserver: IColumbusObserver);
    procedure RegisterService(aService: IColumbusService);
    procedure UnRegisterService(aService: IColumbusService);
    property UIListener: IColumbusUIListener read GetUIListener write SetUIListener;
  end;

  TCustomColumbusModule = class(TColumbusSubject)
  private
    FDataSet: TDataSet;
    FDataSetOwner: TComponent;
    FListener: IColumbusUIListener;

    {$IF CompilerVersion >= 20}

    FBookmark: TArray<Byte>;

    {$ELSE}

    FBookmark: String;

    {$IFEND}

    procedure HookEvents(aDataSet: TDataSet);
    procedure UnHookScrollEvents(aDataSet: TDataSet);
    procedure HookScrollEvents(aDataSet: TDataSet);
    function GetModuleByName(const aModuleName: String): TCustomColumbusModule;
  protected
    procedure FreezeDataset(aDisableScrollEvents: Boolean = False);
    procedure UnFreezeDataset;
    procedure OnNewRecord(aDataSet: TDataSet); virtual;
    procedure BeforePost(aDataSet: TDataSet); virtual;
    procedure BeforeDelete(aDataSet: TDataSet); virtual;
    procedure BeforeEdit(aDataSet: TDataSet); virtual;
    procedure BeforeInsert(aDataSet: TDataSet); virtual;
    procedure AfterOpen(aDataSet: TDataSet); virtual;
    procedure AfterPost(aDataSet: TDataSet); virtual;
    procedure AfterDelete(aDataSet: TDataSet); virtual;
    procedure AfterScroll(aDataSet: TDataSet); virtual;
    procedure AfterRefresh(aDataSet: TDataSet); virtual;
    procedure OnCalcFields(aDataSet: TDataSet); virtual;
    procedure OnEditError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction); virtual;
    property DataSetOwner: TComponent read FDataSetOwner;
    property Modules[const Index: String]: TCustomColumbusModule read GetModuleByName;
  public
    constructor Create(aDataSet: TDataSet; aListener: IColumbusUIListener = nil); reintroduce; virtual;
    destructor Destroy; override;
    procedure SafePost; virtual;
    procedure SafeEdit; virtual;
    property DataSet: TDataSet read FDataSet;
  end;

var
  ColumbusDefaultUIListener: TInterfacedClass = nil;

implementation

uses
  ColumbusModulesLocator, System.UITypes;

{ TCustomColumbusModule }

procedure TCustomColumbusModule.AfterDelete(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.AfterOpen(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.AfterPost(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.AfterScroll(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.AfterRefresh(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.BeforeDelete(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.BeforeEdit(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.BeforeInsert(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.BeforePost(aDataSet: TDataSet);
begin
  // do nothing
end;

constructor TCustomColumbusModule.Create(aDataSet: TDataSet; aListener: IColumbusUIListener);
begin
  inherited Create(aDataSet);
  FDataSet := aDataSet;
  FListener := aListener;
  FDataSetOwner := aDataSet.Owner;
  RegisterColumbusModule(DataSetOwner, Self);
  HookEvents(aDataSet);
end;

destructor TCustomColumbusModule.Destroy;
begin
  UnRegisterColumbusModule(DataSetOwner, Self);
  inherited;
end;

procedure TCustomColumbusModule.FreezeDataset(aDisableScrollEvents: Boolean);
begin
  FBookmark := DataSet.Bookmark;
  DataSet.DisableControls;
  if aDisableScrollEvents then
    UnHookScrollEvents(FDataSet);
end;

function TCustomColumbusModule.GetModuleByName(
  const aModuleName: String): TCustomColumbusModule;
begin
  Result := GetColumbusModule(DataSetOwner, aModuleName);
end;

function TColumbusSubject.GetModuleName: String;
begin
  Result := ClassName;
end;

procedure TCustomColumbusModule.HookEvents(aDataSet: TDataSet);
begin
  Assert(not Assigned(aDataSet.BeforePost), 'BeforePost is set on ' + aDataSet.name);
  aDataSet.BeforePost := BeforePost;

  Assert(not Assigned(aDataSet.BeforeDelete), 'BeforeDelete is set on ' + aDataSet.name);
  aDataSet.BeforeDelete := BeforeDelete;

  Assert(not Assigned(aDataSet.BeforeEdit), 'BeforeEdit is set on ' + aDataSet.name);
  aDataSet.BeforeEdit := BeforeEdit;

  Assert(not Assigned(aDataSet.BeforeInsert), 'BeforeInsert is set on ' + aDataSet.name);
  aDataSet.BeforeInsert := BeforeInsert;

  Assert(not Assigned(aDataSet.AfterOpen), 'AfterOpen is set on ' + aDataSet.name);
  aDataSet.AfterOpen := AfterOpen;

  Assert(not Assigned(aDataSet.AfterPost), 'AfterPost is set on ' + aDataSet.name);
  aDataSet.AfterPost := AfterPost;

  Assert(not Assigned(aDataSet.AfterDelete), 'AfterDelete is set on ' + aDataSet.name);
  aDataSet.AfterDelete := AfterDelete;

  Assert(not Assigned(aDataSet.OnCalcFields), 'OnCalcFields is set on ' + aDataSet.name);
  aDataSet.OnCalcFields := OnCalcFields;

  Assert(not Assigned(aDataSet.OnNewRecord), 'OnNewRecord is set on ' + aDataSet.name);
  aDataSet.OnNewRecord := OnNewRecord;

  Assert(not Assigned(aDataSet.OnEditError), 'OnEditError is set on ' + aDataSet.name);
  aDataSet.OnEditError := OnEditError;

  // All scroll events
  Assert(not Assigned(aDataSet.AfterScroll), 'AfterScroll is set on ' + aDataSet.name);
  Assert(not Assigned(aDataSet.AfterRefresh), 'AfterRefresh is set on ' + aDataSet.name);
  HookScrollEvents(aDataSet);
end;

procedure TCustomColumbusModule.HookScrollEvents(aDataSet: TDataSet);
begin
  aDataSet.AfterScroll := AfterScroll;
  aDataSet.AfterRefresh := AfterRefresh;
end;

procedure TCustomColumbusModule.OnCalcFields(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.OnEditError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  // do nothing
end;

procedure TCustomColumbusModule.OnNewRecord(aDataSet: TDataSet);
begin
  // do nothing
end;

procedure TCustomColumbusModule.SafeEdit;
begin
  if DataSet.State in [dsBrowse] then
    DataSet.Edit;
end;

procedure TCustomColumbusModule.SafePost;
begin
  if DataSet.State in [dsInsert, dsEdit] then
    DataSet.Post;
end;

procedure TCustomColumbusModule.UnFreezeDataset;
begin
  DataSet.Bookmark := FBookmark;
  HookScrollEvents(FDataSet);
  DataSet.EnableControls;
end;

procedure TCustomColumbusModule.UnHookScrollEvents(aDataSet: TDataSet);
begin
  aDataSet.AfterScroll := nil;
  aDataSet.AfterRefresh := nil;
end;

{ TSubject }

constructor TColumbusSubject.Create(AOwner: TComponent);
begin
  inherited;
  FObservers := TInterfaceList.Create;
  FServices := TInterfaceList.Create;
  FUIListener := nil;
end;

destructor TColumbusSubject.Destroy;
begin
  FObservers.Free;
  FServices.Free;
  inherited;
end;

procedure TColumbusSubject.ExecService(const aServiceCode: Integer;
  aParams: array of const; var aResult: Variant);
var
  I: Integer;
  lResult: Variant;
  lHandled: Boolean;
begin
  lHandled := False;
  for I := 0 to FServices.Count - 1 do
  begin
    IColumbusService(FServices[I]).ExecService(lHandled, aServiceCode, aParams, lResult);
    if lHandled then
    begin
      aResult := lResult;
      Break;
    end;
  end;
  if not lHandled then
    raise EColumbusException.CreateFmt('No service for ServiceCode = %d', [aServiceCode]);
end;

function TColumbusSubject.GetUIListener: IColumbusUIListener;
begin
  if FUIListener = nil then
  begin
    FUIListener := ColumbusDefaultUIListener.Create as IColumbusUIListener; // col TColumbusUIListener.Create;
    // raise EColumbusException.Create('UIListener not set');
  end;
  Result := FUIListener;
end;

procedure TColumbusSubject.NotifyObservers;
var
  I: Integer;
begin
  for I := 0 to FObservers.Count - 1 do
  begin
    IColumbusObserver(FObservers[I]).UpdateObserver(Self, GetModuleName);
  end;
end;

procedure TColumbusSubject.RegisterObserver(aObserver: IColumbusObserver);
var
  lOut: IColumbusUIListener;
begin
  FObservers.Add(aObserver);
  if (FUIListener = nil) and Supports(aObserver, IColumbusUIListener, lOut) then
  begin
    UIListener := lOut;
  end;
end;

procedure TColumbusSubject.RegisterService(aService: IColumbusService);
begin
  FServices.Add(aService);
end;

procedure TColumbusSubject.SetUIListener(const Value: IColumbusUIListener);
begin
  FUIListener := Value;
end;

procedure TColumbusSubject.UnRegisterObserver(aObserver: IColumbusObserver);
begin
  FObservers.Remove(aObserver);
end;

procedure TColumbusSubject.UnRegisterService(aService: IColumbusService);
begin
  FServices.Remove(aService);
end;

{ TColumbusUIListener }

end.

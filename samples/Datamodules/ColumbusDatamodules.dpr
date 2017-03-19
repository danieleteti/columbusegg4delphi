program ColumbusDatamodules;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  ColumbusModule.CustomersU in 'ColumbusModule.CustomersU.pas',
  MainDataModuleU in 'MainDataModuleU.pas' {DataModuleMain: TDataModule},
  ColumbusModule.SalesU in 'ColumbusModule.SalesU.pas',
  ExportServiceU in 'ExportServiceU.pas',
  VclUIListener in 'VclUIListener.pas',
  ColumbusUIListenerInterface in '..\..\ColumbusUIListenerInterface.pas',
  ColumbusCommons in '..\..\ColumbusCommons.pas',
  ColumbusModulesLocator in '..\..\ColumbusModulesLocator.pas',
  GeocodingServiceU in 'GeocodingServiceU.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModuleMain, DataModuleMain);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

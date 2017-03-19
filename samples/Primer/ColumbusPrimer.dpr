program ColumbusPrimer;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  ColumbusModule.CustomersU in 'ColumbusModule.CustomersU.pas',
  ColumbusCommons in '..\..\ColumbusCommons.pas',
  ColumbusModulesLocator in '..\..\ColumbusModulesLocator.pas',
  ColumbusUIListenerInterface in '..\..\ColumbusUIListenerInterface.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

program ColumbusDatamodulesTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestColumbusModule in 'TestColumbusModule.pas',
  ColumbusModule.CustomersU in '..\ColumbusModule.CustomersU.pas',
  Columbus.Commons in '..\..\..\Columbus.Commons.pas',
  Columbus.ModulesLocator in '..\..\..\Columbus.ModulesLocator.pas',
  ExportServiceU in '..\ExportServiceU.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.


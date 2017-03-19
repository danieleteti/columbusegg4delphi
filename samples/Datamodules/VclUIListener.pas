unit VclUIListener;

interface

uses
  ColumbusCommons, Dialogs, ColumbusUIListenerInterface;

type
  TColumbusUIListener = class(TInterfacedObject, IColumbusUIListener)
  protected
    function UIMessageDialog(const aMessage: string;
      const aDlgType: TMsgDlgType; const aButtons: TMsgDlgButtons; const aMessageCode: Integer = 0): Integer; virtual;
    function UIConfirm(const aMessage: String): Boolean; virtual;
    function UIInputBox(const ACaption, APrompt, ADefault: string): string;
  end;

implementation

uses
  Controls;

function TColumbusUIListener.UIConfirm(const aMessage: String): Boolean;
begin
  Result := UIMessageDialog(aMessage, TMsgDlgType.mtConfirmation, mbYesNo) = mrYes;
end;

function TColumbusUIListener.UIInputBox(const ACaption, APrompt,
  ADefault: string): string;
begin
  Result := InputBox(ACaption, APrompt, ADefault);
end;

function TColumbusUIListener.UIMessageDialog(const aMessage: string;
  const aDlgType: TMsgDlgType; const aButtons: TMsgDlgButtons;
  const aMessageCode: Integer): Integer;
begin
  Result := MessageDlg(aMessage, aDlgType, aButtons, 0);
end;

initialization

Assert(ColumbusDefaultUIListener = nil, 'ColumbusDefaultUIListener is not nil. UIListener unit is permitted');
ColumbusDefaultUIListener := TColumbusUIListener;

end.

unit ColumbusUIListenerInterface;

interface

uses
  {$IF CompilerVersion >= 20}
  System.UITypes,
  {$IFEND}
  Dialogs;

type
  IColumbusUIListener = interface
    ['{D30889BC-EF38-4471-B364-B3104EC4F897}']
    function UIMessageDialog(const aMessage: string;
      const aDlgType: TMsgDlgType; const aButtons: TMsgDlgButtons; const aMessageCode: Integer = 0): Integer;
    function UIConfirm(const aMessage: String): Boolean;
    function UIInputBox(const ACaption, APrompt, ADefault: string): string;
  end;

implementation

end.

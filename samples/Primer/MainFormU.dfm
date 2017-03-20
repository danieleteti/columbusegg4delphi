object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'ColumbusEgg4Delphi Primer'
  ClientHeight = 398
  ClientWidth = 813
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object DBGrid1: TDBGrid
    Left = 0
    Top = 25
    Width = 813
    Height = 311
    Align = alClient
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'CUST_NO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CUSTOMER'
        Width = 131
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTACT_FIRST'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTACT_LAST'
        Width = 87
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CITY'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STATE_PROVINCE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COUNTRY'
        Width = 68
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'POSTAL_CODE'
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 0
    Top = 0
    Width = 813
    Height = 25
    DataSource = DataSource1
    Align = alTop
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 336
    Width = 813
    Height = 62
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object lblItalianCustomer: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 33
      Width = 805
      Height = 25
      Align = alClient
      Alignment = taCenter
      Caption = 'Current customer is italian'
      Color = clHotLight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 217
      ExplicitHeight = 19
    end
    object lblCaliforniaPeopleCount: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 801
      Height = 19
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Label1'
      Layout = tlCenter
      ExplicitWidth = 46
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'ConnectionDef=employee_fb')
    Connected = True
    LoginPrompt = False
    Left = 480
    Top = 96
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 568
    Top = 280
  end
  object FDQuery1: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'select * from customer')
    Left = 544
    Top = 96
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 600
    Top = 96
  end
end

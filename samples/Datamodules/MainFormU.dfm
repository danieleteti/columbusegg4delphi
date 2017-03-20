object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 592
  ClientWidth = 1096
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object DBGrid1: TDBGrid
    Left = 0
    Top = 66
    Width = 1096
    Height = 205
    Align = alClient
    DataSource = DataSource1
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
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
        Width = 140
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
      end
      item
        Expanded = False
        FieldName = 'ON_HOLD'
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 0
    Top = 41
    Width = 1096
    Height = 25
    DataSource = DataSource1
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 1115
  end
  object Panel1: TPanel
    Left = 0
    Top = 271
    Width = 1096
    Height = 65
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 1115
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 1036
      Height = 57
      Align = alClient
      Caption = 'Label1'
      ExplicitWidth = 60
      ExplicitHeight = 25
    end
    object Label3: TLabel
      AlignWithMargins = True
      Left = 1046
      Top = 4
      Width = 46
      Height = 57
      Align = alRight
      Alignment = taRightJustify
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 1065
      ExplicitHeight = 19
    end
  end
  object DBGrid2: TDBGrid
    Left = 0
    Top = 336
    Width = 1096
    Height = 188
    Align = alBottom
    DataSource = DataSource2
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'PO_NUMBER'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SALES_REP'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ORDER_STATUS'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ORDER_DATE'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SHIP_DATE'
        Width = 133
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATE_NEEDED'
        Width = 143
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PAID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QTY_ORDERED'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL_VALUE'
        Visible = True
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 524
    Width = 1096
    Height = 68
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    ExplicitWidth = 1115
    object Label2: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 1088
      Height = 23
      Align = alTop
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 78
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 1096
    Height = 41
    Align = alTop
    TabOrder = 5
    ExplicitWidth = 1115
    object btnExport: TSpeedButton
      AlignWithMargins = True
      Left = 921
      Top = 4
      Width = 171
      Height = 33
      Action = actGeocoding
      Align = alRight
      ExplicitLeft = 939
    end
    object Button1: TSpeedButton
      AlignWithMargins = True
      Left = 744
      Top = 4
      Width = 171
      Height = 33
      Action = actExportCustomers
      Align = alRight
      ExplicitLeft = 762
    end
  end
  object DataSource1: TDataSource
    DataSet = DataModuleMain.dsCustomers
    Left = 320
    Top = 208
  end
  object DataSource2: TDataSource
    DataSet = DataModuleMain.dsSales
    Left = 328
    Top = 408
  end
  object SaveDialog1: TSaveDialog
    FileName = 'customers.csv'
    Filter = 'CSV Files|*.csv'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 456
    Top = 408
  end
  object ActionList1: TActionList
    Left = 464
    Top = 208
    object actExportCustomers: TAction
      Caption = 'Export Customers'
      ImageIndex = 1
      OnExecute = actExportCustomersExecute
    end
    object actGeocoding: TAction
      Caption = 'Geocoding'
      ImageIndex = 0
      OnExecute = actGeocodingExecute
    end
  end
end

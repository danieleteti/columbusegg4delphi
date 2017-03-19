object DataModuleMain: TDataModuleMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 356
  Width = 580
  object FDConnection1: TFDConnection
    Params.Strings = (
      'ConnectionDef=employee_fb')
    Connected = True
    LoginPrompt = False
    Left = 128
    Top = 48
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 136
    Top = 184
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 136
    Top = 232
  end
  object dsCustomers: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    UpdateOptions.AssignedValues = [uvUpdateMode, uvLockMode, uvRefreshMode, uvFetchGeneratorsPoint, uvGeneratorName, uvCheckRequired]
    UpdateOptions.UpdateMode = upWhereAll
    UpdateOptions.LockMode = lmOptimistic
    UpdateOptions.RefreshMode = rmAll
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'CUST_NO_GEN'
    UpdateOptions.KeyFields = 'CUST_NO'
    UpdateOptions.AutoIncFields = 'CUST_NO'
    SQL.Strings = (
      'select * from customer')
    Left = 221
    Top = 48
  end
  object dsrcCustomers: TDataSource
    DataSet = dsCustomers
    Left = 224
    Top = 120
  end
  object dsSales: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    MasterSource = dsrcCustomers
    MasterFields = 'CUST_NO'
    DetailFields = 'CUST_NO'
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evMode, evCache]
    FetchOptions.Mode = fmAll
    FetchOptions.Cache = [fiBlobs, fiMeta]
    UpdateOptions.AssignedValues = [uvUpdateMode, uvLockMode, uvRefreshMode, uvFetchGeneratorsPoint, uvGeneratorName, uvCheckRequired]
    UpdateOptions.UpdateMode = upWhereAll
    UpdateOptions.LockMode = lmOptimistic
    UpdateOptions.RefreshMode = rmAll
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'CUST_NO_GEN'
    UpdateOptions.KeyFields = 'CUST_NO'
    UpdateOptions.AutoIncFields = 'CUST_NO'
    SQL.Strings = (
      'select * from sales where cust_no = :cust_no')
    Left = 317
    Top = 48
    ParamData = <
      item
        Name = 'CUST_NO'
        DataType = ftAutoInc
        ParamType = ptInput
        Value = 1001
      end>
  end
end

unit GeocodingServiceU;

interface

type
  IGeocodingService = interface
    ['{EC38CF95-F982-4BFD-9EA8-D3837957D1B1}']
    procedure GetCoords(const City, State: String; out Lat, Lon: Extended);
  end;

  TGeocodingService = class(TInterfacedObject, IGeocodingService)
  private
    FGoogleApiKey: String;
  public
    constructor Create(GoogleAPIKey: string = '');
    procedure GetCoords(const City, State: String; out Lat, Lon: Extended);
  end;

implementation

uses
  System.Net.HTTPClient, System.NetEncoding, System.JSON, System.SysUtils;

  { TGeocodingService }

const
  GEOCODE_URL_WITH_KEY = 'https://maps.google.com/maps/api/geocode/json?' +
    '&address=%s&key=%s';
  GEOCODE_URL_NO_KEY = 'https://maps.google.com/maps/api/geocode/json?' +
    '&address=%s';

constructor TGeocodingService.Create(GoogleAPIKey: string);
begin
  FGoogleApiKey := GoogleAPIKey;
end;

procedure TGeocodingService.GetCoords(const City, State: String; out Lat,
  Lon: Extended);
var
  lHTTP: THTTPClient;
  lURL: string;
  lResp: IHTTPResponse;
  lJObj: TJSONObject;
  lJGeometry: TJSONObject;
  lJLocation: TJSONObject;
  lJNumber: TJSONNumber;
  sAddress: String;
  sStatus: string;
  sErrorMessage: string;
begin
  lHTTP := THttpClient.Create;
  try
    sAddress := ',' + TNetEncoding.URL.Encode(City) + ',' +
      TNetEncoding.URL.Encode(State);
    if FGoogleApiKey<>'' then
      lURL := Format(GEOCODE_URL_WITH_KEY, [sAddress, FGoogleApiKey])
    else
      lURL := Format(GEOCODE_URL_NO_KEY, [sAddress]);
    lResp := lHTTP.Get(lURL);
    lJObj := TJSONObject.ParseJSONValue(lResp.ContentAsString) as TJSONObject;
    try
      sStatus := lJObj.GetValue('status').Value;
      if sStatus = 'OK' then
      begin
        lJGeometry := (lJObj.GetValue('results') as TJSONArray).Items[0].GetValue<TJSONObject>('geometry');
        lJLocation := lJGeometry.GetValue('location') as TJSONObject;
        if lJLocation.TryGetValue<TJSONNumber>('lat', lJNumber) then
          Lat := lJNumber.AsDouble;
        if lJLocation.TryGetValue<TJSONNumber>('lng', lJNumber) then
          Lon := lJNumber.AsDouble;
      end
      else
      begin
        sErrorMessage := lJObj.GetValue('error_message').Value;
        raise Exception.Create('Impossibile geocoding: ' + sStatus + sLineBreak
          + 'message:' + sErrorMessage);
      end;
    finally
      lJObj.Free;
    end;
  finally
    lHTTP.Free;
  end;
end;

end.

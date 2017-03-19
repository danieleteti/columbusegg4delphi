unit GeocodingServiceU;

interface

type
  IGeocodingService = interface
    ['{EC38CF95-F982-4BFD-9EA8-D3837957D1B1}']
    procedure GetCoords(const City, State: String; out Lat, Lon: Extended);
  end;

  TGeocodingService = class(TInterfacedObject, IGeocodingService)
  public
    procedure GetCoords(const City, State: String; out Lat, Lon: Extended);
  end;

implementation

uses
  System.Net.HTTPClient, System.NetEncoding, System.JSON, System.SysUtils;

const
  GEOCODEURL = 'http://maps.google.com/maps/api/geocode/json?address=';

  { TGeocodingService }

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
begin
  lHTTP := THttpClient.Create;
  try
    lURL := GEOCODEURL + ',' + TNetEncoding.URL.Encode(City) + ',' + TNetEncoding.URL.Encode(State);
    lResp := lHTTP.Get(lURL);
    lJObj := TJSONObject.ParseJSONValue(lResp.ContentAsString) as TJSONObject;
    try
      if lJObj.GetValue('status').Value = 'OK' then
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
        raise Exception.Create('Impossibile geocoding: ' + lJObj.GetValue('status').Value);
      end;
    finally
      lJObj.Free;
    end;
  finally
    lHTTP.Free;
  end;
end;

end.

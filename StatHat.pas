unit StatHat;

interface

procedure EzPostCount(const EzKey, Stat: string; Count: Double);
procedure EzPostValue(const EzKey, Stat: string; Value: Double);

implementation

uses
  IdHTTP,
  Classes,
  SysUtils;

const
  EzURL = 'http://api.stathat.com/ez';

procedure Post(Params: TStrings);
var
  HTTP: TIdHTTP;
begin
  HTTP := TIdHTTP.Create(nil);
  try
    HTTP.Post(EzURL, Params);
  finally
    HTTP.Free;
  end;
end;

function ConvertDouble(Value: Double): string;
var
  FS: TFormatSettings;
begin
  FS.DecimalSeparator := '.';
  Result := FloatToStr(Value, FS);
end;

procedure EzPostCount(const EzKey, Stat: string; Count: Double);
var
  Params: TStringList;
begin
  Params := TStringList.Create;
  try
    Params.Values['ezkey'] := EzKey;
    Params.Values['stat'] := Stat;
    Params.Values['count'] := ConvertDouble(Count);
    Post(Params);
  finally
    Params.Free;
  end;
end;

procedure EzPostValue(const EzKey, Stat: string; Value: Double);
var
  Params: TStringList;
begin
  Params := TStringList.Create;
  try
    Params.Values['ezkey'] := EzKey;
    Params.Values['stat'] := Stat;
    Params.Values['value'] := ConvertDouble(Value);
    Post(Params);
  finally
    Params.Free;
  end;
end;

end.

unit StatHat;

interface

uses
  Classes;

type
  TErrorHandler = reference to procedure(ErrorMessage: string);

procedure EzPostCount(const EzKey, Stat: string; Count: Double; ErrorHandler: TErrorHandler = nil);
procedure EzPostValue(const EzKey, Stat: string; Value: Double; ErrorHandler: TErrorHandler = nil);

implementation

uses
  IdHTTP,
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

procedure EzPost(const EzKey, Stat, StatType: string; StatValue: Double; ErrorHandler: TErrorHandler);
var
  Params: TStringList;
  ErrorMessage: string;
begin
  Params := TStringList.Create;
  try
    try
      Params.Values['ezkey'] := EzKey;
      Params.Values['stat'] := Stat;
      Params.Values[StatType] := ConvertDouble(StatValue);
      Post(Params);
    except
      on e: Exception do
      begin
        ErrorMessage := e.Message;
        if Assigned(ErrorHandler) then
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              ErrorHandler(ErrorMessage)
            end);
        end;
      end;
    end;
  finally
    Params.Free;
  end;
end;

procedure EzPostAsync(const EzKey, Stat, StatType: string; StatValue: Double; ErrorHandler: TErrorHandler);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      EzPost(EzKey, Stat, StatType, StatValue, ErrorHandler);
    end).Start;
end;

procedure EzPostCount(const EzKey, Stat: string; Count: Double; ErrorHandler: TErrorHandler = nil);
begin
  EzPostAsync(EzKey, Stat, 'count', Count, ErrorHandler);
end;

procedure EzPostValue(const EzKey, Stat: string; Value: Double; ErrorHandler: TErrorHandler = nil);
begin
  EzPostAsync(EzKey, Stat, 'value', Value, ErrorHandler);
end;

end.
